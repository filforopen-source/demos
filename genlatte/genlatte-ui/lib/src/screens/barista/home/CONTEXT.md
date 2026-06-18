# Barista Home

**Purpose:**
Manages the application state, business logic, and UI view for the primary Barista interface. This area empowers baristas to sign in, select connected physical machines (printers), and pull/claim orders from the unified queue.

**Detailed File Overviews:**

- `barista_home.dart`:
  - **Description**: A barrel export file.
  - **Usage/Exports**: Exposes `barista_home_bloc.dart` and `barista_home_view.dart`.

- `barista_home_bloc.dart`:
  - **Description**: The core state management unit (BLoC) governing the barista's workflow.
  - **Core Logic**: Handles multiple asynchronous streams: fetching the latest `LatteOrderMetadata` (brew queue), active `Barista` list, and available active `Machine`s. Contains extensive logic to sign in a barista, cache locally with Hive, bind them to a selected printer, and claim/complete specific orders (`ClaimOrder`, `CompleteOrder` events). 
  - **Exposed Methods**: Consumes events like `NewBrewQueueOrders`, `BaristaSignIn`, `ClaimOrder`, and `SelectedMachine`, subsequently yielding new `BaristaHomeState` frames.

- `barista_home_bloc.freezed.dart`:
  - **Description**: The automatically generated freezed boilerplate for `BaristaHomeEvent` and `BaristaHomeState` immutability and union types.

- `barista_home_view.dart`:
  - **Description**: Defines the `BaristaHomeScreen`, integrating `BaristaHomeBloc` state directly into the UI.
  - **Core Logic**: Dynamically switches the layout depending on the `currentBarista` state—showing a `BaristaPersonaCard` login screen if null, or transitioning to the `InternalOrderQueues.barista` queue view if authenticated. Also spawns modal dialogs to compel machine selection if the barista hasn't connected to a printer.
  - **Dependencies**: Depends heavily on `barista/widgets` (e.g. `BaristaPersonaCard`) and `widgets/InternalOrderQueues`.

**Dependencies/Relationships:**
- Closely tied to the `genlatte_data` package repositories (`LatteOrdersRepository`, `Repository<LatteOrderMetadata>`).
- Depends on sibling module `barista/widgets` for specific UI modules.
- Coordinates with Firebase Auth for sign out capability.
