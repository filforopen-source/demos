# Firebase Infrastructure (`firebase/`)

## Purpose
This directory contains the root configuration for the GenLatte Firebase project. It orchestrates the deployment and local execution of hosting, firestore rules, remote configuration, and cloud functions.

## Detailed File Overviews

- **`firebase.json`**:
    - **Description**: The primary configuration file for the Firebase CLI.
    - **Core Logic**:
        - **Firestore**: Points to `firestore.rules` and `firestore.indexes.json`.
        - **Functions**: Configures the `functions/` subdirectory as the source, specifies Node 24 runtime, and defines the `npm build` predeploy hook.
        - **Hosting**: Configures the `public/` folder and defines a catch-all rewrite to `index.html` for single-page applications (SPAs).
        - **Emulators**: Defines port mappings for local development (Auth: 9099, Firestore: 8080, Functions: 5001, etc.).

- **`.firebaserc`**:
    - **Description**: Maps project aliases (e.g., `default`, `staging`) to specific Firebase Project IDs.

- **`firestore.rules`**:
    - **Description**: Defines security and access policies for the Firestore database.

- **`remoteconfig.json`**:
    - **Description**: The default template for project-wide dynamic configuration values.

## Subdirectories Overview

- **`functions/`**: The core backend source code and Node.js environment (see [functions/CONTEXT.md](functions/CONTEXT.md)).

## Dependencies/Relationships

- **Firebase CLI**: Necessary for all interactions within this directory.
- **Google Cloud Console**: Used for managing the underlying Firestore and Cloud Run instances mapped here.

## Usage/Exports

### Project Initialization
To switch between project environments:
```bash
firebase use <alias>
```

### Local Development
To start the full emulator suite:
```bash
firebase emulators:start
```
