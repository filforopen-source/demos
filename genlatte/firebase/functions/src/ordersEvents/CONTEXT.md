# Orders Events Module (`firebase/functions/src/ordersEvents/`)

## Purpose
This directory contains the core business logic for the GenLatte order lifecycle. It manages order state transitions, metadata initialization, and backend operations triggered by either direct user actions (via Callables) or Firestore document lifecycle events (Triggers).

## Detailed File Overviews

- **`onOrderCreated.ts`**:
    - **Description**: A Firestore trigger that fires when a new order is initialized.
    - **Core Logic**: Sets the `expiresAt` timestamp for TTL-based cleanup and creates a corresponding entry in the `latteOrderMetadata` collection to track internal state and order sequencing.

- **`onOrderUpdated.ts`**:
    - **Description**: Orchestrates logic based on order status transitions.
    - **Core Logic**: Monitors changes in the order state (e.g., transition to `submitted`) and performs downstream actions like notifying baristas or locking the order configuration.

- **`submitOrder.ts`**:
    - **Description**: A Callable function invoked by the kiosk when a user confirms their final order.
    - **Core Logic**: Validates the selected image, locks the order against further changes, and marks it as ready in the barista queue.

- **`claimOrder.ts` / `completeOrder.ts`**:
    - **Description**: Barista-facing logic for managing the physical production of lattes.
    - **Core Logic**: `claimOrder` assigns a barista to a specific request, and `completeOrder` marks the physical preparation as finished, allowing the order to move to the queue for pickup.

- **`archiveOrders.ts`**:
    - **Description**: Handles cleanup and historical archiving of finished or expired orders.

## Dependencies/Relationships

- **Firestore**: The primary source of truth for all order states. Logic extensively uses Firestore Transactions to ensure data consistency during claiming and completion.
- **Common Module**: Uses `./common.ts` for database naming conventions and TTL constants.
- **GenLatte Data Models**: Follows the schema defined in the shared data package to ensure consistency between frontend and backend.

## Usage/Exports

### Firestore Triggers
- `onOrderCreated`: Lifecycle hook for new records.
- `onOrderUpdated`: Lifecycle hook for state transitions.
- `onOrderDeleted`: Lifecycle hook for cleanup.

### Callable Functions
- `submitOrder`: Finalizes customer ordering.
- `claimOrder`: Barista assignment.
- `completeOrder`: Finalizing preparation.
