# Task 04a — User Profile Screen UI

## What This Task Builds

The screen that displays a user's full profile — their info, skills, reviews, and action buttons. This is used both as a "view other user" screen and a "view own profile" screen.

> **Figma**: Before starting, the user will provide the Figma URL for these screens. Match the design exactly.

## Files to Create

| File                       | Location                      |
| -------------------------- | ----------------------------- |
| `profile_screen.dart`      | `lib/features/profile/views/` |
| `edit_profile_screen.dart` | `lib/features/profile/views/` |

## UI Details

### Profile Screen

- **Header section**:
  - Large `UserAvatar` (96px, centered).
  - Name in `AppTextStyles.headlineMedium`.
  - City in `AppTextStyles.bodyMedium`, muted color.
  - Row of stats: star rating (with star icon), barter count (with swap icon).
- **Bio section**:
  - Section header "About".
  - Bio text in `AppTextStyles.bodyMedium`.
- **Skills section**:
  - "Skills I Teach" header with green `SkillChip` widgets in a `Wrap`.
  - "Skills I Want to Learn" header with blue `SkillChip` widgets in a `Wrap`.
- **Reviews section**:
  - "Reviews" header with count.
  - List of review cards, each showing:
    - Reviewer's name and small avatar.
    - Star rating.
    - Skill exchanged.
    - Comment text.
  - If no reviews, show "No reviews yet" empty state.
- **Bottom action**:
  - If viewing someone else's profile: **"Send Barter Request"** button (full-width, fixed at bottom).
  - If viewing own profile: **"Edit Profile"** button (outlined style).

### Edit Profile Screen

- AppBar with "Edit Profile" title and a "Save" button.
- Editable fields: name, photo (with change option), city, canTeach (chip selector), wantsToLearn (chip selector), bio.
- Gender is displayed but NOT editable.
- "Save" calls the ViewModel method.

### Responsive Layout

- On mobile: single column, full width.
- On web (≥ 700px): centered card with max-width ~600px.

## Existing Widgets to Reuse

- `UserAvatar` from `core/widgets/user_avatar.dart`.
- `SkillChip` from `core/widgets/skill_chip.dart`.
- `EmptyState` from `core/widgets/empty_state.dart`.
- Use `Skeletonizer` for loading states instead of shimmer widgets.

## Acceptance Criteria

- [ ] Profile screen shows all required info: avatar, name, city, rating, barter count, bio, skills, reviews.
- [ ] "Send Barter Request" button shows for other users.
- [ ] "Edit Profile" button shows for own profile.
- [ ] Edit Profile screen loads current values and allows editing.
- [ ] Gender is visible but not editable on Edit screen.
- [ ] Reviews list renders correctly or shows empty state.
- [ ] Skills show correct colors (green for teach, blue for learn).
- [ ] Responsive layout works on mobile and web.
- [ ] Looks correct in both light and dark themes.
- [ ] All colors and text styles from theme constants.

## What NOT to Do

- Do NOT call Firestore from views.
- Do NOT hardcode colors or font sizes.
- Do NOT allow gender editing.
- Do NOT use `Navigator.push()`.
- Do NOT write raw English strings in widgets — use `'key'.tr()` from `easy_localization`. Add all new keys to both `en.json` and `ar.json`.
- Before adding any color, open `app_colors.dart` and `app_theme.dart` first to check if an equivalent already exists.
