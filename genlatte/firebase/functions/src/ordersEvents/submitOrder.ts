import { onCall, HttpsError } from "firebase-functions/https";
import { DocumentReference, FieldValue, getFirestore } from "firebase-admin/firestore";
import { db } from "../common";
import { DATABASE_NAME } from "./common";
import { logger } from "firebase-functions/logger";
import { getRemoteConfig } from "firebase-admin/remote-config";

export const submitOrder = onCall({
    
}, async (request) => {
    logger.info(`submitOrder called with data: ${JSON.stringify(request.data)}`);
    const { orderId } = request.data;

    logger.info(`submitOrder called with orderId: ${orderId}`);
    if (!orderId) {
        throw new HttpsError(
            "invalid-argument",
            "The 'orderId' argument is required."
        );
    }

    const latteOrderMetadataRef = db.collection("latteOrderMetadata").doc(orderId);
    const latteOrderRef = db.collection("latteOrders").doc(orderId);
    const metadataDocSnap = await latteOrderMetadataRef.get();
    const orderDocSnap = await latteOrderRef.get();

    if (!metadataDocSnap.exists || !orderDocSnap.exists) {
        throw new HttpsError("not-found", "Order not found.");
    }

    const metadata = metadataDocSnap.data();
    const orderData = orderDocSnap.data();
    if (!metadata || !orderData) {
        throw new HttpsError("not-found", `Order ${orderId} has empty data.`);
    }
    logger.info(`latteOrderMetadata data: ${JSON.stringify(metadata)}`);
    
    if(metadata.orderNumber === null || metadata.orderNumber === undefined) {
        await assignOrderNumber(orderId, latteOrderMetadataRef);
    }

    if (metadata.imageUrl === null) {
        logger.info(`submitOrder missing imageUrl`);
        throw new HttpsError(
            "failed-precondition",
            "Cannot submit order until an image has been selected."
        );
    }

    await latteOrderMetadataRef.update({
        status: "submitted",
        orderSubmittedTime: FieldValue.serverTimestamp(),
    });
});

const assignOrderNumber = async (orderId: string, latteOrderMetadataRef: DocumentReference) => {
        const db = getFirestore(DATABASE_NAME);
        const orderRef = db.collection("latteOrders").doc(orderId);
    
        if (!orderRef) {
          logger.error("No order reference found in event data.");
          return;
        }
    
        // Format today's date as YYYY-MM-DD
        const now = new Date();
        const dateId = now.toISOString().split("T")[0];
    
        // Fetch NUM_SHARDS from Remote Config
        // Control from remote config to limit the requirement
        // to redeploy the function
        const rc = getRemoteConfig();
        let NUM_SHARDS = 10;
        try {
          const template = await rc.getServerTemplate({
            defaultConfig: {
              NUM_SHARDS: 10,
            },
          });
          const config = template.evaluate();
          NUM_SHARDS = config.getNumber("NUM_SHARDS_BRANCH_SUFFIX");
          logger.info(`Using Remote Config NUM_SHARDS: ${NUM_SHARDS}`);
        } catch (err) {
          logger.warn(
            "Failed to fetch Remote Config, using default NUM_SHARDS=10", err);
        }
    
        const shardId = Math.floor(Math.random() * NUM_SHARDS);
        const counterRef = db.collection("orderCount").doc(dateId)
          .collection("shards").doc(shardId.toString());
    
        try {
          await db.runTransaction(async (transaction) => {
            const counterDoc = await transaction.get(counterRef);
            let currentShardCount = 0;
    
            if (counterDoc.exists) {
              currentShardCount = counterDoc.data()?.count || 0;
            }
    
            const newShardCount = currentShardCount + 1;
    
            // Calculate a unique order number across shards:
            // (newCount - 1) * NUM_SHARDS + shardId + 1
            const orderNumber = (newShardCount - 1) * NUM_SHARDS + shardId + 1;
    
            transaction.set(counterRef, { count: newShardCount }, { merge: true });
            transaction.update(orderRef, { orderNumber: orderNumber });
            transaction.update(latteOrderMetadataRef, { orderNumber: orderNumber });
          });
    
          logger.info(
            `Successfully assigned orderNumber to ${orderId} ` +
            `for date ${dateId} (Shard ${shardId})`);
        } catch (error) {
          logger.error(`Error processing order ${orderId}:`, error);
        }   
}