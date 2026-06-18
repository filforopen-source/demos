# Cloud Functions Platform (`firebase/functions/`)

## Purpose
This directory represents the Node.js environment and build configuration for all project Cloud Functions. It provides the infrastructure necessary to develop, test (via emulators), and deploy backend logic to Firebase.

## Detailed File Overviews

- **`package.json`**:
    - **Description**: Standard Node.js manifest file.
    - **Core Logic**:
        - Declares dependencies including `@google/genai` for Vertex AI interaction and `sharp` for image processing.
        - Defines build scripts (`tsc`) and emulator utility commands (`serve:all`).
        - Restricts the runtime engine to Node 24 for modern feature support.

- **`tsconfig.json`**:
    - **Description**: TypeScript compiler configuration, ensuring strict type checking and consistent output in the `lib/` directory.

- **`src/`**: 
    - **Description**: The core source code directory (see [src/CONTEXT.md](src/CONTEXT.md)).

- **`lib/`**: 
    - **Description**: Generated directory containing compiled JavaScript intended for deployment.

## Dependencies/Relationships

- **Firebase CLI**: Necessary for running the emulators and deploying the package.
- **Node.js 24**: The required runtime environment.
- **Shared Data**: Indirectly related to the shared project data structures maintained in cross-module packages.

## Usage/Exports

### Development Workflow
To compile and run local emulators:
```bash
cd firebase/functions
npm install
npm run build
npm run serve:all
```

Deployment is handled via the Firebase CLI:
```bash
npm run deploy
```
