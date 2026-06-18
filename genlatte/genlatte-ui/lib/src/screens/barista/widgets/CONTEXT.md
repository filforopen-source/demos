# Barista Widgets

**Purpose:**
A repository of reusable widgets tailored specifically for the barista-facing application interfaces. These components elegantly display orders, present the barista persona, and visualize the status of the local queues.

**Detailed File Overviews:**

- `barista_persona_card.dart`:
  - **Description**: UI component for setting up a barista persona (authentication).
  - **Core Logic**: Manages a local text controller for username input and a selectable grid of AI-generated avatars. Applies grayscale filters to unselected avatars using `ColorFilter.matrix` and triggers an `onSubmit` callback upon completion.
  - **Usage/Exports**: Used heavily by the `BaristaHomeScreen` to instantiate a Barista session.

- `humanized_countdown.dart`:
  - **Description**: Widget rendering a time differential (e.g. "5m ago").

- `image_stack.dart`:
  - **Description**: Displays the generated latte image overlaid with the customer's name.
  - **Core Logic**: Reads `LatteOrderMetadata` to determine if an image was approved or rejected by moderation. Injects fallback URLs if needed, and applies colored banners visually denoting rejection statuses.

- `internal_order_queues.dart`:
  - **Description**: Renders horizontal, segregated scroll lists displaying cards for all orders ready for moderation or brewing.
  - **Core Logic**: Handles role-based visibility. For `barista` roles, it only prints the brew queue. For `moderator` roles, it also prints the moderation queue. Loops over a list of `Latte` objects, outputting either barista or moderator variants of `LatteOrderCard`.

- `latte_order_card.dart`:
  - **Description**: The core visual representation of a single latte order.
  - **Core Logic**: Intensely stateful due to a built-in flipping animation (using `Matrix4` rotation/perspective), providing a dual-sided card. One side (`_LatteOrderCardInner.moderate`) exposes AI moderation controls (Approve/Reject), and the reverse side (`_LatteOrderCardInner.brew`) displays physical brew buttons (Claim/Complete), a badge for the assigned barista, and details regarding Milk/Sweetener selections.

- `order_details_table.dart`:
  - **Description**: A tabular layout for printing the `OrderDetailItem` list (Milk, Sweetener, Drink Type).

- `widgets.dart`:
  - **Description**: Barrel export file.

**Dependencies/Relationships:**
- Strongly coupled to `genlatte_data`'s data models (`Latte`, `LatteOrderMetadata`, `LatteImageBatch`).
- Intended for consumption strictly by `genlatte-ui/lib/src/screens/barista` and `moderator` screens.
