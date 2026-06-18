# Queue Widgets

**Purpose:**
Provides complex UI components specifically built for the `queue` display screen. This includes the massive list view and its nested child items, as well as a specialized tool for configuring the display board's hardware installation properties.

**Detailed File Overviews:**

- `debug_overlay.dart`:
  - **Description**: Defines `OrderBoardDebugOverlay`.
  - **Core Logic**: An intense settings panel containing complex form inputs allowing field technicians to change hardware behavior without rebuilding the app. It modifies values managed by `QueueHomeBloc` like "Target row height", active Shards to compute modulo routing mathematics, and "Page update periods". It also contains fake data generator tools for offline mock testing.

- `order_list.dart`:
  - **Description**: The core container `OrderList` component mapping to multiple pages of orders.
  - **Core Logic**: Employs `AnimationController` and `Timer` mechanics synchronized perfectly to the nearest clock-synchronous interval to compute autonomous Page flip transitions. It pre-caches Latte images exactly `1` second before flipping pages to avoid image flash pops.

- `order_list_item.dart`:
  - **Description**: An individual row in the queue representing a single customer order.
  - **Core Logic**: Renders the specific completion status, customer name, and latte image. Handles complex staggering animation delays based on its index sequence (`positionInList`) during page flips.

- `status_icon.dart`:
  - **Description**: Converts the semantic `LatteOrderStatus` enum to animated icon combinations.

**Dependencies/Relationships:**
- Used heavily by `queue/home/queue_home_view.dart`.
- Uses `shadcn_flutter` for core primitive forms.
