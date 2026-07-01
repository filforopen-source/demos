import { getFirestore } from "firebase-admin/firestore";

const DATABASE_NAME = process.env.FUNCTIONS_EMULATOR === 'true' ? '(default)' : 'DATABASE_ID_PLACEHOLDER';
const db = getFirestore(DATABASE_NAME);

export { db };