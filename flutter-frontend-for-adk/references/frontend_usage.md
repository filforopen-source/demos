# Frontend Usage & Behavior Reference

This document directs the agent or developer to define the functional, behavioral, and feature requirements of the frontend and record them in a root-level `FRONTEND_USAGE_NOTES.md` file.

---

## Prerequisites

> [!IMPORTANT]
> Before defining the frontend usage and behavior, the developer or coding agent **must** verify that `AGENT_INTERFACE_NOTES.md` exists in the root of the workspace. If this file is missing, **stop immediately** and run Phase 1 (Workspace & Agent Discovery) first to analyze the agent and create it.

## Instructions for Creating FRONTEND_USAGE_NOTES.md

You must analyze the agent requirements (documented in `AGENT_INTERFACE_NOTES.md` and `README.md`) and compile a functional specification called `FRONTEND_USAGE_NOTES.md` in the root of the workspace.

This document must focus strictly on **behavior, screens, and user features**, leaving out internal architecture patterns (like Riverpod or Clean Architecture) and visual design details (like specific color tokens, font files, and padding values).

Create `FRONTEND_USAGE_NOTES.md` containing the following sections:

### 1. Introduction & Target Platforms
*   **Overview:** Briefly describe what the application does from a user's point of view (e.g., interactive chat assistant, structured report builder, data analyzer).
*   **Target Platforms:** Detail which platforms the frontend supports (e.g. Flutter Web, macOS Desktop, iOS, Android). You should ask the user which ones they want the app to build for.

### 2. User Experience Flow
Describe the high-level step-by-step lifecycle of a user session:
1.  **Onboarding:** How the user starts (e.g., entering a topic, prompt, or file upload).
2.  **Interactive Gates (if applicable):** How the user reviews and edits intermediate state (e.g. reviewing plans, configuring parameters, or providing approval feedback).
3.  **Execution Observation:** What the user sees while the autonomous agent or workflow loop is executing (e.g. progress updates, sub-agent transitions, or active tool invocations).
4.  **Output Review:** How the user interacts with the final deliverables (e.g. browsing reports, opening references/sources, exporting files, or viewing charts).

### 3. Screen Specifications
Detail the functionality and interactive controls of each view in the application:
*   **Dashboard Layout:**
    *   Sidebar containing session lists (creating new sessions, switching between runs, and deleting sessions).
    *   Connection status indicators (backend API online/offline).
*   **Interaction / Chat View:**
    *   Standard text input and send action.
    *   Message log showing user vs agent/system messages.
    *   *Human-in-the-Loop (HITL) Controls:* Custom interactive widgets rendered when the agent requests confirmation or input (e.g. structured checklists, parameter sliders, or yes/no approval prompts).
*   **Workspace / Execution View:**
    *   *Progress Timeline:* A progress indicator displaying the execution status, active sub-agent name (drawn from the event's `author` tag), or current node in the workflow graph.
    *   *Tool Invocation Logs:* A live activity log showing active tool executions (e.g., web searches, database queries, code interpreter sandboxes) including inputs and status.
    *   *Rich Output Viewer:* Renderers for the completed deliverables (e.g. Markdown text, comparison tables, code syntax highlighting, or file download buttons).
    *   *References / Citation Drawer:* Displays source documentation, grounding links, or database record cards when the user clicks inline citations/references in the output.

### 4. User-Facing Feature Checklist
Create a prioritized list (e.g., MUST HAVE, SHOULD HAVE, COULD HAVE) of functional features:
*   Multi-turn chat conversation.
*   Interactive state review and approval gate controls.
*   Server-Sent Events (SSE) streaming parse (word-by-word message rendering).
*   Live execution progress and sub-agent timeline tracking.
*   Real-time tool execution logging.
*   Markdown or rich output rendering (supporting tables, links, and code).
*   Clickable citation links with source detail views.
*   Session history storage (listing, switching, and deleting runs).
