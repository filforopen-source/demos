import { onSchedule } from "firebase-functions/v2/scheduler";
import { logger } from "firebase-functions/logger";
import { db } from "../common";

export const archiveOrders = onSchedule("every 1 hours", async (event) => {
  // Archival threshold.
  const maxAgeInHours = 4;
  const cutoff = new Date(Date.now() - maxAgeInHours * 60 * 60 * 1000); 

  const snapshot = await db.collection("latteOrderMetadata")
    .where("status", "==", "completed")
    .where("completionTime", "<", cutoff)
    .get();

  if (snapshot.empty) {
    logger.info("Did not find any new orders to archive");
    return;
  }

  const docs = snapshot.docs;
  const chunkSize = 500;

  for (let i = 0; i < docs.length; i += chunkSize) {
    const batch = db.batch();
    const chunk = docs.slice(i, i + chunkSize);
    
    chunk.forEach((doc) => {
      batch.update(doc.ref, { status: "archived" });
    });

    await batch.commit();
  }

  logger.info(`Archived ${docs.length} orders`);
});
