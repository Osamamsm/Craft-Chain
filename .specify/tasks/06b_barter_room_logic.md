# Task 06b — Barter Room Logic

## What This Task Builds

Message model and barter room ViewModel using the barter repository for real-time messaging, session scheduling, and completion.

## Files to Create

| File                         | Location                          |
| ---------------------------- | --------------------------------- |
| `message.dart`               | `lib/features/barter/models/`     |
| `barter_room_viewmodel.dart` | `lib/features/barter/viewmodels/` |

## What the Logic Does

### `message.dart` (Model)

- `freezed` immutable data class: `messageId`, `senderId`, `text`, `createdAt`, `isRead`.

### Additional methods on `BarterRepository` (from 05b)

Add these to the existing abstract + impl:

- `Future<Barter> getBarter(String barterId)`
- `Stream<List<Message>> messagesStream(String barterId)` — ordered by `createdAt` ascending.
- `Future<void> sendMessage(String barterId, String senderId, String text)` — creates message doc with `serverTimestamp()`. **Also updates** the parent barter doc's `lastMessageText` and `lastMessageTime` fields (denormalized for chat list sorting). **Also removes** both user IDs from `hiddenBy` (via `arrayRemove`) so the conversation resurfaces if either user had previously hidden it.
- `Future<void> markAsCompleted(String barterId)` — sets status to `'completed'`, `completedAt`.
- `Future<void> updateSchedule(String barterId, DateTime time, String platform)`
- `Future<void> incrementBarterCount(String userId)`
- `Future<void> markMessageAsRead(String barterId, String messageId)`

### `barter_room_viewmodel.dart`

- Family provider taking `barterId`.
- Gets `BarterRepository` via `ref.read(barterRepositoryProvider)`.
- `build()` fetches barter, other user, and starts message stream — all via repository.
- `sendMessage()`, `markAsCompleted()`, `updateSchedule()` — all delegate to repository.
- `markAsCompleted()` also calls `repository.incrementBarterCount()` for both users.
- Never imports `cloud_firestore`.

## Acceptance Criteria

- [ ] Messages stream in real time via repository.
- [ ] `sendMessage()` creates doc with `serverTimestamp()` and updates `lastMessageText`/`lastMessageTime` on the barter doc.
- [ ] `sendMessage()` auto-unhides the barter for both users.
- [ ] `markAsCompleted()` sets status and increments both users' barter counts.
- [ ] Only repository impl files import Firebase packages.

## What NOT to Do

- Do NOT write any UI code.
- Do NOT import `cloud_firestore` in the ViewModel.
- Do NOT allow re-opening a completed barter.
- Do NOT write raw English strings — use `'key'.tr()`. Add all new keys to both `en.json` and `ar.json`.
- Before adding any color, open `app_colors.dart` and `app_theme.dart` first to check if an equivalent already exists.
