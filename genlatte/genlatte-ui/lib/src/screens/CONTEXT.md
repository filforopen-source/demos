# Screens Features Sub-Tree

**Purpose:**
The primary Presentation Layer source code directory encompassing every visible view inside the `genlatte-ui` package, broken out by independent user personas or global features.

**Implementation Details:**
- **Navigation**: Each root subfolder inside (`app`, `kiosk`, `barista`, `login`, `queue`, `recent_orders`, `moderator`) serves as a distinct monolithic module backing a major user journey.
- **Architectural Uniformity**: Inside each of those subfolders, you will consistently find a structure further dividing logic into `home/` (BLoC + Views), `util/` (helpers), and `widgets/` (local view components).

**Dependencies:**
- These view layers bind to data by calling Repositories existing in `genlatte-ui/lib/src/data/`.
