# GenLatte UI Package (`genlatte-ui/`)

## Purpose
This directory contains the core Flutter package for the GenLatte project. It provides the design system, shared widgets, and reusable UI logic used across the Kiosk, Barista, and Moderator interfaces.

## Detailed File Overviews

- **`pubspec.yaml`**:
    - **Description**: The Flutter manifest for the UI package.
    - **Key Dependencies**: 
        - `shadcn_flutter`: The foundational UI component library.
        - `flutter_bloc`: For standardized state management throughout the application.
        - `google_fonts`: For typography (specifically Google Sans).

- **`lib/src/`**:
    - **Description**: Contains the private implementation of the package.
    - **Modules**:
        - **`core/`**: Infrastructure including routing, constants, and global state management.
        - **`widgets/`**: Reusable design system primitives like `GenLatteScaffold` and `ResponsiveSizedBox`.
        - **`screens/`**: UI implementation for specific features (Kiosk home, Recent Orders, etc.).

- **`widgetbook/`**: 
    - **Description**: A documentation and testing harness for the package's widgets (see [widgetbook/CONTEXT.md](widgetbook/CONTEXT.md)).

- **`scripts/`**: 
    - **Description**: Convenience scripts and symbolic links for development automation (see [scripts/CONTEXT.md](scripts/CONTEXT.md)).

## Dependencies/Relationships

- **Backend (Firebase)**: Interacts with Firebase via the source and data layers defined in `lib/src/sources` and `lib/src/data`.
- **Responsive Layout**: Heavily relies on `LayoutProvider` and `DesignScalar` to ensure a consistent experience across desktop, tablet, and mobile orientations.

## Usage/Exports

### Package Integration
This package is intended to be imported by consumer Flutter applications:
```yaml
dependencies:
  genlatte_ui:
    path: ./genlatte-ui
```

### UI Standards
Developers should follow the guidelines in the [ui-standard](.agents/skills/ui-standard/SKILL.md) skill to maintain design consistency when adding new components or screens.
