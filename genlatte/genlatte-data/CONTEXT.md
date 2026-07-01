# Shared Models Package (genlatte-data)

## Purpose
A pure-Dart package that defines the core data structures and domain models shared across the entire GenLatte ecosystem. This ensures type safety and consistent data serialization between the Flutter UI, Cloud Functions, and Cloud Run jobs.

## Detailed File Overviews
- `pubspec.yaml`: Defines dependencies, notably the `freezed` and `json_serializable` packages for code generation.
- `analysis_options.yaml`: Standardized linting rules for the Dart package.
- `CHANGELOG.md`: Tracks version changes of the data models.

## Subdirectories
- `lib/`: Contains the exported model definitions.
  - `src/models/`: The actual implementation of domain models (e.g., `LatteOrder`, `Barista`, `Machine`) using `freezed` for immutability and JSON support.
- `test/`: Unit tests for model serialization and business logic contained within the models.

## Implementation Details
- **Architecture**: A logic-only Dart package without any dependency on the Flutter framework, making it suitable for both frontend and backend use.
- **Code Generation**: Uses `build_runner` to synthesize the `*.freezed.dart` and `*.g.dart` files. Run `dart run build_runner build` to regenerate these files after model changes.

## Dependencies/Relationships
- **Frontend:** Imported by `genlatte-ui` to handle UI state and API responses.
- **Backend:** Used by Cloud Functions and Cloud Run services to ensure data integrity when interacting with Firestore and external APIs.
