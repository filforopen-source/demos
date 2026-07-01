# Auth Core

**Purpose:**
Provides the centralized identity management mechanism for the entire GenLatte UI application.

**Detailed File Overviews:**

- `auth.dart`:
  - **Description**: Barrel export file.

- `auth_bloc.dart`:
  - **Description**: The BLoC controlling authentication state.
  - **Core Logic**: Subscribes to `FirebaseAuth.authStateChanges()`. Upon receiving a new `User`, it forces an ID token refresh to retrieve custom claims directly from Firebase. These claims dictate the user's `Role` (`barista`, `kiosk`, `queue`, `recent`, `moderator`). If a user has no role, it automatically signs them out for security.

**Dependencies/Relationships:**
- Tightly coupled with the `FirebaseAuth` plugin.
- Direct output is consumed by `core/routing/redirection.dart` to determine allowed URL paths.
