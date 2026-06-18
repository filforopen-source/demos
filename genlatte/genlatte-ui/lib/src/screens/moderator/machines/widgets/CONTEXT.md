# Moderator Machines Widgets

**Purpose:**
Provides common, reusable widgets for the moderator machines management interface. These widgets are responsible for visually rendering machine status and capabilities.

**Detailed File Overviews:**

- `machine_card.dart`:
  - **Description**: Defines `MachineCard`, a stateful widget that elegantly displays an individual `Machine`'s status and capabilities in an interactive card layout.
  - **Core Logic**: Manages hover animations and determines specific badges based on whether the machine is `.isActive` and `!isBlackAndWhite`. Displays status identifiers (Active/Offline) and specific capabilities (Color/B&W).
  - **Exposed Methods & Usage**: Receives `ToggleStatus` and `OnDelete` callbacks to emit state changes up to the parent list or bloc.

- `widgets.dart`:
  - **Description**: Barrel file for exporting `machine_card.dart`.
  - **Core Logic/Usage**: Simplifies imports for consumers of the machine widgets.

**Dependencies/Relationships:**
- Interfaces directly with `models.dart` from `genlatte_data` to consume the `Machine` data model.
- Designed to be used by the parent `moderator/machines` screens for rendering lists of printers/machines.
