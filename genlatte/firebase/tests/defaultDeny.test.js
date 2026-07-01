const { assertFails, assertSucceeds, initializeTestEnvironment } = require('@firebase/rules-unit-testing');
const { doc, setDoc, updateDoc, getDoc, deleteDoc } = require('firebase/firestore');
const { readFileSync } = require('fs');
const path = require('path');

let testEnv;

before(async () => {
    testEnv = await initializeTestEnvironment({
        projectId: 'demo-defaultdeny-rules',
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
        await setDoc(doc(db, 'unknownCollection/existing_doc'), { data: 'secret' });
    });
});

after(async () => {
    if (testEnv) {
        await testEnv.cleanup();
    }
});

describe('Default Deny Rules', () => {

    let baristaDb;
    let unauthDb;
    let kioskDb;

    beforeEach(() => {
        baristaDb = testEnv.authenticatedContext('barista_user', { barista: true }).firestore();
        unauthDb = testEnv.unauthenticatedContext().firestore();
        kioskDb = testEnv.authenticatedContext('kiosk_user', { kiosk: true }).firestore();
    });

    describe('Read', () => {
        it('should deny barista from reading unknown collections', async () => {
            const ref = doc(baristaDb, 'unknownCollection/existing_doc');
            await assertFails(getDoc(ref));
        });

        it('should deny kiosk from reading unknown collections', async () => {
            const ref = doc(kioskDb, 'unknownCollection/existing_doc');
            await assertFails(getDoc(ref));
        });

        it('should deny unauthed from reading unknown collections', async () => {
            const ref = doc(unauthDb, 'unknownCollection/existing_doc');
            await assertFails(getDoc(ref));
        });
    });

    describe('Write', () => {
        it('should deny barista from writing to unknown collections', async () => {
            const ref = doc(baristaDb, 'unknownCollection/new_doc');
            await assertFails(setDoc(ref, { data: 'new' }));
        });

        it('should deny kiosk from writing to unknown collections', async () => {
            const ref = doc(kioskDb, 'unknownCollection/new_doc');
            await assertFails(setDoc(ref, { data: 'new' }));
        });

        it('should deny unauthed from writing to unknown collections', async () => {
            const ref = doc(unauthDb, 'unknownCollection/new_doc');
            await assertFails(setDoc(ref, { data: 'new' }));
        });

        it('should deny barista from deleting unknown collections', async () => {
            const ref = doc(baristaDb, 'unknownCollection/existing_doc');
            await assertFails(deleteDoc(ref));
        });
    });
});
