# UI Scripts Module (`genlatte-ui/scripts/`)

## Purpose
This directory contains convenience scripts and symlinks specifically for the `genlatte-ui` Flutter package development. It allows developers working within the UI package to access project-wide automation without navigating back to the project root.

## Detailed File Overviews

- **`reset_ui.sh` (Symlink)**:
    - **Description**: A relative symbolic link to the main workspace reset script at `../../scripts/reset_ui.sh`.
    - **Usage**: Provides a local entry point for clearing the UI sandbox and taking state snapshots.

## Dependencies/Relationships

- **Root Scripts**: Dynamically linked to the centralized project-wide scripts.
- **Git**: Complements the development workflow by ensuring the sandbox environment remains in a fresh Git state.

## Usage/Exports

### Running the Reset Script
You can execute the workspace reset directly from within this directory:
```bash
./scripts/reset_ui.sh
```
The script is robust and will automatically identify the repository root regardless of the call location.
