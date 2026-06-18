# Custom GPU Shaders

**Purpose:**
Contains GLSL fragment shaders utilized by the Flutter engine for high-performance visual effects.

**Detailed File Overviews:**
- `squish.glsl`: A custom shader used to implement the physics-based "squish" effect on latte images, allowing for realistic deformations during collisions or interactions.

**Dependencies/Relationships:**
- Integrated into the Flutter build process via the `pubspec.yaml` shader definitions.
- Utilized by the `SquishableLatteImage` widget.
