# Task 08b — Ratings & Reviews Logic

## What This Task Builds

The review ViewModel for submitting reviews and recalculating ratings — uses the existing `ProfileRepository` for review storage.

## Files to Create

| File                    | Location                           |
| ----------------------- | ---------------------------------- |
| `review_viewmodel.dart` | `lib/features/profile/viewmodels/` |

## What the Logic Does

### Additional methods on `ProfileRepository` (from 02b/04b)

Add to the existing abstract + impl:

- `Future<void> submitReview(Review review)` — creates review doc, uses `serverTimestamp()`.
- `Future<bool> hasReviewed(String barterId, String reviewerId)` — checks if duplicate.
- `Future<void> recalculateRating(String userId)` — queries all reviews for user, computes average, updates user doc.

### `review_viewmodel.dart`

- Family provider taking `barterId`.
- Gets `ProfileRepository` and `BarterRepository` via refs.
- `build()` fetches barter, other user, and checks `hasAlreadyReviewed`.
- `submitReview(rating, comment)`:
  1. Calls `repository.submitReview(...)`.
  2. Calls `repository.recalculateRating(otherUserId)`.
- Never imports `cloud_firestore`.

## Acceptance Criteria

- [ ] Review creation goes through repository.
- [ ] Rating recalculation goes through repository.
- [ ] Duplicate reviews are prevented.
- [ ] Only repository impl files import Firebase packages.

## What NOT to Do

- Do NOT write any UI code.
- Do NOT import `cloud_firestore` in the ViewModel.
- Do NOT allow rating outside 1–5 or empty comments.
- Do NOT write raw English strings — use `'key'.tr()`. Add all new keys to both `en.json` and `ar.json`.
- Before adding any color, open `app_colors.dart` and `app_theme.dart` first to check if an equivalent already exists.
