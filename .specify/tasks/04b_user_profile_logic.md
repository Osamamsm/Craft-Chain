# Task 04b — User Profile Logic

## What This Task Builds

Profile and review fetching logic using the profile repository (created in 02b). Adds review model and methods for viewing/editing profiles.

## Files to Create

| File                     | Location                           |
| ------------------------ | ---------------------------------- |
| `review.dart`            | `lib/features/profile/models/`     |
| `profile_viewmodel.dart` | `lib/features/profile/viewmodels/` |

## What the Logic Does

### `review.dart` (Model)

- A `freezed` immutable data class: `reviewId`, `barterId`, `reviewerId`, `revieweeId`, `skillExchanged`, `rating` (int), `comment`, `createdAt`.
- `fromJson` / `toJson` factories.

### Additional methods on `ProfileRepository` (abstract, from 02b)

These methods should be added to the existing `ProfileRepository` and `ProfileRepositoryImpl`:

- `Future<List<Review>> getReviews(String userId)` — queries reviews where `revieweeId == userId`, ordered by `createdAt` descending.
- `Future<void> updateProfile(String uid, Map<String, dynamic> data)` — updates specific user fields.

### `profile_viewmodel.dart`

- Profile Provider (Family): `FutureProvider.family<AppUser, String>` that calls `repository.getUser(userId)`.
- Reviews Provider (Family): `FutureProvider.family<List<Review>, String>` that calls `repository.getReviews(userId)`.
- Edit Profile ViewModel: `AsyncNotifier<void>` with `updateProfile()` method that calls the repository. If `newPhoto` is provided, uploads via `repository.uploadProfilePhoto()` first.
- All access through abstract `ProfileRepository` — never imports `cloud_firestore`.

## Acceptance Criteria

- [ ] `Review` model serializes correctly.
- [ ] Profile provider fetches any user by ID via repository.
- [ ] Reviews provider fetches all reviews via repository.
- [ ] `updateProfile()` works including photo re-upload.
- [ ] Gender is never updated by `updateProfile()`.
- [ ] Only repository impl files import Firebase packages.

## What NOT to Do

- Do NOT write any UI code.
- Do NOT allow gender to be updated.
- Do NOT import `cloud_firestore` in the ViewModel.
- Do NOT write raw English strings — use `'key'.tr()`. Add all new keys to both `en.json` and `ar.json`.
- Before adding any color, open `app_colors.dart` and `app_theme.dart` first to check if an equivalent already exists.
