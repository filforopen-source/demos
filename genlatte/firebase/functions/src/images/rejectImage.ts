import { onCall } from "firebase-functions/https";
import { logger } from "firebase-functions/logger";
import { db } from "../common";

export const rejectRevision = onCall({

}, async (request) => {
    const { imageBatchId  } = request.data;
    const latteImageBatchDoc = db.collection("latteImageBatches").doc(imageBatchId);
    const latteImageBatchData = await latteImageBatchDoc.get();
    const orderId = latteImageBatchData.data()?.orderId;
    logger.info(`rejectRevision called for orderId: ${orderId}`);
    logger.log(`Rejecting LatteImageBatch ${imageBatchId} for Order ${orderId}`);
    const parentImageBatchId = latteImageBatchData.data()?.parent.id;
    logger.log(`Reverting OrderId ${orderId} to LatteImageBatch ${parentImageBatchId}`);
    const latteOrderMetadataRef = db.collection("latteOrderMetadata").doc(orderId);
    await latteOrderMetadataRef.update({
        "imageBatchId": parentImageBatchId
    });
})