const { assertFails, assertSucceeds, initializeTestEnvironment } = require('@firebase/rules-unit-testing');
const { doc, setDoc, updateDoc, getDoc, deleteDoc } = require('firebase/firestore');
const { readFileSync } = require('fs');
const path = require('path');

let testEnv;

before(async () => {
    testEnv = await initializeTestEnvironment({
        projectId: 'demo-latteart-rules',
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
        await setDoc(doc(db, 'latteOptions/milks'), { values: ['Whole', 'Skim', 'Oat', 'Almond'] });
        await setDoc(doc(db, 'latteOptions/sweeteners'), { values: ['None', 'Sugar', 'Stevia', 'Caramel'] });

        // pre-seed an order for testing updates
        await setDoc(doc(db, 'latteOrders/existing_order'), {
            name: 'Craig'
        });
    });
});

after(async () => {
    if (testEnv) {
        await testEnv.cleanup();
    }
});

describe('latteOrders Rules', () => {

    let kioskDb;
    let baristaDb;
    let unauthDb;

    beforeEach(() => {
        kioskDb = testEnv.authenticatedContext('kiosk_user', { kiosk: true }).firestore();
        baristaDb = testEnv.authenticatedContext('barista_user', { barista: true }).firestore();
        unauthDb = testEnv.unauthenticatedContext().firestore();
    });

    describe('Create', () => {
        it('should allow kiosk to create with just a name', async () => {
            const ref = doc(kioskDb, 'latteOrders/order1');
            await assertSucceeds(setDoc(ref, { name: 'Latte' }));
        });

        it('should fail if kiosk tries to create with an extra arbitrary field', async () => {
            const ref = doc(kioskDb, 'latteOrders/order2');
            await assertFails(setDoc(ref, { name: 'Latte', badField: true }));
        });

        it('should deny barista from creating orders', async () => {
            const ref = doc(baristaDb, 'latteOrders/order3');
            await assertFails(setDoc(ref, { name: 'Latte' }));
        });

        it('should deny unauthed from creating orders', async () => {
            const ref = doc(unauthDb, 'latteOrders/order4');
            await assertFails(setDoc(ref, { name: 'Latte' }));
        });
    });

    describe('Update', () => {
        it('should allow barista to update orders without restriction on milk validity', async () => {
            const ref = doc(baristaDb, 'latteOrders/existing_order');
            await assertSucceeds(updateDoc(ref, { milk: 'unlisted-super-milk' }));
        });

        it('should allow kiosk to update order with valid milk', async () => {
            const ref = doc(kioskDb, 'latteOrders/existing_order');
            await assertSucceeds(updateDoc(ref, { milk: 'Oat' }));
        });

        it('should fail if kiosk tries to update order with invalid milk', async () => {
            const ref = doc(kioskDb, 'latteOrders/existing_order');
            await assertFails(updateDoc(ref, { milk: 'invalid_milk' }));
        });

        it('should allow kiosk to update order with valid sweetener', async () => {
            const ref = doc(kioskDb, 'latteOrders/existing_order');
            await assertSucceeds(updateDoc(ref, { sweetener: 'Caramel' }));
        });

        it('should fail if kiosk tries to update order with invalid sweetener', async () => {
            const ref = doc(kioskDb, 'latteOrders/existing_order');
            await assertFails(updateDoc(ref, { sweetener: 'salt' }));
        });
        
        it('should allow kiosk to update image URL', async () => {
            const ref = doc(kioskDb, 'latteOrders/existing_order');
            await assertSucceeds(updateDoc(ref, { imageUrl: 'https://example.com/image.png' }));
        });

        it('should allow kiosks to update milk and sweetener at the same time', async () => {
            const ref = doc(kioskDb, 'latteOrders/existing_order');
            await assertSucceeds(updateDoc(ref, { milk: 'Oat', sweetener: 'Caramel' }));
        });
    });

    describe('Read & Delete', () => {
        it('should allow barista to read orders', async () => {
            const ref = doc(baristaDb, 'latteOrders/existing_order');
            await assertSucceeds(getDoc(ref));
        });

        it('should allow kiosk to read orders', async () => {
            const ref = doc(kioskDb, 'latteOrders/existing_order');
            await assertSucceeds(getDoc(ref));
        });

        it('should deny unauthed from reading orders', async () => {
            const ref = doc(unauthDb, 'latteOrders/existing_order');
            await assertFails(getDoc(ref));
        });

        it('should deny kiosk from deleting orders', async () => {
            const ref = doc(kioskDb, 'latteOrders/existing_order');
            await assertFails(deleteDoc(ref));
        });

        it('should allow barista to delete orders', async () => {
            const ref = doc(baristaDb, 'latteOrders/existing_order');
            await assertSucceeds(deleteDoc(ref));
        });
    });
});
