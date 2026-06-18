import { getFirestore } from "firebase-admin/firestore";
import { logger } from "firebase-functions/logger";
import { onDocumentDeleted } from "firebase-functions/firestore";
import { DATABASE_NAME } from "./common";

export const onOrderDelete = onDocumentDeleted(
  {
    document: "latteOrders/{orderId}",
    database: DATABASE_NAME,
  },
  async (event) => {
    logger.info(`onOrderDelete called with orderId: ${event.params.orderId}`);
    const db = getFirestore(DATABASE_NAME);
    const orderId = event.params.orderId;

    console.log(`Document ${orderId} deleted from latteOrders. Cleaning up latteOrderMetadata...`);

    try {
        // Reference the corresponding document in the other collection
        const targetRef = db.collection("latteOrderMetadata").doc(orderId);

        // Perform the delete operation
        await targetRef.delete();
        
        console.log(`Successfully deleted matching document ${orderId} from latteOrderMetadata.`);
    } catch (error) {
        console.error(`Error deleting document ${orderId} from latteOrderMetadata:`, error);
    }
    
});