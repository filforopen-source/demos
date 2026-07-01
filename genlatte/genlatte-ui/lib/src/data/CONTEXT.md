# Data Repositories

**Purpose:**
Provides the "Repository Pattern" abstraction layer, exposing pure Data Models to the application's BLoC state managers while hiding external data communication implementations (like Firestore).

**Detailed File Overviews:**

- `data.dart`:
  - **Description**: Barrel export file.

- `latte_orders_repository.dart` / `recent_latte_images_repository.dart` / etc:
  - **Description**: Domain-specific repositories.
  - **Core Logic**: Wraps methods exposed by `sources/firestore_source.dart` and strictly casts payloads to/from the data structures enforced by `genlatte_data`. They often expose `Stream<List<T>>` for reactive UI binding.
  
- `filters.dart`:
  - **Description**: Filtering logic primitives.
  - **Core Logic**: Mathematical constraints passed from the Repositories down to the Sources to instruct the database to only yield specific documents (e.g. `Filter.whereEquals`).

- `shared_preferences_repository.dart`:
  - **Description**: Local storage layer.
  - **Core Logic**: Wraps standard SharedPreferences for local, offline state persistence (like storing the physical hardware configurations for local Queue displays).

**Dependencies/Relationships:**
- Serves as the intermediary between `genlatte-ui/lib/src/screens/` BLoCs and `genlatte-ui/lib/src/sources/`.
