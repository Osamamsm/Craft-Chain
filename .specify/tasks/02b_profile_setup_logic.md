# Task 02b — Profile Setup Logic

## What This Task Builds

The profile repository (abstract + impl), profile setup ViewModel, photo upload, and Firestore profile completion logic.

## Files to Create

| File                           | Location                           |
| ------------------------------ | ---------------------------------- |
| `profile_repository.dart`      | `lib/features/profile/models/`     |
| `profile_repository_impl.dart` | `lib/features/profile/models/`     |
| `profile_setup_viewmodel.dart` | `lib/features/profile/viewmodels/` |

## What the Logic Does

### `profile_repository.dart` (Abstract)

- Defines the contract for profile operations.
- Methods:
  - `Future<String> uploadProfilePhoto(String uid, XFile photo)` — returns download URL.
  - `Future<void> completeProfile(String uid, Map<String, dynamic> data)` — writes all profile fields and sets `isProfileComplete: true`.
  - `Future<void> updateProfile(String uid, Map<String, dynamic> data)` — updates specific fields.
  - `Future<AppUser> getUser(String uid)` — fetches a user document.
  - `Stream<AppUser?> userStream(String uid)` — streams a user document.

### `profile_repository_impl.dart` (Firebase Implementation)

- Implements `ProfileRepository` using `FirebaseFirestore` and `FirebaseStorage`.
- `uploadProfilePhoto` uploads to `profile_photos/{uid}.jpg` and returns the download URL.
- `completeProfile` updates the user document with all fields including `isProfileComplete: true` and `isActive: true`, using `serverTimestamp()`.
- This is the ONLY file that imports `cloud_firestore` / `firebase_storage`.

### `ProfileSetupViewModel`

- Extends `Notifier<ProfileSetupState>`.
- Gets `ProfileRepository` via `ref.read(profileRepositoryProvider)`.
- `ProfileSetupState` is a local state class (can be `freezed`) holding:
  - `currentStep` (int, 0–4)
  - `name`, `gender`, `photoFile`, `city`, `canTeach`, `wantsToLearn`, `bio`
  - `isSubmitting`, `error`

### Methods

| Method                          | What it does                                                                    |
| ------------------------------- | ------------------------------------------------------------------------------- |
| `setName(String)` etc.          | Updates corresponding field in state                                            |
| `toggleTeachSkill(String)`      | Adds/removes a skill from canTeach                                              |
| `toggleLearnSkill(String)`      | Adds/removes a skill from wantsToLearn                                          |
| `nextStep()` / `previousStep()` | Navigate wizard steps                                                           |
| `isCurrentStepValid` (getter)   | Checks if current step has required data                                        |
| `submitProfile()`               | Uploads photo via repo, writes profile via repo, sets `isProfileComplete: true` |

### `submitProfile()` Flow

1. Set `isSubmitting = true`.
2. Call `repository.uploadProfilePhoto(uid, photo)`.
3. Call `repository.completeProfile(uid, allFields)`.
4. On success: router redirect auto-navigates to `/home`.
5. On failure: set error in state.

### Skill List

- A constant list of predefined skills is defined in a constants file.
- Categories: Tech, Design, Languages, Crafts, Business.

## Existing Widgets/ViewModels to Reuse

- `userViewModelProvider` from auth — to get current user's UID.
- `AuthRepository` — already provides user stream.

## Acceptance Criteria

- [ ] `ProfileRepository` abstract defines all required methods.
- [ ] `ProfileRepositoryImpl` implements all methods using Firebase.
- [ ] Only `profile_repository_impl.dart` imports Firebase packages.
- [ ] All state fields update correctly when setter methods are called.
- [ ] `isCurrentStepValid` returns correct validation for each step.
- [ ] Photo uploads to Firebase Storage and URL is stored.
- [ ] `isProfileComplete` is set to `true` in Firestore.
- [ ] All timestamps use `FieldValue.serverTimestamp()`.

## What NOT to Do

- Do NOT write any UI code.
- Do NOT use `DateTime.now()`.
- Do NOT import `cloud_firestore` or `firebase_storage` in the ViewModel.
- Do NOT bypass validation.
