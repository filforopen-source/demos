# External Sources

**Purpose:**
Provides direct raw IO access boundaries to Cloud Infrastructure endpoints, preventing Vendor Lock-in by isolating exact Firebase APIs away from business logic repositories.

**Detailed File Overviews:**

- `sources.dart`:
  - **Description**: Barrel export file.

- `firestore_source.dart`:
  - **Description**: The core NoSQL Database connection client.
  - **Core Logic**: Interacts directly with the `cloud_firestore` plugin. Parses generic internal `Filter` tokens into Firebase-specific `Where` queries. Formats JSON maps directly into outbound streams using document snapshots.

- `firestore_filters.dart`:
  - **Description**: NoSQL Query Translator.
  - **Core Logic**: Uses `freezed` to pattern-match repository filter requests and resolve them directly onto Firebase `Query` chains.

**Dependencies/Relationships:**
- Strictly consumed by `genlatte-ui/lib/src/data` Repositories.
