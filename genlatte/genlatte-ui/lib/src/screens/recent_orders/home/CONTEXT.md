# Recent Orders Home

**Purpose:**
Manages the "Recent Orders" visualization screen, sometimes known as the "Boba Screen" or "Floating Bubble Mode." This is a highly complex, 60fps physics simulation that runs a deterministic 2D elastic collision model to float recently moderated latte images around a display, culminating in a Hero "Thanos Snap" animation when swapping content in and out.

**Detailed File Overviews:**

- `recent_orders_home.dart`:
  - **Description**: Barrel export file.

- `recent_orders_home_bloc.dart`:
  - **Description**: Simplified state management.
  - **Core Logic**: Listens to the `RecentLatteImage` repository and simply pipes a sliced/sorted array of the N newest images into the `RecentOrdersHomeState`. Also tracks the currently `activeImage` selected by a user.

- `recent_orders_home_view.dart`:
  - **Description**: The massively complex physics engine driving the particle visualization system.
  - **Core Logic**: 
    - **Physics Simulation (`_updateLattePositions`)**: Runs an internal `Timer` fired at 16ms (60 fps) calculating distance vectors, horizontal/vertical wall bounces, and inter-bubble elastic collisions (utilizing absolute to relative resolution computations along normal tangents).
    - **DOM Management (`_LatteImagesInnerState`)**: Renders bubbles utilizing a "3-Layer rendering strategy". 
      - Layer 1 renders the stable floating bubbles tracked by the engine matrix.
      - Layer 2 tracks "Ghost" bubbles when an old bubble is bumped out of the pool via an incoming array shift. It computes a localized velocity momentum trajectory while applying a dust particle "Thanos Snap" exit.
      - Layer 3 renders the detail-Hero view, locking mechanics when a consumer clicks on a bubble to inspect it. 

**Dependencies/Relationships:**
- Deep reliance on mathematical representations tracked in `recent_orders/models` (like `LattePosition` and `Collision`).
- Depends heavily on the animations hosted in `recent_orders/widgets` (like `SquishableLatteImage` and `ThanosSnappable`).
