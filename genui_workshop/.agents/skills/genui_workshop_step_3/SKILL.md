---
name: genui_workshop_step_3
description: Execute Step 3 of the GenUI Workshop, creating the empty Flutter project and adding dependencies.
---

# GenUI Workshop - Step 3

**Goal**: Execute Step 3 of the GenUI workshop.

**Instructions**:
Execute the following commands sequentially to create the initial Flutter project and configure it. Assume the terminal's working directory is an empty directory where the project should reside.

1. Configure safe directories and create the empty project in the current directory:
```bash
git config --global --add safe.directory /google/flutter
flutter create --empty .
```

2. Activate flutterfire_cli and set the PATH:
```bash
dart pub global activate flutterfire_cli
export PATH="$PATH":"$HOME/.pub-cache/bin"
```
*(Note: Skip `flutterfire configure` as instructed by the user)*

3. Add the required dependencies to the project:
```bash
flutter pub add genui firebase_core firebase_ai json_schema_builder
```
