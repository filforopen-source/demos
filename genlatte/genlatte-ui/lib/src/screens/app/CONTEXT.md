# App Screens

**Purpose:**
Acts as the root container and top-level entry point wrapper for the entire application widget tree, injecting global themes and managing the root `MaterialApp.router`.

**Detailed File Overviews:**

- `app.dart`:
  - **Description**: Barrel export file.

- `app_view.dart`:
  - **Description**: The core `App` widget wrapper.
  - **Core Logic**: Consumes the `AppRouter` instance to construct a `ShadApp.router`, providing the top-level application branding and resolving the `theme`.

- `theme.dart`:
  - **Description**: Global styling constants.
  - **Core Logic**: Provides the foundational custom typography (featuring `Unbounded` for display headers and `Open Sans` for body text) mapped against `shadcn_flutter`'s theme builder. Defines exact Hex color tokens matching branding guidelines.

**Dependencies/Relationships:**
- Serves as the immediate child of the `runApp()` method in `lib/main.dart`.
