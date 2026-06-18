# Common Utilities Module (`firebase/functions/src/common/`)

## Purpose
This directory contains reusable utility functions, configuration handlers, and shared resources used across all Firebase Cloud Functions in the project. Centralizing these ensures consistency in database access, error handling, and configuration management.

## Detailed File Overviews

- **`retry.ts`**:
    - **Description**: A generic asynchronous retry utility.
    - **Core Logic**: Implements an exponential backoff strategy (`baseDelay * 2^attempt`) to gracefully handle transient failures in external services (like Generative AI APIs or database contention), with configurable retry limits.

- **`fetchRemoteConfig.ts`**:
    - **Description**: Handles dynamic configuration via Firebase Remote Config.
    - **Core Logic**: Provides a type-safe way to fetch project-wide parameters such as Generative AI model names, feature flags, or threshold values, allowing for real-time application updates without redeploying code.

- **`getDb.ts`**:
    - **Description**: Centralized Firestore initialization.
    - **Core Logic**: Manages the `admin.firestore()` instance, handling differences between emulator environments and production.

- **`prompts/`**:
    - **Description**: A subdirectory containing common system prompt templates used for instructing Large Language Models.

## Dependencies/Relationships

- **Firebase Admin SDK**: Core dependency for accessing Firestore and Remote Config.
- **Firebase Functions Logger**: Used for standardized logging of retry attempts and errors.
- **Cross-cutting**: Consumed by virtually every other module in `src/` (e.g., `images`, `ordersEvents`, `reviser`).

## Usage/Exports

### Shared Utilities
- `withRetry`: The primary wrapper for reliable async execution.
- `fetchRemoteConfigValues`: Method to retrieve current dynamic app settings.
- `db`: The global Firestore database instance exported for general use.
