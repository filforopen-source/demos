# Queue Home

**Purpose:**
Hosts the large-format, passive "Queue Board" screen used to alert consumers to the status of their submitted drinks. This application is designed to be completely autonomous, reacting dynamically to distributed databases, managing paging seamlessly across varying hardware deployments without centralized communication.

**Detailed File Overviews:**

- `queue_home.dart`:
  - **Description**: Barrel export file.

- `queue_home_bloc.dart`:
  - **Description**: Core autonomous state management for the display board.
  - **Core Logic**: Extremely complex, managing both active state subscriptions and local persisted UI settings (Page Duration, Row Heights). 
    - Implements a pure client-side Sharding Strategy (`_doesOrderBelongToShard`) based on `pkg:hashlib` `xxh32code`. This enables multiple queue display screens to filter requests randomly but deterministically locally without direct horizontal synchronization.
    - Manages pagination computations (`_emitUpdatedPages`) dynamically re-calculating batch slots based on available spatial capacity.

- `queue_home_view.dart`:
  - **Description**: Scaffold implementation encapsulating the `OrderList`. 
  - **Core Logic**: Wraps the Queue Board inside a visual `_Marginalia` container. Implements a highly obfuscated UI hook (100x100 `MouseRegion` hit area in the top right corner) designed to secretly expose a `OrderBoardDebugOverlay` used for field administration of shards/timing configurations.

- `fake_repositories.dart`:
  - **Description**: Exposes `FakeLatteOrdersRepository` testing mocks allowing offline simulation.

- `queue_settings.dart` / `.freezed.dart` / `.g.dart`:
  - **Description**: A serializable (JSON via Freezed) model encapsulating tuning preferences for the local board (Shard Total, Shard Target, Update Frequency, Row Height) stored locally into `SharedPreferences`.

**Dependencies/Relationships:**
- Strongly relies on `queue/widgets` like `OrderList` and `OrderBoardDebugOverlay` for component rendering.
- Subscribes via `LatteOrderMetadataBoardQueue` filter to actively listen to Firebase.
