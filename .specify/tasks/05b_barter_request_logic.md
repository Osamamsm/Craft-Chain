# Task 05b — Barter Request Logic

## What This Task Builds

The barter repository (abstract + impl), barter model, and barter request ViewModel for creating, accepting, declining requests, **and managing the user's conversation list** (active/completed barters with soft-delete).

## Files to Create

| File                            | Location                          |
| ------------------------------- | --------------------------------- |
| `barter.dart`                   | `lib/features/barter/models/`     |
| `barter_repository.dart`        | `lib/features/barter/models/`     |
| `barter_repository_impl.dart`   | `lib/features/barter/models/`     |
| `barter_request_viewmodel.dart` | `lib/features/barter/viewmodels/` |

## What the Logic Does

### `barter.dart` (Model)

- `freezed` immutable data class: `barterId`, `user1Id`, `user2Id`, `user1Teaches`, `user2Teaches`, `status`, `scheduledAt`, `scheduledPlatform`, `createdAt`, `completedAt`, `hiddenBy`, `lastMessageText`, `lastMessageTime`.
- `hiddenBy` is a `List<String>` of user IDs who have soft-deleted this chat from their view. Defaults to `[]`.
- `lastMessageText` (`String?`) and `lastMessageTime` (`DateTime?`) are denormalized fields updated every time a new message is sent, to allow efficient sorting without a sub-collection query per barter.

### `barter_repository.dart` (Abstract)

- Methods:
  - `Future<void> createBarterRequest(...)` — creates barter doc with `status: 'pending'`, `hiddenBy: []`.
  - `Future<void> acceptRequest(String barterId)` — sets status to `'active'`.
  - `Future<void> declineRequest(String barterId)` — sets status to `'cancelled'`.
  - `Future<List<Barter>> getReceivedRequests(String userId)` — pending requests where user is `user2Id`.
  - `Future<List<Barter>> getSentRequests(String userId)` — pending requests where user is `user1Id`.
  - `Future<bool> hasDuplicateRequest(String user1Id, String user2Id, String skill1, String skill2)`.
  - `Stream<List<Barter>> barterConversationsStream(String userId)` — real-time stream of barters where the user is `user1Id` or `user2Id`, status is `'active'` or `'completed'`, and `hiddenBy` does NOT contain the user's ID. Ordered by `lastMessageTime` descending.
  - `Future<void> hideBarter(String barterId, String userId)` — adds `userId` to the `hiddenBy` array (Firestore `arrayUnion`). This is a soft-delete — the barter and messages remain intact.
  - `Future<void> unhideBarter(String barterId, String userId)` — removes `userId` from the `hiddenBy` array (Firestore `arrayRemove`). Used for the "Undo" snackbar action.
  - `Future<int> getUnreadCount(String barterId, String userId)` — counts messages in the subcollection where `senderId != userId` and `isRead == false`.

### `barter_repository_impl.dart` (Firebase Implementation)

- Implements all methods using `FirebaseFirestore`.
- All timestamps use `FieldValue.serverTimestamp()`.
- Only file that imports `cloud_firestore`.

### `barter_request_viewmodel.dart`

- Gets `BarterRepository` via `ref.read(barterRepositoryProvider)`.
- `sendRequest` validates: no self-barter, no duplicates (via repo), then calls `repository.createBarterRequest`.
- `acceptRequest` / `declineRequest` call the repository.
- Exposes `barterConversationsStream(userId)` for the Chats tab.
- `hideBarter(barterId)` / `unhideBarter(barterId)` — delegate to repository for soft-delete and undo.
- Never imports `cloud_firestore`.

## Acceptance Criteria

- [ ] Repository abstract and impl are correctly separated.
- [ ] Only `barter_repository_impl.dart` imports Firebase packages.
- [ ] Self-barter and duplicate requests are rejected.
- [ ] All timestamps use `FieldValue.serverTimestamp()`.
- [ ] `barterConversationsStream` returns real-time list filtered by status and `hiddenBy`.
- [ ] `hideBarter` / `unhideBarter` correctly add/remove userId from the `hiddenBy` array.
- [ ] `getUnreadCount` returns correct count of unread messages from the other user.

## What NOT to Do

- Do NOT write any UI code.
- Do NOT import `cloud_firestore` in the ViewModel.
- Do NOT send push notifications from the client.
- Do NOT write raw English strings — use `'key'.tr()`. Add all new keys to both `en.json` and `ar.json`.
- Before adding any color, open `app_colors.dart` and `app_theme.dart` first to check if an equivalent already exists.
