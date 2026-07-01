# Recent Orders Widgets

**Purpose:**
Provides the highly customized, visual effect components and animated containers utilized by the physics-engine driven "Recent Orders" screen.

**Detailed File Overviews:**

- `widgets.dart`:
  - **Description**: Barrel export file.

- `squishable_latte_image.dart`:
  - **Description**: A customized image container.
  - **Core Logic**: Wraps `Image.network` into a perfectly circular `ClipOval` but utilizes a responsive `Padding` box structure that allows the inner canvas to warp when provided a collision angle and velocity via `SquishedWidget`.

- `squished_widget.dart`:
  - **Description**: The mathematical deformation transformer.
  - **Core Logic**: Applies a `Matrix4.identity()` mapping and dynamically scales the X and Y axes asynchronously to flatten the image oval along an implicit tangent line.

- `thanos_snappable.dart`:
  - **Description**: The particle exit animation controller.
  - **Core Logic**: An intensely complex custom painting hook used when a bubble is pushed out of the "Recent 12" queue due to an inbound array length change. Uses a custom RenderBox shader approach (or equivalent particle emitter logic) to dissolve the image into dust.

**Dependencies/Relationships:**
- Pure aesthetic wrappers consumed strictly by the `recent_orders_home_view.dart` loop.
- Consumes constraints configured inside `recent_orders_models`.
