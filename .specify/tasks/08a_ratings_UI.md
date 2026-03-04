# Task 08a — Ratings & Reviews UI

## What This Task Builds

The review form that appears after a barter is marked complete. Both users rate and review each other.

> **Figma**: Before starting, the user will provide the Figma URL for these screens. Match the design exactly.

## Files to Create

| File                      | Location                      |
| ------------------------- | ----------------------------- |
| `review_form_screen.dart` | `lib/features/profile/views/` |

## UI Details

### Review Form Screen

- Navigated to after a barter is marked complete (`/review/{barterId}`).
- **Header**: "Rate your experience" in `AppTextStyles.headlineMedium`.
- **Subheader**: "Your barter with **{otherUserName}**" showing the other user's avatar.
- **Skill exchanged**: "They taught you **{skill}**" text.
- **Star rating**:
  - 5 star icons in a row.
  - Tapping a star selects it and all stars before it (standard star rating UX).
  - Unselected: outlined star, `AppColors.onSurfaceVariant`.
  - Selected: filled star, `AppColors.warning` (amber/gold).
- **Comment field**:
  - Multiline `TextField`, 3–4 lines.
  - Hint: "Share your experience...".
  - Required, non-empty.
- **Submit button**: "Submit Review" — full width.
  - Disabled until rating ≥ 1 and comment is non-empty.
  - Shows spinner while submitting.
- **Success state**: Show a thank-you message with animation, then navigate back.

## Existing Widgets to Reuse

- `UserAvatar` from `core/widgets/user_avatar.dart`.

## Acceptance Criteria

- [ ] Star rating works: tapping selects stars visually.
- [ ] Comment field is required.
- [ ] Submit is disabled until both rating and comment are provided.
- [ ] Loading spinner shows during submission.
- [ ] On success, user sees thank-you and navigates away.
- [ ] All colors and text styles from theme constants.
- [ ] Responsive on mobile and web.
- [ ] Looks correct in both light and dark themes.

## What NOT to Do

- Do NOT call Firestore from the view.
- Do NOT hardcode colors or font sizes.
- Do NOT allow submitting without both rating and comment.
- Do NOT use `Navigator.push()`.
