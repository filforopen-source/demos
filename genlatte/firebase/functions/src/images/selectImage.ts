import { onCall } from "firebase-functions/https";
import { logger } from "firebase-functions/logger";
import { db } from "../common";

export const selectImage = onCall({
    
}, async (request) => {
    const { imageBatchId, imageIndex } = request.data;
    const latteImageBatchDoc = db.collection("latteImageBatches").doc(imageBatchId);
    const latteImageBatchData = await latteImageBatchDoc.get();
    const imageUrl = latteImageBatchData.data()?.[imageIndex]?.imageUrl;
    const orderId = latteImageBatchData.data()?.orderId;
    logger.info(`selectImage called for orderId: ${orderId}`);
    const latteOrderMetadataRef = db.collection("latteOrderMetadata").doc(orderId);
    await latteOrderMetadataRef.update({
        "imageUrl": imageUrl,
        // Do not set status == submitted here; that is its own step 
        // separate from selecting an image
    });
});