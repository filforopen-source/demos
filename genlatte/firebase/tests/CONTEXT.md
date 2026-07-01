# Firebase Security Rule Tests

**Purpose:**
Provides a suite of automated unit tests to verify the integrity and effectiveness of the project's Firestore and Realtime Database security rules.

**Detailed File Overviews:**
- `defaultDeny.test.js`: Verifies that the "deny by default" security posture is correctly enforced for unauthenticated requests.
- `latteOrders.test.js` / `latteImageBatches.test.js` / etc.: Specific test suites for each collection, ensuring that role-based access control (RBAC) and data validation rules work as expected for CRUD operations.

**Dependencies/Relationships:**
- Uses the `@firebase/rules-unit-testing` framework.
- Validates the rules defined in the `firebase/firestore.rules` and `firebase/database.rules.json` files.
