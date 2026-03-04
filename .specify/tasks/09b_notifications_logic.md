# Task 09b — Notifications Logic

## What This Task Builds

The FCM setup, token management, foreground notification handling, and notification tap routing.

## Files to Create

| File                        | Location             |
| --------------------------- | -------------------- |
| `notification_service.dart` | `lib/core/services/` |

## What the Logic Does

### `notification_service.dart`

A service class (not a ViewModel) that handles all FCM operations. Initialized once in `main.dart`.

### Initialization Flow

1. Request notification permissions (iOS requires explicit permission).
2. Get the FCM device token.
3. Save the token to the current user's Firestore document (`fcmToken` field).
4. Listen for token refresh and update Firestore if the token changes.

### Foreground Message Handling

- Register a `FirebaseMessaging.onMessage` listener.
- When a message arrives while the app is in the foreground, use `flutter_local_notifications` to display a local notification banner.

### Notification Tap Handling

- Register `FirebaseMessaging.onMessageOpenedApp` listener for background taps.
- Check `FirebaseMessaging.instance.getInitialMessage()` for terminated-state taps.
- Extract the notification data payload (which contains `type` and `targetId` fields).
- Navigate using `go_router`:

| Payload `type`     | Navigate to               |
| ------------------ | ------------------------- |
| `barter_request`   | `/barter-requests`        |
| `barter_accepted`  | `/barter-room/{targetId}` |
| `barter_declined`  | `/barter-requests`        |
| `new_message`      | `/barter-room/{targetId}` |
| `session_reminder` | `/barter-room/{targetId}` |

### Token Cleanup on Sign Out

- When user signs out, remove the `fcmToken` from their Firestore document to stop receiving notifications.

## Existing Widgets/ViewModels to Reuse

- `userViewModelProvider` from auth — to get current user UID for token storage.
- `app_router.dart` — for navigating on notification tap.

## Acceptance Criteria

- [ ] FCM permission is requested on app start.
- [ ] FCM token is saved to the user's Firestore document.
- [ ] Token refresh updates Firestore.
- [ ] Foreground messages display a local notification.
- [ ] Tapping a background/terminated notification navigates correctly.
- [ ] Token is removed on sign out.

## What NOT to Do

- Do NOT send notifications from the client — all sent by Cloud Functions.
- Do NOT write any UI code (except the local notification display).
- Do NOT store tokens in local storage — always in Firestore.
- Do NOT use `Navigator.push()` for navigation.
