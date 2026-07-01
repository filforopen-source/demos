const { assertFails, assertSucceeds, initializeTestEnvironment } = require('@firebase/rules-unit-testing');
const { doc, setDoc, updateDoc, getDoc, deleteDoc } = require('firebase/firestore');
const { readFileSync } = require('fs');
const path = require('path');

let testEnv;

before(async () => {
    testEnv = await initializeTestEnvironment({
        projectId: 'demo-latteimagebatches-rules',
        firestore: {
            rules: readFileSync(path.resolve(__dirname, '../firestore.rules'), 'utf8'),
            host: '127.0.0.1',
            port: 8080
        },
    });
});

beforeEach(async () => {
    await testEnv.clearFirestore();

    // setup prerequisite data using bypass
    await testEnv.withSecurityRulesDisabled(async (context) => {
        const db = context.firestore();
        await setDoc(doc(db, 'latteImageBatches/existing_batch'), { status: 'pending' });
    });
});

after(async () => {
    if (testEnv) {
        await testEnv.cleanup();
    }
});

describe('latteImageBatches Rules', () => {

    let kioskDb;
    let baristaDb;
    let unauthDb;

    beforeEach(() => {
        kioskDb = testEnv.authenticatedContext('kiosk_user', { kiosk: true }).firestore();
        baristaDb = testEnv.authenticatedContext('barista_user', { barista: true }).firestore();
        unauthDb = testEnv.unauthenticatedContext().firestore();
    });

    describe('Read', () => {
        it('should allow kiosk to read batches', async () => {
            const ref = doc(kioskDb, 'latteImageBatches/existing_batch');
            await assertSucceeds(getDoc(ref));
        });

        it('should allow barista to read batches', async () => {
            const ref = doc(baristaDb, 'latteImageBatches/existing_batch');
            await assertSucceeds(getDoc(ref));
        });

        it('should deny unauthed from reading batches', async () => {
            const ref = doc(unauthDb, 'latteImageBatches/existing_batch');
            await assertFails(getDoc(ref));
        });
    });

    describe('Write', () => {
        it('should allow barista to create batches', async () => {
            const ref = doc(baristaDb, 'latteImageBatches/new_batch');
            await assertSucceeds(setDoc(ref, { status: 'new' }));
        });

        it('should deny kiosk from creating batches', async () => {
            const ref = doc(kioskDb, 'latteImageBatches/new_batch');
            await assertFails(setDoc(ref, { status: 'new' }));
        });

        it('should deny unauth from creating batches', async () => {
            const ref = doc(unauthDb, 'latteImageBatches/new_batch');
            await assertFails(setDoc(ref, { status: 'new' }));
        });

        it('should allow barista to update batches', async () => {
            const ref = doc(baristaDb, 'latteImageBatches/existing_batch');
            await assertSucceeds(updateDoc(ref, { status: 'completed' }));
        });

        it('should deny kiosk from updating batches', async () => {
            const ref = doc(kioskDb, 'latteImageBatches/existing_batch');
            await assertFails(updateDoc(ref, { status: 'completed' }));
        });
        
        it('should allow barista to delete batches', async () => {
            const ref = doc(baristaDb, 'latteImageBatches/existing_batch');
            await assertSucceeds(deleteDoc(ref));
        });

        it('should deny kiosk from deleting batches', async () => {
            const ref = doc(kioskDb, 'latteImageBatches/existing_batch');
            await assertFails(deleteDoc(ref));
        });
    });
});
