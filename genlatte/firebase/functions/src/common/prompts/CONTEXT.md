# Common Prompts (Firebase)

**Purpose:**
Contains fundamental LLM prompt instructions shared by various AI-driven Cloud Functions, specifically aimed at initializing image generation constraints.

**Detailed File Overviews:**

- `index.ts`:
  - **Description**: Barrel export file.

- `powerup.ts`:
  - **Description**: The fundamental generative augmentation prompt.
  - **Core Logic**: Instructs the LLM to expand a user's short input into a highly detailed, two-paragraph prompt optimized for Latte Art (e.g. telling the LLM to omit details about physical coffee cups and backgrounds, ensuring the result is constrained to just the floating pattern of a latte's crema).

**Dependencies/Relationships:**
- Injected into prompt chains utilized by tools sitting inside `functions/src/images/` to refine user requests before sending them to the primary image generation layer.
