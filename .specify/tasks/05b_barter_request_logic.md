# Task 05b — Barter Request Logic

## What This Task Builds

The barter repository (abstract + impl), barter model, and barter request ViewModel for creating, accepting, and declining requests.

## Files to Create

| File                            | Location                          |
| ------------------------------- | --------------------------------- |
| `barter.dart`                   | `lib/features/barter/models/`     |
| `barter_repository.dart`        | `lib/features/barter/models/`     |
| `barter_repository_impl.dart`   | `lib/features/barter/models/`     |
| `barter_request_viewmodel.dart` | `lib/features/barter/viewmodels/` |

## What the Logic Does

### `barter.dart` (Model)

- `freezed` immutable data class: `barterId`, `user1Id`, `user2Id`, `user1Teaches`, `user2Teaches`, `status`, `scheduledAt`, `scheduledPlatform`, `createdAt`, `completedAt`.

### `barter_repository.dart` (Abstract)

- Methods:
  - `Future<void> createBarterRequest(...)` — creates barter doc with `status: 'pending'`.
  - `Future<void> acceptRequest(String barterId)` — sets status to `'active'`.
  - `Future<void> declineRequest(String barterId)` — sets status to `'cancelled'`.
  - `Future<List<Barter>> getReceivedRequests(String userId)` — pending requests where user is `user2Id`.
  - `Future<List<Barter>> getSentRequests(String userId)` — pending requests where user is `user1Id`.
  - `Future<bool> hasDuplicateRequest(String user1Id, String user2Id, String skill1, String skill2)`.

### `barter_repository_impl.dart` (Firebase Implementation)

- Implements all methods using `FirebaseFirestore`.
- All timestamps use `FieldValue.serverTimestamp()`.
- Only file that imports `cloud_firestore`.

### `barter_request_viewmodel.dart`

- Gets `BarterRepository` via `ref.read(barterRepositoryProvider)`.
- `sendRequest` validates: no self-barter, no duplicates (via repo), then calls `repository.createBarterRequest`.
- `acceptRequest` / `declineRequest` call the repository.
- Never imports `cloud_firestore`.

## Acceptance Criteria

- [ ] Repository abstract and impl are correctly separated.
- [ ] Only `barter_repository_impl.dart` imports Firebase packages.
- [ ] Self-barter and duplicate requests are rejected.
- [ ] All timestamps use `FieldValue.serverTimestamp()`.

## What NOT to Do

- Do NOT write any UI code.
- Do NOT import `cloud_firestore` in the ViewModel.
- Do NOT send push notifications from the client.
