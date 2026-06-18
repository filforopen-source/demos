# Reviser Module (`firebase/functions/src/reviser/`)

## Purpose
This directory contains the logic for the "Image Revision" system. It uses multimodal LLMs (specifically Gemini 3 Flash) to analyze generated images and create interactive refinement questions for the user. This allows for a "human-in-the-loop" iterative design process.

## Detailed File Overviews

- **`reviseImageQuestionGen.ts`**:
    - **Description**: The primary service for generating structured follow-up questions from an image.
    - **Core Logic**: Orchestrates a multi-step AI workflow:
        1. Analyzes a base64-encoded image and generates a list of potential refinement questions.
        2. Post-processes the questions to enrich them with valid options (for multiple-choice) or min/max labels (for slider-based questions).
        3. Returns a structured JSON array suitable for frontend rendering.

- **`reviserConfigs.ts`**:
    - **Description**: Defines the JSON schema and configuration for GenAI models.
    - **Core Logic**: Provides `GenerateContentConfig` objects that use constrained output formats to ensure Gemini returns valid, parseable JSON for questions, slider values, and text options.

- **`reviserPrompts.ts`**:
    - **Description**: Management of prompt templates used by the reviser.
    - **Core Logic**: Defines the system instructions that guide the AI to focus on specific image attributes (color, composition, style) when proposing refinements.

## Dependencies/Relationships

- **Vertex AI (Gemini 3 Flash)**: Optimized for multimodal reasoning and fast structured output.
- **Common Module**: Uses `withRetry` from `../common` to handle the iterative nature of the AI service calls.
- **Tasks Module**: Invoked by `taskGenerateQuestions` in `../tasks/`.

## Usage/Exports

### Core Services
- `reviseImageQuestionGenerator`: The main entry point that takes an image and returned enriched question objects with unique IDs and metadata.
- `generateAnswersOrLabels`: Utility for secondary AI calls to populate question options.
