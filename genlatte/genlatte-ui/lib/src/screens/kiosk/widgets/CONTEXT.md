# Kiosk Widgets

**Purpose:**
A library of modular, common widgets used to flesh out the user interface and structural behavior of the Kiosk screens. Features page transition tools and progress indicators.

**Detailed File Overviews:**

- `empty_latte_art.dart`:
  - **Description**: Handles drawing an outline cup/mug, utilized before user-generated imagery is available.

- `segmented_progress.dart`:
  - **Description**: A horizontal progress bar indicating completion steps.
  - **Core Logic**: Renders a row of pill shapes, animating the width and color of active/inactive segments to telegraph the user's progress through the Kiosk wizard.

- `zip_page_view.dart`:
  - **Description**: A custom, complex page navigator (`ZipPageView`, `ZipPage`, `ZipPageState`).
  - **Core Logic**: Overrides standard `PageView` physics and handles "zipping" items in and out sequentially across wizards. Calculates precise staggering delay offsets (`_staggerDelay`) based on a descending registration of sub-item indices, causing left-most or right-most elements to cascade elegantly via `CurvedAnimation`.
  - **Usage/Exports**: This wraps the entirety of the `KioskHomeScreen` wizard workflow.

- `zip_item.dart`:
  - **Description**: A wrapper for individual elements displayed on a `ZipPage`, causing them to bind to the page's transition animations seamlessly.

- `widgets.dart`:
  - **Description**: Barrel export file.

**Dependencies/Relationships:**
- Utilized entirely by `kiosk/home` and its `steps` subdirectory to render polished onboarding and ordering flows.
