# Shared Models

**Purpose:**
Provides pure Dart representations of the NoSQL Firebase document structures. Ensures that all applications (frontend, backend scripts, emulators) share exactly the same data boundaries and serialization logic using `freezed` and `json_serializable`.

**Detailed File Overviews:**

- `models.dart`:
  - **Description**: Barrel export file.

- `latte_order.dart`:
  - **Description**: The core foundational entity representing a Customer's Order.
  - **Core Logic**: Contains nested architectures (`Latte`, `LatteOrder`, and `LatteOrderMetadata`). Generates JSON mapping logic tracking properties like `id`, `name`, `status`, `imageUrl`, and timestamps `orderSubmittedTime` / `completionTime`.

- `latte_image.dart` / `latte_options.dart`:
  - **Description**: Defines visual configuration options for image generation (temperature, seeds, and image URLs).

- `machine.dart`:
  - **Description**: Represents the physical printing hardware located dynamically around the event floor.

- `question.dart`:
  - **Description**: Models structures for the visual Questionnaire ("Is it sunny?", "How do you feel?") utilized inside the Kiosk wizard flow.

- `barista.dart`:
  - **Description**: Encapsulates metadata specifically relating to the employee actively fulfilling orders.

**Dependencies/Relationships:**
- Serves as the ultimate source of truth for schema validation across the `genlatte_data` package. Generated via `build_runner`.
