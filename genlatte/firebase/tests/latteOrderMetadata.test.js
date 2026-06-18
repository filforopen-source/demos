const { assertFails, assertSucceeds, initializeTestEnvironment } = require('@firebase/rules-unit-testing');
const { doc, setDoc, updateDoc, getDoc, deleteDoc } = require('firebase/firestore');
const { readFileSync } = require('fs');
const path = require('path');

let testEnv;

before(async () => {
    testEnv = await initializeTestEnvironment({
        projectId: 'demo-latteordermetadata-rules',
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
        await setDoc(doc(db, 'latteOrderMetadata/existing_metadata'), { notes: 'urgent' });
    });
});

after(async () => {
    if (testEnv) {
        await testEnv.cleanup();
    }
});

describe('latteOrderMetadata Rules', () => {

    let kioskDb;
    let baristaDb;
    let unauthDb;

    beforeEach(() => {
        kioskDb = testEnv.authenticatedContext('kiosk_user', { kiosk: true }).firestore();
        baristaDb = testEnv.authenticatedContext('barista_user', { barista: true }).firestore();
        unauthDb = testEnv.unauthenticatedContext().firestore();
    });

    describe('Read', () => {
        it('should allow kiosk to read metadata', async () => {
            const ref = doc(kioskDb, 'latteOrderMetadata/existing_metadata');
            await assertSucceeds(getDoc(ref));
        });

        it('should allow barista to read metadata', async () => {
            const ref = doc(baristaDb, 'latteOrderMetadata/existing_metadata');
            await assertSucceeds(getDoc(ref));
        });

        it('should deny unauthed from reading metadata', async () => {
            const ref = doc(unauthDb, 'latteOrderMetadata/existing_metadata');
            await assertFails(getDoc(ref));
        });
    });

    describe('Write', () => {
        it('should allow barista to create metadata', async () => {
            const ref = doc(baristaDb, 'latteOrderMetadata/new_metadata');
            await assertSucceeds(setDoc(ref, { notes: 'new' }));
        });

        it('should deny kiosk from creating metadata', async () => {
            const ref = doc(kioskDb, 'latteOrderMetadata/new_metadata');
            await assertFails(setDoc(ref, { notes: 'new' }));
        });

        it('should deny unauth from creating metadata', async () => {
            const ref = doc(unauthDb, 'latteOrderMetadata/new_metadata');
            await assertFails(setDoc(ref, { notes: 'new' }));
        });

        it('should allow barista to update metadata', async () => {
            const ref = doc(baristaDb, 'latteOrderMetadata/existing_metadata');
            await assertSucceeds(updateDoc(ref, { notes: 'updated' }));
        });

        it('should deny kiosk from updating metadata', async () => {
            const ref = doc(kioskDb, 'latteOrderMetadata/existing_metadata');
            await assertFails(updateDoc(ref, { notes: 'updated' }));
        });
        
        it('should allow barista to delete metadata', async () => {
            const ref = doc(baristaDb, 'latteOrderMetadata/existing_metadata');
            await assertSucceeds(deleteDoc(ref));
        });

        it('should deny kiosk from deleting metadata', async () => {
            const ref = doc(kioskDb, 'latteOrderMetadata/existing_metadata');
            await assertFails(deleteDoc(ref));
        });
    });
});
