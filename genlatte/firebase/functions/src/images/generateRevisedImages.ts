import { onCall } from "firebase-functions/https";
import { db } from "../common";
import { SEVEN_DAYS_MILLIS } from "../ordersEvents/common";
import { generateRevisedImagesPrompts } from "./promptsForHappyPlace";
import { word_moderation } from "../moderation";
import { logger } from "firebase-functions/logger";
import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { getFunctions } from "firebase-admin/functions";



export const generateRevisedImages = onCall({
    memory: "8GiB",
    timeoutSeconds: 540,
}, async (request) => {
    const { imageBatchId, imageIndex, answers } = request.data;
    const existingBatchImg = await db.collection("latteImageBatches").doc(imageBatchId).get();
    const existingBatchImgData = existingBatchImg.data();
    const previousPrompt = existingBatchImgData?.[`${imageIndex}`].prompt;
    const orderId = existingBatchImgData?.orderId;
    logger.info(`generateRevisedImages called for orderId: ${orderId}`);

    const answersToQuestions: string = (await Promise.all(Object.entries(answers).map(async ([questionId, answerValue]: [string, any]) => {
        const questionMap = existingBatchImgData?.[`${imageIndex}`].questions?.find((q: any) => {
            logger.info(`${q.id} vs ${questionId}`);
            return q.id === questionId;
        });
        const question = questionMap?.question;

        logger.info(`Processing answer for question ${questionId}: ${question} :: ${answerValue}`);

        /// Only text questions have UCG as answers. The other question types only choose from
        /// Gemini-provided options.
        if (question.type === "textQuestion") {
            const {moderation} = await word_moderation(answerValue, orderId);
            if(!moderation.isAllowed) {
                logger.log(`Answer ${answerValue} contains profane language.`);
                answerValue = "Smiley Face";
            }
        }
        return `${question}: ${answerValue}`;
    }))).join('\n');

    const revisedPrompts = await generateRevisedImagesPrompts(previousPrompt, answersToQuestions, orderId);

    const latteImageBatchDoc = db.collection("latteImageBatches").doc();
    await latteImageBatchDoc.create({
            orderId: orderId,
            createdAt: FieldValue.serverTimestamp(),
            expireAt: Timestamp.fromMillis(Date.now() + SEVEN_DAYS_MILLIS),
            parent: {
                id: imageBatchId,
                imageIndex: imageIndex
            }
        });

    const latteOrderMetadataRef = db.collection("latteOrderMetadata").doc(orderId);

    await latteOrderMetadataRef.update({
        "imageBatchId": latteImageBatchDoc.id,
    });

    for(let i = 0; i < revisedPrompts.length; i++) {
        getFunctions().taskQueue("taskGenerateImageBranchSuffix").enqueue({
            prompt: revisedPrompts[i],
            imageBatchId: latteImageBatchDoc.id,
            index: i,
            isRevision: true
        });
    }
});
