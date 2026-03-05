# Task 03a — Match Feed UI

## What This Task Builds

The Home screen that displays a ranked list of AI-matched users with complementary skills. This is the primary screen users see after onboarding.

> **Figma**: Before starting, the user will provide the Figma URL for these screens. Match the design exactly.

## Files to Create

| File                     | Location                               |
| ------------------------ | -------------------------------------- |
| `match_feed_screen.dart` | `lib/features/matching/views/`         |
| `match_card.dart`        | `lib/features/matching/views/widgets/` |
| `filter_chips_bar.dart`  | `lib/features/matching/views/widgets/` |

## UI Details

### Match Feed Screen

- **Top**: Filter chips bar (horizontal scrollable row).
- **Body**: Scrollable list of `MatchCard` widgets.
- **Bottom**: "Load More" button or infinite scroll trigger when reaching the end.
- **Empty state**: Use `EmptyState` widget — "No matches found yet. Update your skills to find more matches!"
- **Loading state**: Wrap the list in `Skeletonizer(enabled: isLoading, child: ...)` to show skeleton placeholders while data loads.
- **Error state**: Error message with a "Retry" button.

### Filter Chips Bar

- Horizontal scrollable row of chips: **All**, **Tech**, **Design**, **Languages**, **Crafts**, **Business**.
- Selected chip is filled with `AppColors.primary`. Unselected chips are outlined.
- Tapping a chip calls the ViewModel's filter method.

### Match Card

- Card with rounded corners and subtle shadow.
- **Left**: `UserAvatar` (circular, 56px).
- **Right**:
  - Name in `AppTextStyles.titleMedium`.
  - City in `AppTextStyles.bodySmall`, muted color.
  - Skills they teach: row of `SkillChip` widgets (green, `isTeach: true`).
  - Skills they want to learn: row of `SkillChip` widgets (blue, `isTeach: false`).
  - Bottom row: match score badge (e.g., "87% match" with icon), star rating, barter count.
- **Tap**: navigates to `/profile/{userId}` via `context.push()`.
- Entry animation: cards fade + slide up, staggered by index using `flutter_animate`.

## Existing Widgets to Reuse

- `SkillChip` from `core/widgets/skill_chip.dart`.
- `UserAvatar` from `core/widgets/user_avatar.dart`.
- `EmptyState` from `core/widgets/empty_state.dart`.

## Acceptance Criteria

- [ ] Match feed displays a list of user cards with all required info.
- [ ] Filter chips work and re-filter the list.
- [ ] Pagination loads the next batch (10 per page).
- [ ] `Skeletonizer` skeleton shows while data is fetching.
- [ ] Empty state shows when no matches exist.
- [ ] Tapping a card navigates to the user's profile.
- [ ] All colors and text styles come from theme constants.
- [ ] Looks good on mobile and web.
- [ ] Looks correct in both light and dark themes.
- [ ] Staggered entry animations are smooth.

## What NOT to Do

- Do NOT compute match scores in the UI — read precomputed scores from the ViewModel.
- Do NOT call Firestore from this screen.
- Do NOT hardcode colors or font sizes.
- Do NOT use `Navigator.push()`.
- Do NOT write raw English strings in widgets — use `'key'.tr()` from `easy_localization`. Add all new keys to both `en.json` and `ar.json`.
- Before adding any color, open `app_colors.dart` and `app_theme.dart` first to check if an equivalent already exists.
