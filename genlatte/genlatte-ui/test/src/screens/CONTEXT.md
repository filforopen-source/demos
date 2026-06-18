# Screen Tests

**Purpose:**
Provides automated UI and State Unit tests for the various high-level views (Barista, Kiosk, Moderator, Queue, and Recent Orders) of the `genlatte-ui` package, ensuring state integrity and visual regression protection.

**Directory Structure Overview:**

- `barista/`:
  - Contains BLoC and Widget tests covering the `BaristaHomeBloc` and the Order Queue lists to ensure baristas can successfully claim and complete orders from mocked Firebase sources.
  
- `kiosk/`:
  - Validates the `KioskHomeBloc` multi-step state machine, ensuring the wizard advances forward and triggers image generation callbacks correctly when dummy user data is supplied.
  
- `moderator/`:
  - Tests ensuring moderators possess the ability to toggle approval statuses via the `ModeratorHomeBloc` and that Machine validation forms work correctly in isolation.

- `queue/`:
  - Complex tests assessing the mathematical properties of the `QueueHomeBloc`, verifying that independent local Sharding correctly filters mock `LatteOrder` documents based on hashing modulo logic, and validating page flips on `OrderList`.

- `recent/`:
  - Contains visual layout tests asserting the 3-Layer bubble system does not overflow and that `RecentOrdersHomeBloc` correctly sorts and limits the returned `RecentLatteImage` streams dynamically based on viewport configuration.

**Dependencies/Relationships:**
- Actively consumes pure and mocked versions of classes from `genlatte_data` (like `LatteOrder`, `Barista`, `LatteOrderMetadata`).
- Targets `genlatte-ui/lib/src/screens/` logic.
