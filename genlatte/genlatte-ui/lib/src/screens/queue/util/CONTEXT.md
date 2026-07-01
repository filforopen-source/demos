# Queue Util

**Purpose:**
Provides pure utility helper abstractions specific to the `queue` domain, specifically around logging formatting.

**Detailed File Overviews:**

- `metadata_describe.dart`:
  - **Description**: An extension on `LatteOrderMetadata`.
  - **Core Logic**: Exposes a `.describe()` method that formats a debugging string, appending a `-completed` suffix if the `completionTime` field is non-null. Widely used inside `queue_home_bloc` logging.

**Dependencies/Relationships:**
- Imposed via Extension on `genlatte_data`'s `LatteOrderMetadata` class.
