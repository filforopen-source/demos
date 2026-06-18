# Image Gen Configs (Firebase)

**Purpose:**
Stores exact execution configuration logic blocks required when querying Gemini for generative capabilities. 

**Detailed File Overviews:**

- `happyPlacePromptPower.ts`:
  - **Description**: Generative Model config object for the Happy Place expansion call.
  - **Core Logic**: Declares parameters explicitly for expanding the user's "Happy Place" input string. 
    - Sets `temperature: 1` aiming for highly creative variance.
    - Sets `thinkingLevel: ThinkingLevel.HIGH` to employ advanced reasoning.
    - Demands the AI force structured JSON outputs (`responseMimeType: 'application/json'`).
    - Disables all typical `SafetySettings` blocks (`HarmBlockThreshold.BLOCK_NONE`) allowing the model leeway to respond accurately to highly diverse edge-cases.

**Dependencies/Relationships:**
- Consumed directly when spinning up an instance of the `@google/genai` client inside Cloud Functions.
