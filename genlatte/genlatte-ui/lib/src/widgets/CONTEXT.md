# Common Widgets

**Purpose:**
Hosts shared UI primitives and highly complex layout mathematics structures that are reused globally across the application.

**Detailed File Overviews:**

- `widgets.dart`:
  - **Description**: Barrel export file.

- `buttons.dart` / `chevron_button.dart` / `dynamic_button_layout.dart`:
  - **Description**: Custom Interactive elements.
  - **Core Logic**: Reusable touch targets overriding defaults to provide deep haptics, stylized borders, or specific branding physics (e.g. `ChevronAnimatedButton`).

- `genlatte_scaffold.dart.dart` / `configuration_card.dart` / `footer.dart`:
  - **Description**: Core Structural components.
  - **Core Logic**: The root branding skeletons framing the views, providing headers, progress indicators, or standard card backgrounds.

- `design_scalar.dart` / `responsive_sized_box.dart` / `layout_provider.dart`:
  - **Description**: Scaling Math logic.
  - **Core Logic**: Complex `LayoutBuilder` implementations acting as alternatives to standard media queries, capable of perfectly scaling Typography and Widget padding based on percentage of available constraints (critical for resizing between Mobile, Tablet, and weird aspect ratio Kiosk monitors).

- `triple_tap.dart`:
  - **Description**: Advanced gesture recognition used to hide developer tools intentionally behind complex physical interactions.

**Dependencies/Relationships:**
- Consumed widely throughout `genlatte-ui/lib/src/screens/`.
