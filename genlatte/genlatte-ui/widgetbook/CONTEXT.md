# UI Component Library (Widgetbook) (`genlatte-ui/widgetbook/`)

## Purpose
A dedicated Flutter project that serves as a design system and interactive catalog for the `genlatte-ui` package. It utilizes the [Widgetbook](https://widgetbook.io/) framework to allow developers to browse, interact with, and test UI components in isolation across different devices and orientations.

## Detailed File Overviews

- **`pubspec.yaml`**:
    - **Description**: Defines dependencies for the Widgetbook project.
    - **Key Dependencies**: Links to the local `genlatte-ui` package and includes `widgetbook` and `widgetbook_annotation` for generating the UI catalog.

- **`lib/main.dart`**:
    - **Description**: The entry point for the Widgetbook application.
    - **Core Logic**: Initializes the `Widgetbook` app, injects the project-wide theme (`ShadcnApp`), and registers the generated directory tree.

- **`lib/*_preview.dart`**:
    - **Description**: Individual story/use-case definitions for components found in the core UI package.
    - **Files included**: `chevron_button_preview.dart`, `footer_preview.dart`, `latte_image_preview.dart`, etc.

- **`lib/main.directories.g.dart`**:
    - **Description**: Generated file containing the mapping of all components annotated with `@widgetbook.UseCase`.

## Dependencies/Relationships

- **Core Package (`genlatte-ui`)**: Widgetbook directly depends on the core package to import and showcase its widgets.
- **Shadcn Flutter**: Uses the same component library and theme as the main application to ensure visual fidelity.
- **Development Tooling**: Integrated into the development workflow to ensure component visual consistency before integration into the main kiosk or barista apps.

## Usage/Exports

### Running Widgetbook
To start the component library locally:
```bash
cd genlatte-ui/widgetbook
flutter run -d chrome
```

### Adding New Previews
When adding new widgets to the codebase, create a corresponding `_preview.dart` file in this directory and use the `build_runner` to update the catalog:
```bash
dart run build_runner build --delete-conflicting-outputs
```
