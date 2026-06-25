---
name: flutter-frontend-for-adk
description: >
  Orchestrates the discovery, mapping, design, and implementation of a premium
  Flutter-based frontend for an Agent Development Kit (ADK) agent written with Python.
metadata:
  author: Antigravity
  version: 1.0.0
  requires:
    bins:
      - flutter
      - dart
---

# Building a Flutter Frontend for an ADK Agent

This skill orchestrates the end-to-end workflow of designing, specifying, and implementing a premium Flutter-based frontend for any Agent Development Kit (ADK) agent.

## Prerequisites & External References

Before starting, the developer or coding agent should locate ADK framework-level specifications using the following resources instead of restating them in this skill:
1.  **Activate ADK Code Skill:** Ensure that `/google-agents-cli-adk-code` is active in the current session. Refer to its reference file `adk-python.md` to understand the core `Event`, `EventActions`, and state management models.
2.  **Fetch Official Docs:** Retrieve the official documentation index by calling `curl https://adk.dev/llms.txt` and search for pages related to client serving, networking, or the Python API server.
3.  **Inspect Local Code:** To see exact Pydantic definitions and FastAPI endpoint details directly:
    *   Open and inspect the local server definition inside your python environment at `.venv/lib/python*/site-packages/google/adk/cli/adk_web_server.py`.
    *   Open and inspect the event schemas at `.venv/lib/python*/site-packages/google/adk/events/event.py` and `event_actions.py`.

Follow the phases below sequentially. **Do not skip ahead.** You must complete and record the findings of each phase before beginning the next. When creating an implementation plan, add a blocking task for the "Review" step in each phase that has one and wait for the user to perform a review before beginning the next phase.

---

## Phase 1: Workspace & Agent Discovery
Identify the core purpose of the agent in this repository, understand its sub-agent hierarchy, map its API endpoints, event streams, and human-in-the-loop triggers, and record this information.
*   **Action:** Read [references/agent_discovery.md](references/agent_discovery.md) for step-by-step discovery instructions.
*   **Deliverable:** Create the [AGENT_INTERFACE_NOTES.md](AGENT_INTERFACE_NOTES.md) file in the root of the project.
*   **Review:** Summarize (in a paragraph or two) what you just learned for the user. Invite them to inspect `AGENT_DISCOVERY_NOTES.md`, and do not proceed to Phase 2 until they indicate that you should do so.

---

## Phase 2: Frontend Usage & Behavior
Define the high-level behavioral and functional requirements of the frontend: target platforms, screen specifications, feature details, and user experience flows.
*   **Action:** Read [references/frontend_usage.md](references/frontend_usage.md) for instructions on defining app behavior.
*   **Deliverable:** Create the [FRONTEND_USAGE_NOTES.md](FRONTEND_USAGE_NOTES.md) file in the root of the project.
*   **Review:** Summarize (in a paragraph or two) what you just learned for the user. Invite them to inspect `FRONTEND_USAGE_NOTES.md`, and do not proceed to Phase 3 until they indicate that you should do so.

---

## Phase 3: Frontend Architecture
Define the structural patterns of the application, including core folder directory layouts, manual model serializations, and state management setups.
*   **Action:** Read [references/frontend_architecture.md](references/frontend_architecture.md) for instructions on defining app architecture.
*   **Deliverable:** Create the [FRONTEND_ARCHITECTURE_NOTES.md](FRONTEND_ARCHITECTURE_NOTES.md) file in the root of the project.
*   **Review:** Summarize (in a paragraph or two) what you just learned for the user. Invite them to inspect `FRONTEND_ARCHITECTURE_NOTES.md`, and do not proceed to Phase 4 until they indicate that you should do so.

---

## Phase 4: Frontend Design & Layout
Design the visual structure, layout columns, styling guides, states, and micro-animations for the frontend application.
*   **Action:** Read [references/frontend_design.md](references/frontend_design.md) for styling and UI blueprints.
*   **Deliverable:** Create the [FRONTEND_DESIGN_NOTES.md](FRONTEND_DESIGN_NOTES.md) file in the root of the project.
*   **Review:** Summarize (in a paragraph or two) what you just learned for the user. Invite them to inspect `FRONTEND_DESIGN_NOTES.md`, and do not proceed to Phase 5 until they indicate that you should do so.

----

## Phase 5: Scaffolding & Implementation
Create and program the Flutter client application within the workspace, implementing all designs and specifications.
*   **Action:**
    1. Read [references/frontend_best_practices.md](references/frontend_best_practices.md) for specific implementation patterns and best practices.
    2. Scaffold a fresh Flutter project inside a folder named `frontend/` at the root of the workspace. Do not specify an org name unless instructed. Create the app to build for only those platforms specified by the user -- if you're not sure, ask.
    3. Add the approved packages (`provider`, `flutter_markdown`, `url_launcher`, and `http`) to `frontend/pubspec.yaml`.
    4. Write the manual serialization models, the `AdkApiService` (implementing standard REST and SSE HTTP streamed response parsers), the `AgentProvider` state notifier, and the responsive views/widgets following `FRONTEND_ARCHITECTURE_NOTES.md` and `FRONTEND_DESIGN_NOTES.md`.
    5. Verify code cleanliness and correctness by running `flutter format`, `flutter analyze`, and `flutter test` inside the `frontend/` directory.
*   **Deliverable:** A fully compiled and functional Flutter application located inside the `frontend/` folder.

---

## Phase 6: Workspace Integration & Documentation
Integrate the frontend into the workspace build flows, update version control settings, and document the client setup for developers.
*   **Action:**
    1.  **Build Configuration:** Examine the codebase to determine how a developer builds and runs the backend agent (e.g. searching for `Makefile` targets, task configurations in `pyproject.toml` like Poe/Taskipy, `package.json` scripts, or custom `run.sh` / `build.sh` scripts). Update these automation tools or files to provide simple commands for developers to build, test, and launch the new Flutter frontend.
    2.  **VCS Ignore Setup:** Update the project's version control ignore configurations to make sure they account for the new project and its artifacts. The Flutter frontend should have a nested `.gitignore` file that will account for most things. If the root `.gitignore` file ignores `lib/`, though, make sure to add an exclusion for Flutter's `lib` directory (`!frontend/lib`).
    3.  **Documentation Update:**
        *   If the project has a `README.md` in the root directory, update it to reference the new frontend, detail prerequisites (such as the Flutter SDK version), and outline startup instructions.
        *   Update the default `frontend/README.md` file to describe the frontend client, its structure, and how to launch both the agent and the client using the build configuration tools updated in step 1.
        *   Look for any additional pre-existing docs that might need to be updated and do so.
*   **Deliverable:** Updated workspace integration configurations, build scripts, and documentation files.
