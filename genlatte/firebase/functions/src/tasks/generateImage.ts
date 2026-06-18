import { onTaskDispatched } from "firebase-functions/tasks";
import { generateDescription, generateImageWithPro } from "../images";
import { getStorage } from "firebase-admin/storage";
import { getFirestore } from "firebase-admin/firestore";
import { getFunctions } from "firebase-admin/functions";
import { logger } from "firebase-functions/logger";
import { fetchRemoteConfigValues } from "../common/fetchRemoteConfig";

const DATABASE_NAME = process.env.FUNCTIONS_EMULATOR === 'true' ? '(default)' : 'DATABASE_ID_PLACEHOLDER';
const db = getFirestore(DATABASE_NAME);

export const taskGenerateImage = onTaskDispatched({
    retryConfig: {
        maxAttempts: 5,
        minBackoffSeconds: 1,
        maxBackoffSeconds: 20,
    },
    concurrency: 1,
    minInstances: 8,
    maxInstances: 80,
    memory: "8GiB",
    timeoutSeconds: 540,
}, async (request) => {
    const { prompt, imageBatchId, index, isRevision = false } = request.data;
    const latteImageBatchDoc = db.collection("latteImageBatches").doc(imageBatchId);
    const latteImageBatchData = await latteImageBatchDoc.get();
    const orderId = latteImageBatchData.data()?.orderId;
    logger.info(`taskGenerateImage called for orderId: ${orderId}`);
    
    const imagePath = `latteImages/${imageBatchId}/${index}.png`;
    // run multiple of these using the remote config value AIR_CONDITIONING_QUOTENT and take the first
    // result for the image
    const {imageParallelism} = await fetchRemoteConfigValues();
    const generateImagesPromises = [];
    for(let i = 0; i < imageParallelism; i++) {
        generateImagesPromises.push(generateImageWithPro(prompt, orderId));
    }
    const result = await Promise.any(generateImagesPromises);
    const storageImage = getStorage().bucket().file(imagePath);
    const base64String = result.image.split(',')[1];
    const imageBuffer = Buffer.from(base64String, 'base64');
    await storageImage.save(imageBuffer, { contentType: "image/png" });
    await storageImage.makePublic();
    const imageUrl = await storageImage.publicUrl();
    await latteImageBatchDoc.update({
        [`image${index}`]: {
        id: crypto.randomUUID(),
        imageUrl: imageUrl,
        prompt: result.prompt,
        description: await generateDescription(base64String, orderId),
        }
    });
    if(!isRevision) {
        await getFunctions().taskQueue("taskGenerateQuestionsBranchSuffix").enqueue({
            imageBatchId: imageBatchId,
            index: index,
            storageImagePath: imagePath,
        });
    }
});