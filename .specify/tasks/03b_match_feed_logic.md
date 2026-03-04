# Task 03b — Match Feed Logic

## What This Task Builds

The match repository (abstract + impl), match suggestion model, and match feed ViewModel for reading precomputed scores, applying filters, and paginating.

## Files to Create

| File                         | Location                            |
| ---------------------------- | ----------------------------------- |
| `match_suggestion.dart`      | `lib/features/matching/models/`     |
| `match_repository.dart`      | `lib/features/matching/models/`     |
| `match_repository_impl.dart` | `lib/features/matching/models/`     |
| `match_feed_viewmodel.dart`  | `lib/features/matching/viewmodels/` |

## What the Logic Does

### `match_suggestion.dart` (Model)

- A `freezed` immutable data class: `matchedUserId`, `score`, `updatedAt`, plus joined user fields (`name`, `photoUrl`, `city`, `canTeach`, `wantsToLearn`, `rating`, `barterCount`).

### `match_repository.dart` (Abstract)

- Methods:
  - `Future<List<MatchSuggestion>> getMatches(String userId, String gender, {DocumentSnapshot? startAfter, int limit = 10})` — fetches paginated match suggestions, joining with user profiles, gender-filtered at Firestore level.
  - `Future<AppUser> getUserProfile(String userId)` — fetches a single user.

### `match_repository_impl.dart` (Firebase Implementation)

- Queries `matches/{userId}/suggestions` ordered by `score` descending.
- For each suggestion, fetches user profile from `users/{matchedUserId}` with `.where('gender', isEqualTo: gender)` — **gender filter at Firestore level**.
- Only file that imports `cloud_firestore`.

### `match_feed_viewmodel.dart`

- Extends `AsyncNotifier<MatchFeedState>` holding `suggestions`, `activeFilter`, `hasMore`, `lastDocument`.
- Gets `MatchRepository` via `ref.read(matchRepositoryProvider)`.
- `build()` fetches first 10 matches via repository.
- `loadMore()` fetches next page.
- `applyFilter(category)` re-queries filtered results.
- Never imports `cloud_firestore`.

## Acceptance Criteria

- [ ] `MatchRepository` abstract defines the contract.
- [ ] `MatchRepositoryImpl` implements with Firebase and applies gender filter at query level.
- [ ] Only `match_repository_impl.dart` imports `cloud_firestore`.
- [ ] Pagination works correctly with cursor.
- [ ] No match scores are computed in the app.

## What NOT to Do

- Do NOT compute match scores — read precomputed values only.
- Do NOT filter gender in Dart — filter in the Firestore query.
- Do NOT import `cloud_firestore` in the ViewModel.
- Do NOT write any UI code.
