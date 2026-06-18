import {
  onDocumentCreated,
  onDocumentDeleted,
} from "firebase-functions/v2/firestore";
import {getAuth} from "firebase-admin/auth";
import * as logger from "firebase-functions/logger";

/**
 * Triggered when a document is created at roles/{role}/users/{uid}.
 * Grants the specified custom claim to the user.
 */
export const onUserRoleCreated = onDocumentCreated(
  {
    document: "roles/{role}/users/{uid}",
    database: "DATABASE_ID_PLACEHOLDER",
  },
  async (event) => {
    const {role, uid} = event.params;

    try {
      const auth = getAuth();
      const user = await auth.getUser(uid);
      const existingClaims = user.customClaims || {};

      const newClaims = {...existingClaims, [role]: true};
      await auth.setCustomUserClaims(uid, newClaims);

      logger.info(`Granted role '${role}' to user ${uid}`);
    } catch (error) {
      logger.error(`Error granting role '${role}' to user ${uid}:`, error);
    }
  });

/**
 * Triggered when a document is deleted at roles/{role}/users/{uid}.
 * Removes the specified custom claim from the user.
 */
export const onUserRoleDeleted = onDocumentDeleted(
  {
    document: "roles/{role}/users/{uid}",
    database: "DATABASE_ID_PLACEHOLDER",
  },
  async (event) => {
    const {role, uid} = event.params;

    try {
      const auth = getAuth();
      const user = await auth.getUser(uid);
      const existingClaims = user.customClaims || {};

      if (role in existingClaims) {
        const newClaims = {...existingClaims};
        delete newClaims[role];
        await auth.setCustomUserClaims(uid, newClaims);
        logger.info(`Removed role '${role}' from user ${uid}`);
      } else {
        logger.info(
          `User ${uid} did not have role '${role}'. No action taken.`);
      }
    } catch (error) {
      logger.error(`Error removing role '${role}' from user ${uid}:`, error);
    }
  });
