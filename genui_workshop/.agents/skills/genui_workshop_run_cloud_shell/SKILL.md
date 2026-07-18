---
name: genui_workshop_run_cloud_shell
description: Creates a shell script to build and run the Flutter web app on Cloud Shell using a local HTTP server.
---

# GenUI Workshop - Run on Cloud Shell

**Goal**: Create a script to easily build and serve the Flutter web app on Cloud Shell.

**Instructions**:
Use your code editing tools to create a shell script in the root of the project and make it executable.

1. Create a file named `run_cloud_shell.sh` in the root directory of the project with the following content:
```shell
#!/bin/bash
# Builds the web target and serves it on port 8080
flutter build web
python3 -m http.server 8080 --directory build/web
```

2. Make the script executable by running the following command:
```bash
chmod +x run_cloud_shell.sh
```

*(Note: We use `python3` instead of `python` just in case `python` isn't mapped to Python 3 in the environment, though `python -m http.server` as written in the README is also fine if `python` points to python 3.)*
