# Task 05a — Barter Request UI

## What This Task Builds

The bottom sheet for sending a barter request and the screen for viewing incoming/outgoing pending requests.

> **Figma**: Before starting, the user will provide the Figma URL for these screens. Match the design exactly.

## Files to Create

| File                          | Location                             |
| ----------------------------- | ------------------------------------ |
| `barter_request_sheet.dart`   | `lib/features/barter/views/widgets/` |
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

- Accessible from the bottom nav (Requests tab).
- **Two tabs** at the top: "Received" and "Sent".
- **Received tab**: List of incoming pending requests.
  - Each card shows: requester's avatar, name, "wants to teach you {skill}" and "wants to learn {skill}".
  - Two buttons: "Accept" (filled, green) and "Decline" (outlined, red).
- **Sent tab**: List of outgoing pending requests.
  - Each card shows: recipient's avatar, name, the skills being exchanged, and status ("Pending").
  - No action buttons — just informational.
- **Empty state**: "No pending requests" with the `EmptyState` widget.

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
- [ ] Requests screen shows received and sent tabs.
- [ ] Accept/Decline buttons are visible on received requests.
- [ ] Empty states show when no requests exist.
- [ ] All colors and text styles from theme constants.
- [ ] Responsive on mobile and web.
- [ ] Looks correct in both light and dark themes.

## What NOT to Do

- Do NOT call Firestore from views.
- Do NOT hardcode colors or font sizes.
- Do NOT use `Navigator.push()`.
- Do NOT allow selecting more than one skill per section.
