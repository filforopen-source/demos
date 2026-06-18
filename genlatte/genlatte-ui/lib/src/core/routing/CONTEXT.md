# Routing Core

**Purpose:**
Manages deep linking, navigation, and role-based access control inside the application using `go_router`.

**Detailed File Overviews:**

- `routing.dart`:
  - **Description**: Barrel export file.

- `routes.dart`:
  - **Description**: Constants map defining the physical string URL routes available to the application.

- `router.dart`:
  - **Description**: Initializes the `GoRouter` instance.
  - **Core Logic**: Configures a global `redirect` callback that evaluates every navigation request against the `GoRouterRedirector`, keeping users locked to screens mapped to their Firebase Auth custom claims role. Validates redirection updates dynamically using the `authBloc.stream` to catch role changes or log-outs.

- `redirection.dart`:
  - **Description**: The core Role-Based Access Control logic framework.
  - **Core Logic**: Contains a suite of `Redirector` classes (like `NonBaristaAwayFromBaristaHome` and `AnonymousUsersToLogin`) that enforce strict path boundaries preventing users from guessing URLs.

**Dependencies/Relationships:**
- Depends entirely on `AuthBloc` to determine the active user's roles.
- Consumed globally via standard `context.go()` calls across the app.
