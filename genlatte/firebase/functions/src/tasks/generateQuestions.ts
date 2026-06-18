import { onTaskDispatched } from "firebase-functions/tasks";
import { getStorage } from "firebase-admin/storage";
import { getFirestore } from "firebase-admin/firestore";
import { reviseImageQuestionGenerator } from "../reviser/reviseImageQuestionGen";
import { logger } from "firebase-functions/logger";

const DATABASE_NAME = process.env.FUNCTIONS_EMULATOR === 'true' ? '(default)' : 'DATABASE_ID_PLACEHOLDER';
const db = getFirestore(DATABASE_NAME);

export const taskGenerateQuestions = onTaskDispatched({
    retryConfig: {
        maxAttempts: 5,
        minBackoffSeconds: 1,
        maxBackoffSeconds: 20,
    },
    memory: "8GiB",
    timeoutSeconds: 540,
}, async (request) => {
    const { imageBatchId, index, storageImagePath } = request.data;
    const latteImageBatchDoc = db.collection("latteImageBatches").doc(imageBatchId);
    const latteImageBatchData = await latteImageBatchDoc.get();
    const orderId = latteImageBatchData.data()?.orderId;
    logger.info(`taskGenerateQuestions called for orderId: ${orderId}`);

    const storageImage = getStorage().bucket().file(storageImagePath);
    const [imageBuffer] = await storageImage.download();
    const base64String = imageBuffer.toString('base64');

    const questions = await reviseImageQuestionGenerator(base64String, orderId);
    console.log(questions);
    logger.info(questions);
    if (questions) {
        const questionsWithIds = questions.map((q: any) => ({
            ...q,
            id: crypto.randomUUID()
        }));
        await latteImageBatchDoc.update({
            [`image${index}.questions`]: questionsWithIds,
        });
    }
});