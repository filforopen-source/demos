# Tasks Module (`firebase/functions/src/tasks/`)

## Purpose
This directory contains Firebase Cloud Task handlers used for reliable, long-running background processing. By offloading resource-intensive generative AI operations (image and question generation) to Cloud Tasks, the system ensures higher reliability with built-in retry logic and configurable timeouts.

## Detailed File Overviews

- **`generateImage.ts`**:
    - **Description**: Handles requested image generation tasks.
    - **Core Logic**:
        - Retrieves order and batch context from Firestore.
        - Calls the image generation engine (`generateImageWithPro`) to produce a base64 image via Vertex AI.
        - Persists the resulting image to Firebase Storage and makes it public.
        - Generates a text description of the image content.
        - Updates the `latteImageBatch` document with the new image URL and metadata.
        - Enqueues a subsequent `taskGenerateQuestions` for initial generations.

- **`generateQuestions.ts`**:
    - **Description**: Orchestrates the generation of AI-driven follow-up questions for image refinement.
    - **Core Logic**:
        - Downloads the generated image from Storage.
        - Invokes the `reviseImageQuestionGenerator` to analyze the image and generate context-aware questions.
        - Updates the Firestore batch record with the generated questions, assigning unique IDs to each for client-side tracking.

## Dependencies/Relationships

- **Vertex AI / Gemini**: Indirectly utilized via internal service wrappers in `../images` and `../reviser`.
- **Firebase Admin SDK**: Used for Firestore updates (`admin/firestore`), Storage management (`admin/storage`), and enqueuing further tasks (`admin/functions`).
- **Cloud Task Queue**: These handlers are triggered by the Cloud Task infrastructure based on queue names defined in the service configuration.

## Usage/Exports

### Cloud Task Handlers
- `taskGenerateImage`: Background worker for image creation.
- `taskGenerateQuestions`: Background worker for image analysis and question generation.

These functions use standard `onTaskDispatched` configurations with a retry limit of 5 attempts and a 540-second timeout to accommodate generative AI latency.
