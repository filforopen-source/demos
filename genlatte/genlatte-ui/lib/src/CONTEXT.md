# Application Source Core

**Purpose:**
The centralized collection of the application's internal implementation details, from bootstrapping to feature-specific logic.

**Detailed File Overviews:**
- `bootstrap.dart`: Orchestrates the application startup sequence, including Firebase initialization, dependency injection (using GetIt), Hive setup, and URL strategy configuration.
- `role.dart`: Defines the user roles and permissions logic utilized by the Auth and Routing systems.

**Subdirectories:**
- `core/`: Foundation logic like Auth and Routing.
- `data/` / `sources/`: Data repositories and remote data providers.
- `screens/`: Feature-specific UI trees.
- `widgets/`: Shared UI components and primitives.

**Dependencies/Relationships:**
- Synthesizes all internal modules into a cohesive application.
