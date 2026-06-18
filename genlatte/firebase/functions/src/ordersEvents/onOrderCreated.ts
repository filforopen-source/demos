import { getFirestore, Timestamp } from "firebase-admin/firestore";
import { onDocumentCreated } from "firebase-functions/firestore";
import { logger } from "firebase-functions/logger";
import { DATABASE_NAME, SEVEN_DAYS_MILLIS } from "./common";

/**
 * Triggered when a new order is created.
 * Increments a daily counter and assigns an orderNumber to the order.
 */
export const onOrderCreated = onDocumentCreated(
  {
    document: "latteOrders/{orderId}",
    database: DATABASE_NAME,
  },
  async (event) => {
    logger.info(`onOrderCreated called with orderId: ${event.params.orderId}`);
    const db = getFirestore(DATABASE_NAME);
    const orderRef = event.data?.ref;

    if (!orderRef) {
      logger.error("No order reference found in event data.");
      return;
    }

    const orderRefId = event.data?.id;
    if (!orderRefId) {
      logger.error("No order reference ID found in event data.");
      return;
    }

    orderRef.update({
      expiresAt: Timestamp.fromMillis(Date.now() + SEVEN_DAYS_MILLIS)
    });

    const latteOrderMetadataRef = db.collection("latteOrderMetadata").doc(orderRefId);

    try {
      await db.runTransaction(async (transaction) => {
        transaction.create(latteOrderMetadataRef, { 
          expireAt: Timestamp.fromMillis(Date.now() + SEVEN_DAYS_MILLIS)
        });
      });

      logger.info(
        `Successfully created latte order metadata for ${event.params.orderId} `);
    } catch (error) {
      logger.error(`Error processing order ${event.params.orderId}:`, error);
    }
  });