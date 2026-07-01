# Cloud Functions Source Module (`firebase/functions/src/`)

## Purpose
This directory contains the implementation of the backend logic for GenLatte, deployed as Firebase Cloud Functions (v2). It serves as the bridge between the client-side UI and the various Google Cloud services (Firestore, Vertex AI, Cloud Tasks).

## Detailed File Overviews

- **`index.ts`**:
    - **Description**: The main entry point and export aggregator for the entire functions package.
    - **Core Logic**:
        - Initializes the `firebase-admin` SDK.
        - Sets global scaling options for Cloud Run (underlying Functions v2).
        - Aggregates and re-exports functionality from submodules with consistent naming patterns (using `BRANCH_SUFFIX` for environment isolation).
    - **Exposed Categories**:
        - **Auth Triggers**: Custom claim management (`userEvents`).
        - **Order Management**: Lifecycle triggers and barista actions (`ordersEvents`).
        - **Generative AI**: Asynchronous image and question generation (`tasks`, `images`).
        - **Infrastructure**: Moderation and printing services.

- **`sendToPrinter.ts`**:
    - **Description**: Logic for communicating with physical latte art printers.

- **`moderation.ts`**:
    - **Description**: Real-time content filtering and policy enforcement for user input.

## Subdirectories Overview

- **`common/`**: Shared utilities (retry logic, remote config).
- **`images/`**: High-level image generation and refinement logic.
- **`ordersEvents/`**: Core business logic for order processing.
- **`reviser/`**: AI-driven question generation for image refinement.
- **`tasks/`**: Backend workers for long-running generative AI tasks.

## Dependencies/Relationships

- **Firebase Admin SDK**: For cross-service interaction within GCP.
- **Vertex AI (Gemini)**: Utilized by `images` and `reviser` sub-modules for core feature logic.
- **Cloud Tasks**: Reliable task enqueuing between modules.

## Usage/Exports

All functions are exported from `index.ts`. For deployment, the service uses these exports to define individual Cloud Run services.
