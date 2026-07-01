# Recent Orders Models

**Purpose:**
Hosts the mathematical data constructs necessary to run the 60fps physics simulation for the "Boba Mode" Recent Orders bubble visualization. These exist outside the presentation layer to separate pure physics calculations from DOM rendering.

**Detailed File Overviews:**

- `models.dart`:
  - **Description**: Barrel export file.

- `latte_position.dart`:
  - **Description**: Core physics matrices and mathematical formulas.
  - **Core Logic**: 
    - Exposes dual mathematical representations of bounding boxes (`LattePosition` using relative coordinate percentages `[0.0-1.0]` vs `AbsoluteLattePosition` using static `<width / height>` constraints) which resolves display responsiveness issues during resizing events.
    - Encapsulates the core `Collision.resolve()` math that uses elastic vector dot-products over tangent impact lines to compute vector momentum conservation after two spheres collide.
  
- `wobble_calculator.dart`:
  - **Description**: A mathematical function generator.
  - **Core Logic**: Drives the logic behind `SquishableLatteImage` that reduces sine-wave amplitude over time following a collision impact to simulate elastic "jelly" properties.

**Dependencies/Relationships:**
- Serves as the math/state backing for components in both `recent_orders/home` and `recent_orders/widgets`.
