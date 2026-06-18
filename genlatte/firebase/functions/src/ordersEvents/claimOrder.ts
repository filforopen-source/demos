import { onCall, HttpsError } from "firebase-functions/https";
import { db } from "../common";
import { logger } from "firebase-functions/logger";

export const claimOrder = onCall({
    
}, async (request) => {
    const { orderId, baristaId } = request.data;
    logger.info(`claimOrder called with orderId: ${orderId}`);

    if (!orderId || !baristaId) {
        throw new HttpsError(
            "invalid-argument",
            "The 'orderId' and 'baristaId' arguments are required."
        );
    }

    const latteOrderMetadataRef = db.collection("latteOrderMetadata").doc(orderId);
    const docSnap = await latteOrderMetadataRef.get();

    if (!docSnap.exists) {
        throw new HttpsError("not-found", "Order not found.");
    }

    if (docSnap.data()?.baristaId !== null) {
        throw new HttpsError("failed-precondition", "Order is already claimed.");
    }

    await latteOrderMetadataRef.update({
        status: "inProgress",
        baristaId: baristaId,
    });
});
