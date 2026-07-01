# Moderator Machines

**Purpose:**
Provides full CRUD (Create, Read, Update, Delete) capability specifically for moderating hardware/printer Machine status in the coffee shop.

**Detailed File Overviews:**

- `machines.dart`:
  - **Description**: Barrel export file.

- `machines_bloc.dart`:
  - **Description**: State management for machine tracking.
  - **Core Logic**: Subscribes to the `Repository<Machine>` to watch the live list of all physical printers connected to the system. Handles creating new machines via `forceInsert: true` (since IDs act as physical printer identifiers) and exposes toggle logic (`ToggleMachineStatus`) and deletion logic.

- `machines_view.dart`:
  - **Description**: The primary UI interface for the Machines admin portal.
  - **Core Logic**: Determines if the viewport implies mobile (`ListView`) vs desktop/tablet (`GridView`) formatting. Loops over the available `machines`, emitting instances of `MachineCard`. Provides a robust creation dialog encompassing fields for ID, Name, and Black/White isolation status, as well as destructive confirmation dialogs.

**Dependencies/Relationships:**
- Renders `MachineCard` from its `widgets/` subdirectory.
- Accessed by moderators navigating from the `ModeratorHomeScreen`.
