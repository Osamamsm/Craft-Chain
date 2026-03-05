# Task 07b — Explore / Search Logic

## What This Task Builds

The explore repository (abstract + impl) and ViewModel for searching users by skill or name with gender filtering.

## Files to Create

| File                           | Location                           |
| ------------------------------ | ---------------------------------- |
| `explore_repository.dart`      | `lib/features/explore/models/`     |
| `explore_repository_impl.dart` | `lib/features/explore/models/`     |
| `explore_viewmodel.dart`       | `lib/features/explore/viewmodels/` |

## What the Logic Does

### `explore_repository.dart` (Abstract)

- Methods:
  - `Future<List<AppUser>> searchBySkill(String query, String gender, {int limit = 20})` — query `canTeach` with `arrayContains`, gender filter at Firestore level, order by `rating` descending.
  - `Future<List<AppUser>> searchByName(String query, String gender, {int limit = 20})` — prefix-based name query with gender filter at Firestore level.

### `explore_repository_impl.dart` (Firebase Implementation)

- Both queries MUST include `.where('gender', isEqualTo: gender)` — gender filter at Firestore level, never in Dart.
- Only file that imports `cloud_firestore`.

### `explore_viewmodel.dart`

- Gets `ExploreRepository` via `ref.read(exploreRepositoryProvider)`.
- `search(query)` runs both skill and name queries via repository, merges and deduplicates.
- `clearSearch()` resets to empty list.
- Never imports `cloud_firestore`.

## Acceptance Criteria

- [ ] Repository abstract and impl are correctly separated.
- [ ] Gender filter is applied at Firestore query level in impl.
- [ ] Results ordered by rating descending.
- [ ] Only `explore_repository_impl.dart` imports Firebase packages.

## What NOT to Do

- Do NOT write any UI code.
- Do NOT import `cloud_firestore` in the ViewModel.
- Do NOT compute or display match scores.
- Do NOT filter gender in Dart.
- Do NOT write raw English strings — use `'key'.tr()`. Add all new keys to both `en.json` and `ar.json`.
- Before adding any color, open `app_colors.dart` and `app_theme.dart` first to check if an equivalent already exists.
