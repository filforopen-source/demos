# Kiosk / Barista / Moderator / Queue / Recent Orders Roots

**Purpose:**
This directory acts as the architectural boundary grouping for the application's distinct personas.

**Implementation Details:**
- **Barrel Architecture**: This level strictly exports child module directories like `home/` and `widgets/` via an `index` / `barrel` file.
- **Child Contexts**: Please navigate into `home/` or `widgets/` subdirectories to view specific BLoC architectures, View layouts, and complex logic files tailored towards each app persona.

**Dependencies:**
- Consumed by `core/routing/routes.dart` to map physical URLs to specific screen entry points.
