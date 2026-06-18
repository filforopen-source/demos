import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { onCall, HttpsError } from "firebase-functions/https";
import { logger } from "firebase-functions/logger";
import { db } from "../common";
import { SEVEN_DAYS_MILLIS } from "./common";

export const completeOrder = onCall({
    
}, async (request) => {
    const { orderId, baristaId } = request.data;
    logger.info(`completeOrder called with orderId: ${orderId}`);

    if (!orderId || !baristaId) {
        throw new HttpsError(
            "invalid-argument",
            "The 'orderId' and 'baristaId' arguments are required."
        );
    }

    const latteOrderRef = db.collection("latteOrders").doc(orderId);
    const latteOrderMetadataRef = db.collection("latteOrderMetadata").doc(orderId);
    
    const orderDocSnap = await latteOrderRef.get();
    const metadataDocSnap = await latteOrderMetadataRef.get();

    if (!metadataDocSnap.exists || !orderDocSnap.exists) {
        throw new HttpsError("not-found", "Order not found.");
    }

    const metadata = metadataDocSnap.data();
    const orderData = orderDocSnap.data();

    if (!metadata) {
        throw new HttpsError(
            "not-found",
            `Order metadata for ${orderId} not found.`
        );
    }

    if (!orderData) {
        throw new HttpsError(
            "not-found",
            `Order data for ${orderId} not found.`
        );
    }

    if (baristaId != "moderator" && metadata.baristaId !== baristaId) {
        throw new HttpsError(
            "permission-denied",
            `The provided baristaId ${baristaId} does not match the assigned barista for order ${orderId}.`
        );
    }

    await latteOrderMetadataRef.update({
        status: "completed",
        completionTime: FieldValue.serverTimestamp(),
    });

    await pushToRecentLatteImages(orderId, orderData, metadata);
});

/**
 * Adds a completed latte order's image to the public recentLatteImages gallery
 * if it has been approved.
 */
async function pushToRecentLatteImages(
    orderId: string,
    orderData: any,
    metadata: any
) {
    const imageBatchRef = db.collection("latteImageBatches").doc(metadata.imageBatchId);
    const imageBatchSnap = await imageBatchRef.get();
    const imageBatchData = imageBatchSnap.data();

    if (!imageBatchSnap.exists || !imageBatchData) {
        logger.error(
            `Image batch for ${orderId} not found. Cannot send to recentLatteImages. Also, wtf?`
        );
        return;
    }

    if (metadata.isImageApproved !== true) {
        logger.error(
            `Image for ${orderId} not approved. Not sending to recentLatteImages.`
        );
        return;
    }

    if (metadata.isNameApproved !== true) {
        logger.error(
            `Name for ${orderId} not approved. Not sending to recentLatteImages.`
        );
        return;
    }

    const fields = ["image0", "image1", "image2", "image3"];
    for (const field of fields) {
        const image = imageBatchData[field];
        if (image.imageUrl === metadata.imageUrl) {
            await db.collection("recentLatteImages").add({
                imageUrl: image.imageUrl,
                prompt: image.prompt,
                name: orderData.name,
                happyPlace: orderData.happyPlace,
                description: image.description,
                createdAt: FieldValue.serverTimestamp(),
                expireAt: Timestamp.fromMillis(Date.now() + SEVEN_DAYS_MILLIS),
            });
            logger.info(`Order ${orderId} completed and image added to recentLatteImages`);
            break;
        }
    }
}

