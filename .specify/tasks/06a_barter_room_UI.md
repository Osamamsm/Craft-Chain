# Task 06a — Barter Room UI

## What This Task Builds

The dedicated chat screen for an active barter. This is where two users communicate, schedule their session, and ultimately mark the barter as completed.

> **Figma**: Before starting, the user will provide the Figma URL for these screens. Match the design exactly.

## Files to Create

| File                      | Location                             |
| ------------------------- | ------------------------------------ |
| `barter_room_screen.dart` | `lib/features/barter/views/`         |
| `message_bubble.dart`     | `lib/features/barter/views/widgets/` |

## UI Details

### Barter Room Screen

- **Header**:
  - Two overlapping `UserAvatar` widgets (48px each, offset by ~20px).
  - Below: exchange info text — "You teach **Flutter** ↔ They teach **Calligraphy**" in `AppTextStyles.bodyMedium`.
- **Session Banner** (below header):
  - If `scheduledAt` is set: Card showing "📅 {platform} — {formatted date/time}".
  - If not set: subtle text "No session scheduled yet — agree on a time in the chat!".
- **Chat Area**:
  - Scrollable list of `MessageBubble` widgets, newest at the bottom.
  - Messages sent by the current user appear on the right (filled, `AppColors.primary`).
  - Messages received appear on the left (gray/surface color).
  - Each bubble shows the message text and a small timestamp below.
  - Auto-scroll to bottom on new messages.
- **Input Area** (fixed at bottom):
  - `TextField` with rounded border and send icon button.
  - Send button is disabled when the text field is empty.
- **Mark as Completed**:
  - An icon button or menu option in the AppBar.
  - Tapping shows a confirmation dialog: "Mark this barter as completed?"
  - On confirm, calls the ViewModel method.

### Message Bubble

- Rounded rectangle with appropriate alignment (right for sent, left for received).
- Text in `AppTextStyles.bodyMedium`.
- Timestamp in `AppTextStyles.labelSmall`, muted color.
- Subtle entrance animation using `flutter_animate`.

## Existing Widgets to Reuse

- `UserAvatar` from `core/widgets/user_avatar.dart`.

## Acceptance Criteria

- [ ] Header shows overlapping avatars and exchange info.
- [ ] Session banner shows scheduled info or empty state.
- [ ] Messages render in real time as a scrollable list.
- [ ] Sent messages appear on the right, received on the left.
- [ ] Text input works and send button is disabled when empty.
- [ ] "Mark as Completed" triggers confirmation dialog.
- [ ] Auto-scrolls to bottom on new messages.
- [ ] All colors and text styles from theme constants.
- [ ] Responsive on mobile and web.
- [ ] Looks correct in both light and dark themes.

## What NOT to Do

- Do NOT call Firestore from this view — all through ViewModel.
- Do NOT hardcode colors or font sizes.
- Do NOT use `Navigator.push()`.
- Do NOT implement video/audio calling — sessions happen outside the app.
- Do NOT use `DateTime.now()` for timestamp display — format the server timestamp.
