const { assertFails, assertSucceeds, initializeTestEnvironment } = require('@firebase/rules-unit-testing');
const { doc, setDoc, updateDoc, getDoc, deleteDoc } = require('firebase/firestore');
const { readFileSync } = require('fs');
const path = require('path');

let testEnv;

before(async () => {
    testEnv = await initializeTestEnvironment({
        projectId: 'demo-latteoptions-rules',
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
        await setDoc(doc(db, 'latteOptions/existing_option'), { values: ['Test'] });
    });
});

after(async () => {
    if (testEnv) {
        await testEnv.cleanup();
    }
});

describe('latteOptions Rules', () => {

    let unauthDb;
    let authDb;

    beforeEach(() => {
        unauthDb = testEnv.unauthenticatedContext().firestore();
        authDb = testEnv.authenticatedContext('system_user', {}).firestore();
    });

    describe('Read', () => {
        it('should allow unauth users to read options', async () => {
            const ref = doc(unauthDb, 'latteOptions/existing_option');
            await assertSucceeds(getDoc(ref));
        });

        it('should allow auth users to read options', async () => {
            const ref = doc(authDb, 'latteOptions/existing_option');
            await assertSucceeds(getDoc(ref));
        });
    });

    describe('Write', () => {
        it('should deny unauth users from creating options', async () => {
            const ref = doc(unauthDb, 'latteOptions/new_option');
            await assertFails(setDoc(ref, { values: ['Test2'] }));
        });

        it('should deny auth users from creating options', async () => {
            const ref = doc(authDb, 'latteOptions/new_option');
            await assertFails(setDoc(ref, { values: ['Test2'] }));
        });

        it('should deny unauth users from updating options', async () => {
            const ref = doc(unauthDb, 'latteOptions/existing_option');
            await assertFails(updateDoc(ref, { values: ['Updated'] }));
        });

        it('should deny unauth users from deleting options', async () => {
            const ref = doc(unauthDb, 'latteOptions/existing_option');
            await assertFails(deleteDoc(ref));
        });
        
        it('should deny auth users from deleting options', async () => {
            const ref = doc(authDb, 'latteOptions/existing_option');
            await assertFails(deleteDoc(ref));
        });
    });
});
