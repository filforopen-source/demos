# Utils Core

**Purpose:**
Contains miscellaneous shared utility functions used across the `genlatte-ui` application layer.

**Detailed File Overviews:**

- `utils.dart`:
  - **Description**: Barrel export file.

- `double_extensions.dart`:
  - **Description**: Helper extension functions applied to the `double` primitives for standardized formatting.

- `firebase_functions_client.dart`:
  - **Description**: Helper wrapper for `FirebaseFunctions`.
  - **Core Logic**: Contains standardized error catching routines used when calling HTTP-callable Cloud Functions.

- `position.dart`:
  - **Description**: A utility class abstracting `x` and `y` geometric alignments used by visual configuration steps.

**Dependencies/Relationships:**
- General purpose scope utilized throughout the domain.
