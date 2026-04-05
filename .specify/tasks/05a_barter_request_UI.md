# Task 05a — Barter Request UI

## What This Task Builds

The bottom sheet for sending a barter request and the main Barters screen — which serves as the hub for **active/past conversations**, **received requests**, and **sent requests**.

> **Figma**: Before starting, the user will provide the Figma URL for these screens. Match the design exactly.

## Files to Create

| File                          | Location                             |
| ----------------------------- | ------------------------------------ |
| `barter_request_sheet.dart`   | `lib/features/barter/views/widgets/` |
| `barter_chat_tile.dart`       | `lib/features/barter/views/widgets/` |
| `barter_requests_screen.dart` | `lib/features/barter/views/`         |

## UI Details

### Barter Request Bottom Sheet

- Triggered by tapping "Send Barter Request" on a profile screen.
- **Title**: "Send Barter Request" in `AppTextStyles.titleLarge`.
- **Section 1**: "What will you teach them?"
  - A list of the current user's `canTeach` skills as selectable chips (green).
  - User selects exactly one.
- **Section 2**: "What do you want to learn from them?"
  - A list of the other user's `canTeach` skills as selectable chips (blue).
  - User selects exactly one.
- **Submit button**: "Send Request" — full width, disabled until both skills are selected.
- **Loading state**: spinner in the button while submitting.
- **Success state**: close the bottom sheet, show a snackbar "Barter request sent!".

### Barter Requests Screen

- Accessible from the bottom nav (Barters tab).
- **Three tabs** at the top: **"Chats"** (default), **"Received"**, and **"Sent"**.

#### Chats Tab (default — index 0)

- Shows all barter conversations the current user is part of where `status` is `'active'` or `'completed'`.
- Sorted by most-recent message timestamp (newest first).
- Each item is a `BarterChatTile` widget displaying:
  - Other user's `UserAvatar` (48px).
  - Other user's name (bold) and the exchange summary: "Flutter ↔ Calligraphy".
  - Last message preview text (single line, truncated) and its relative timestamp (e.g. "2m", "1h", "Yesterday").
  - A small status badge: green dot for `'active'`, gray checkmark for `'completed'`.
  - Unread message count badge (if > 0) on the trailing side.
- Tapping a tile navigates to the Barter Room screen (`/barter-room/:barterId`).
- **Swipe to delete** (using `Dismissible`): swiping a tile reveals a red delete background. On confirm, the chat is hidden from the user's list (soft-delete via a `hiddenBy` array field on the barter doc — does NOT delete the barter or messages). A snackbar with "Undo" appears.
- **Empty state**: "No conversations yet — accept a barter request to start chatting!" with the `EmptyState` widget.

#### Received Tab

- List of incoming pending requests (`status == 'pending'`, current user is `user2Id`).
  - Each card shows: requester's avatar, name, "wants to teach you {skill}" and "wants to learn {skill}".
  - Two buttons: "Accept" (filled, green) and "Decline" (outlined, red).
- **Empty state**: "No pending requests" with the `EmptyState` widget.

#### Sent Tab

- List of outgoing pending requests (`status == 'pending'`, current user is `user1Id`).
  - Each card shows: recipient's avatar, name, the skills being exchanged, and status ("Pending").
  - No action buttons — just informational.
- **Empty state**: "No sent requests" with the `EmptyState` widget.

## Existing Widgets to Reuse

- `SkillChip` from `core/widgets/skill_chip.dart`.
- `UserAvatar` from `core/widgets/user_avatar.dart`.
- `EmptyState` from `core/widgets/empty_state.dart`.
- Use `Skeletonizer` for loading states.

## Acceptance Criteria

- [ ] Bottom sheet opens with correct skill lists.
- [ ] Submit is disabled until both skills are selected.
- [ ] Loading state shows during submission.
- [ ] Success closes sheet and shows snackbar.
- [ ] Requests screen shows three tabs: Chats (default), Received, Sent.
- [ ] Chats tab lists active and completed barter conversations sorted by last message.
- [ ] Each chat tile shows avatar, name, exchange skills, last message preview, timestamp, and unread badge.
- [ ] Tapping a chat tile navigates to the Barter Room screen.
- [ ] Swipe-to-delete hides a chat from the user's list with undo support.
- [ ] Accept/Decline buttons are visible on received requests.
- [ ] Empty states show for each tab when no items exist.
- [ ] All colors and text styles from theme constants.
- [ ] Responsive on mobile and web.
- [ ] Looks correct in both light and dark themes.

## What NOT to Do

- Do NOT call Firestore from views.
- Do NOT hardcode colors or font sizes.
- Do NOT use `Navigator.push()`.
- Do NOT allow selecting more than one skill per section.
- Do NOT write raw English strings in widgets — use `'key'.tr()` from `easy_localization`. Add all new keys to both `en.json` and `ar.json`.
- Before adding any color, open `app_colors.dart` and `app_theme.dart` first to check if an equivalent already exists.
