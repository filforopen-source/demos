/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import { setGlobalOptions } from "firebase-functions";
import * as admin from "firebase-admin";

// Initialize Admin SDK
admin.initializeApp();

setGlobalOptions({ maxInstances: 10, minInstances: 1 });

// Role-based custom claims
import { onUserRoleCreated, onUserRoleDeleted } from "./userEvents";
export { onUserRoleCreated as onUserRoleCreatedBRANCH_SUFFIX };
export { onUserRoleDeleted as onUserRoleDeletedBRANCH_SUFFIX };

// Order counter
import { onOrderCreated, onOrderDelete, onOrderUpdate, archiveOrders, claimOrder, completeOrder, submitOrder } from "./ordersEvents";
export { onOrderCreated as onOrderCreatedBRANCH_SUFFIX };
export { onOrderDelete as onOrderDeleteBRANCH_SUFFIX };
export { onOrderUpdate as onOrderUpdateBRANCH_SUFFIX };
export { archiveOrders as archiveOrdersBRANCH_SUFFIX };
export { claimOrder as claimOrderBRANCH_SUFFIX };
export { completeOrder as completeOrderBRANCH_SUFFIX };
export { submitOrder as submitOrderBRANCH_SUFFIX };

// Image generation is event driven, not arbitrary

// Moderation
import { moderation } from "./moderation";
export { moderation as moderationBRANCH_SUFFIX };

// Prompt reviser
// import { revisePrompt } from "./reviser";
// export { revisePrompt as revisePrompt_BRANCH_SUFFIX };

import { taskGenerateImage } from "./tasks/generateImage";
export { taskGenerateImage as taskGenerateImageBranchSuffix };

import { taskGenerateQuestions } from "./tasks/generateQuestions";
export { taskGenerateQuestions as taskGenerateQuestionsBranchSuffix };

import { generateRevisedImages, rejectRevision, selectImage } from "./images";
export { 
    generateRevisedImages as generateRevisedImagesBranchSuffix, 
    rejectRevision as rejectRevisionBranchSuffix, 
    selectImage as selectImageBranchSuffix 
};

import { sendToPrinter } from "./sendToPrinter";
export { sendToPrinter as sendToPrinterBRANCH_SUFFIX };
