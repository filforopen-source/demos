# Kiosk Home

**Purpose:**
Manages the application state, wizard-style navigation, and primary user interface for the consumer-facing Kiosk app. It orchestrates the entire order flow—from entering a name and selecting drink options to submitting a "happy place" and interacting with generated AI imagery.

**Detailed File Overviews:**

- `kiosk_home.dart`:
  - **Description**: A barrel file.
  - **Usage/Exports**: Re-exports the Bloc (`kiosk_home_bloc.dart`) and the View (`kiosk_home_view.dart`).

- `kiosk_home_bloc.dart`:
  - **Description**: The massive, central state management engine for the Kiosk screen wizard. 
  - **Core Logic**: Manages a complex step-by-step wizard state (`KioskWizardStep` enum), handling forward/backward navigation and validations. It coordinates heavy asynchronous tasks like creating a `LatteOrder` in Firestore, watching for image generation streams (`_watchImageBatch`), processing moderation events (e.g. `HappyPlaceRejected`), submitting AI image tweaks via follow-up questions, and ultimately finalizing an order via `_onSubmitOrder`. 
  - **Exposed Methods**: Consumes numerous `KioskHomeEvent` variants (e.g., `StartOver`, `SubmitHappyPlace`, `GenerateRevisedImages`, `AcceptImage`). Emits updated `KioskHomeState` objects representing the user's progress through the ordering flow.

- `kiosk_home_view.dart`:
  - **Description**: The UI orchestration layer for the Kiosk.
  - **Core Logic**: Wraps the wizard in a `ZipPageView`, binding `KioskHomeBloc` states directly to individual wizard sub-screens (e.g., `KioskDrinkOrderName`, `KioskHappyPlace`, `KioskTweakImage`) located in the `/steps` subdirectory. Also manages top-level error toasts (like happy place moderation rejections) and layout structure (headers/footers, segmented progress bar).
  - **Dependencies**: Imports and renders all specific step components from `kiosk/home/steps/steps.dart`.

**Dependencies/Relationships:**
- Heaps of interaction with `genlatte_data` (e.g. `LatteOrdersRepository`, `Repository<LatteImageBatch>`).
- Directly delegates to individual UI fragments within the `steps/` subfolder.
- Consumes components from `kiosk/widgets/` like `SegmentedProgress`, `ZipPageView`.
