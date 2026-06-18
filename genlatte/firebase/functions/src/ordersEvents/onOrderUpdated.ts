import { FieldValue, Firestore, getFirestore, Timestamp } from "firebase-admin/firestore";
import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { logger } from "firebase-functions/logger";
import { DATABASE_NAME, SEVEN_DAYS_MILLIS } from "./common";
import { word_moderation } from "../moderation";
import { generatePromptsForHappyPlace } from "../images";
import { getFunctions } from "firebase-admin/functions";

export const onOrderUpdate = onDocumentUpdated(
  {
    document: "latteOrders/{orderId}",
    database: DATABASE_NAME,
    memory: "1GiB",
    cpu: 1,
    concurrency: 2,
    minInstances: 1,
    timeoutSeconds: 540,
  },
  async (event) => {
    logger.info(`onOrderUpdate called with orderId: ${event.params.orderId}`);
    const db = getFirestore(DATABASE_NAME);
    const orderBeforeUpdate = event.data?.before;
    const orderAfterUpdate = event.data?.after;

    if(!orderBeforeUpdate?.exists){
      logger.info("Order created. Runs on create command listed above.");
      return;
    }

    if(!orderAfterUpdate){
      logger.info("Order deleted.");
      db.collection("latteOrderMetadata").doc(event.params.orderId).delete();
      return;
    }

    if (!orderAfterUpdate.exists) {
      logger.error("No order reference found in event data.");
      return;
    }
    
    const latteOrderMetadataRef = db.collection("latteOrderMetadata").doc(orderAfterUpdate.ref.id);
    if(orderBeforeUpdate?.data().happyPlace !== orderAfterUpdate.data().happyPlace){
      logger.info("Happy place updated.");
      await latteOrderMetadataRef.update({ 
        isHappyPlaceApproved: null, 
        happyPlaceModerationReason: null 
      });
    }
    const oldHappyPlace = orderBeforeUpdate?.data().happyPlace;
    const happyPlace = orderAfterUpdate.data().happyPlace;
    
    if(happyPlace && happyPlace !== oldHappyPlace) {
      const { generatePromptRequest, latteImageBatchDoc } = await createImageBatchDoc(db, happyPlace as string, event.params.orderId, orderAfterUpdate.ref.id);
      for(let i = 0; i < generatePromptRequest.length; i++) {
          getFunctions().taskQueue("taskGenerateImageBranchSuffix").enqueue({
            prompt: generatePromptRequest[i],
            imageBatchId: latteImageBatchDoc.id,
            index: i
          });
      }
      const {moderation} = await word_moderation(happyPlace as string, event.params.orderId);

      // We check whether the happy place has been changed under our hands.
      // If so, we don't want to update the imageBatchId.
      let currentOrderSnap = await orderAfterUpdate.ref.get();
      if (currentOrderSnap.data()?.happyPlace !== happyPlace) {
        logger.info(`Order ${event.params.orderId} happy place changed during generation. Aborting.`);
      } else {
        if(!moderation.isAllowed) {
          logger.info(`Order ${event.params.orderId} contains profane language.`);
        }

        await latteOrderMetadataRef.update({ 
          isHappyPlaceApproved: moderation.isAllowed, 
          happyPlaceModerationReason: moderation.moderationReason,
          ...(moderation.isAllowed && { imageBatchId: latteImageBatchDoc.id })
        });
      }
    }
  });

async function createImageBatchDoc(db: Firestore, happyPlace: string, eventOrderId: string, orderAfterUpdateId: string) {
  const latteImageBatchesCollection = db.collection("latteImageBatches");
  const generatePromptRequest = await generatePromptsForHappyPlace(happyPlace, eventOrderId);
  const latteImageBatchDoc = latteImageBatchesCollection.doc();
  await latteImageBatchDoc.create({
      orderId: orderAfterUpdateId,
      createdAt: FieldValue.serverTimestamp(),
      expireAt: Timestamp.fromMillis(Date.now() + SEVEN_DAYS_MILLIS),
  });

  return { generatePromptRequest, latteImageBatchDoc };
}
