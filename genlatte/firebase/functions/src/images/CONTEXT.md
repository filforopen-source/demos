# Images Module (`firebase/functions/src/images/`)

## Purpose
This directory serves as the core Generative AI image engine for the project. It handles the lifecycle of image generation from initial prompt creation to refinement based on user feedback, integrating directly with Google Cloud's Vertex AI (specifically Gemini 3 Pro models).

## Detailed File Overviews

- **`generateImageWithPro.ts`**:
    - **Description**: A robust low-level wrapper around the Vertex AI Image generation API.
    - **Core Logic**: Configures advanced generation parameters (aspect ratio, MIME type, thinking level) and includes retry logic with exponential backoff to handle transient AI service errors.

- **`generateRevisedImages.ts`**:
    - **Description**: An `onCall` function that processes user feedback (answers to generated questions) to create a new batch of refined images.
    - **Core Logic**:
        - Aggregates user answers and moderates text-based input.
        - Calls the revised prompt generator to translate feedback into new AI prompts.
        - Creates a new `latteImageBatch` in Firestore linked to the parent batch.
        - Enqueues multiple `taskGenerateImage` calls via the Cloud Task queue for asynchronous generation.

- **`generateDescriptions.ts`**:
    - **Description**: Uses Multimodal LLMs to analyze generated images and provide textual descriptions.

- **`promptsForHappyPlace.ts`**:
    - **Description**: Contains the prompt engineering logic that converts a user's "Happy Place" description into a dense, detailed prompt optimized for image generation.

- **`selectImage.ts` / `rejectImage.ts`**:
    - **Description**: Handle the user's final decision on a batch. `selectImage` marks an image as the final choice for the order, while `rejectImage` marks the batch as rejected (e.g., if the user wants to try again).

## Dependencies/Relationships

- **Vertex AI (Gemini)**: The primary engine for both image generation and multimodal vision analysis.
- **Firebase Remote Config**: Dynamically injects model IDs and feature flags.
- **Firestore**: Tracks the state of image batches (`latteImageBatches`) and links them to orders (`latteOrderMetadata`).
- **Cloud Tasks**: Used by `generateRevisedImages.ts` to trigger asynchronous image creation without blocking the client.

## Usage/Exports

### Callable Functions
- `generateRevisedImages`: Triggered by the frontend when a user submits refinement answers.
- `selectImage`: Triggered when a user chooses their final latte art.
- `rejectImage`: Triggered when a user dislikes a whole batch.

### Internal Services
- `generateImageWithPro`: Utility for raw image generation.
- `generateDescription`: Utility for analyzing image content.
