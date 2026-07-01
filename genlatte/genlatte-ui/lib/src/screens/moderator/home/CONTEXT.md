# Moderator Home

**Purpose:**
Provides the logic and UI for the Moderator dashboard. This screen aims to give moderators an overview of the entire latte bar, handling primarily the queue of submitted orders that require image or name safety moderation.

**Detailed File Overviews:**

- `moderator_home.dart`:
  - **Description**: Barrel export file.

- `moderator_home_bloc.dart`:
  - **Description**: The BLoC managing moderator state via stream subscriptions.
  - **Core Logic**: Subscribes to changes in `Barista` entities and `LatteOrderMetadata` using `RequestDetails(filter: LatteOrderMetadataModerationQueue())`. Exposes methods to handle approval or rejection flows for Names and Images via `_moderateOrder()` which toggles server validation status (`status: .validated`). It merges both moderation and brew queues sequentially to provide a full bar snapshot.

- `moderator_home_view.dart`:
  - **Description**: The primary UI for the Moderator Home screen.
  - **Core Logic**: Constructs a Scaffold rendering an `InternalOrderQueues.moderator` instance. It pipes callbacks from the Queue cards into the Bloc events (`ApproveNameAndImage`, `RejectNameApproveImage`, `ApproveNameRejectImage`, `RejectNameAndImage`). Also includes an AppBar routing over to the `<MachinesScreen>` via a print icon.

**Dependencies/Relationships:**
- Closely tied to `genlatte_data` Models (`Barista`, `LatteOrderMetadata`).
- Relies heavily on `barista/widgets` (especially `InternalOrderQueues` and `LatteOrderCard.moderator`) for its core visualization.
- Connected to `AppRouter` to navigate to `machines/`.
