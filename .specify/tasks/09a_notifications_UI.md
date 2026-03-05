# Task 09a — Notifications UI

## What This Task Builds

The in-app notification handling: displaying push notifications and navigating users to the relevant screen when tapped.

> **Figma**: Before starting, the user will provide the Figma URL if there are notification-related screens. Match the design exactly.

## Files to Create

No new screen files are needed for notifications. This task modifies:

| File                | Location               | Action                                                 |
| ------------------- | ---------------------- | ------------------------------------------------------ |
| `main.dart`         | `lib/`                 | Add FCM initialization and foreground message handling |
| `shell_screen.dart` | `lib/core/navigation/` | Add notification badge on requests tab                 |

## UI Details

### Push Notification Display

- When the app is in the **foreground**: show a Material banner or local notification at the top of the screen.
- When the app is in the **background or terminated**: system push notification is displayed by the OS via FCM.

### Notification Tap Actions

| Notification Type       | Navigate To               |
| ----------------------- | ------------------------- |
| Barter request received | `/barter-requests`        |
| Barter request accepted | `/barter-room/{barterId}` |
| Barter request declined | `/barter-requests`        |
| New message             | `/barter-room/{barterId}` |
| Session reminder        | `/barter-room/{barterId}` |

### Badge on Requests Tab

- The Requests tab in the bottom nav / sidebar should show a badge dot when there are unread pending requests.
- The badge disappears when the user views the requests screen.

## Existing Widgets to Reuse

- `ShellScreen` from `core/navigation/shell_screen.dart` — add badge to it.

## Acceptance Criteria

- [ ] FCM is initialized on app startup.
- [ ] Foreground notifications display a banner.
- [ ] Tapping a notification navigates to the correct screen.
- [ ] Background notifications show via OS.
- [ ] Badge dot shows on Requests tab when there are unread requests.
- [ ] Badge clears when requests screen is opened.

## What NOT to Do

- Do NOT send notifications from the client — they are sent by Cloud Functions.
- Do NOT hardcode colors or font sizes.
- Do NOT use `Navigator.push()` for notification tap navigation — use `context.go()`.
- Do NOT write raw English strings in widgets — use `'key'.tr()` from `easy_localization`. Add all new keys to both `en.json` and `ar.json`.
- Before adding any color, open `app_colors.dart` and `app_theme.dart` first to check if an equivalent already exists.
