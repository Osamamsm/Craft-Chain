# Task 07a — Explore / Search UI

## What This Task Builds

The Explore screen where users search for other users by skill name or username. Results use the same card format as the match feed but are ordered by rating.

> **Figma**: Before starting, the user will provide the Figma URL for these screens. Match the design exactly.

## Files to Create

| File                  | Location                      |
| --------------------- | ----------------------------- |
| `explore_screen.dart` | `lib/features/explore/views/` |

## UI Details

### Explore Screen

- **Search bar** at the top:
  - Rounded `TextField` with a search icon prefix.
  - Placeholder: "Search by skill or name...".
  - Real-time search as user types (debounced, ~300ms).
  - Clear button (X icon) when text is present.
- **Results list**:
  - Reuses the same `MatchCard` widget from the matching feature.
  - However, the match score badge is hidden (since explore doesn't use AI scoring).
  - Results are ordered by `rating` descending.
- **Loading state**: Wrap the results in `Skeletonizer(enabled: isLoading, child: ...)` while searching.
- **Empty state**: `EmptyState` with "No users found" message.
- **Initial state** (no search yet): show a helpful message like "Search for skills or people to barter with" with an illustration icon.

## Existing Widgets to Reuse

- `MatchCard` from `features/matching/views/widgets/match_card.dart` — with `showMatchScore: false`.
- `EmptyState` from `core/widgets/empty_state.dart`.

## Acceptance Criteria

- [ ] Search bar is present and functional.
- [ ] Typing triggers debounced search.
- [ ] Results show in the same card format as match feed (minus match score).
- [ ] Results are ordered by rating.
- [ ] `Skeletonizer` skeleton shows during search.
- [ ] Empty state shows when no results found.
- [ ] Initial state shows before any search.
- [ ] Clear button resets the search.
- [ ] All colors and text styles from theme constants.
- [ ] Responsive on mobile and web.
- [ ] Looks correct in both light and dark themes.

## What NOT to Do

- Do NOT call Firestore from the view.
- Do NOT show match scores in explore results.
- Do NOT hardcode colors or font sizes.
- Do NOT use `Navigator.push()`.
- Do NOT write raw English strings in widgets — use `'key'.tr()` from `easy_localization`. Add all new keys to both `en.json` and `ar.json`.
- Before adding any color, open `app_colors.dart` and `app_theme.dart` first to check if an equivalent already exists.
