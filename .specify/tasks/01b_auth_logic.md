# Task 01b — Authentication Logic

## What This Task Builds

The authentication repository (abstract + Firebase implementation), auth ViewModel, user ViewModel, user document creation, and the router redirect logic that gates access based on auth state and profile completeness.

## Files to Create

| File                        | Location                        |
| --------------------------- | ------------------------------- |
| `app_user.dart`             | `lib/features/auth/models/`     |
| `auth_repository.dart`      | `lib/features/auth/models/`     |
| `auth_repository_impl.dart` | `lib/features/auth/models/`     |
| `auth_viewmodel.dart`       | `lib/features/auth/viewmodels/` |
| `user_viewmodel.dart`       | `lib/features/auth/viewmodels/` |
| `app_router.dart`           | `lib/core/navigation/`          |
| `firestore_keys.dart`       | `lib/core/constants/`           |

## What the Logic Does

### `app_user.dart` (Model)

- A `freezed` immutable data class with all fields from the `users/{userId}` Firestore document.
- Includes `fromJson` / `toJson` factories.
- Fields: `uid`, `name`, `photoUrl`, `gender`, `city`, `bio`, `canTeach` (List<String>), `wantsToLearn` (List<String>), `rating`, `barterCount`, `isProfileComplete`, `isActive`, `createdAt`.
- Does NOT include `matchEmbedding` (that is Cloud Function only, never read by app).

### `auth_repository.dart` (Abstract)

- Defines the contract for authentication operations.
- Methods:
  - `Future<UserCredential> signUp(String email, String password)`
  - `Future<UserCredential> signIn(String email, String password)`
  - `Future<void> signOut()`
  - `Future<void> resetPassword(String email)`
  - `Stream<User?> authStateChanges()`
  - `Future<void> createUserDocument(String uid, String email)`
  - `Stream<AppUser?> userStream(String uid)`

### `auth_repository_impl.dart` (Firebase Implementation)

- Implements `AuthRepository` using `FirebaseAuth` and `FirebaseFirestore`.
- `signUp` creates a Firebase Auth account.
- `createUserDocument` creates a Firestore user document with `isProfileComplete: false` and default values. Uses `serverTimestamp()`.
- `userStream` listens to the `users/{uid}` document and emits `AppUser` instances.
- This is the ONLY file that imports `firebase_auth` and `cloud_firestore`.

### `auth_viewmodel.dart`

- Extends `AsyncNotifier<void>`.
- Gets `AuthRepository` via `ref.read(authRepositoryProvider)`.
- Methods:
  - `signUp(String email, String password)` — calls `repository.signUp` then `repository.createUserDocument`.
  - `signIn(String email, String password)` — calls `repository.signIn`.
  - `signOut()` — calls `repository.signOut`.
  - `resetPassword(String email)` — calls `repository.resetPassword`.
- Never imports `cloud_firestore` or `firebase_auth`.

### `user_viewmodel.dart`

- A `StreamProvider<AppUser?>` that listens to auth state changes via the repository.
- When authenticated, streams the user's Firestore document via `repository.userStream(uid)`.
- When not authenticated, emits `null`.
- This provider is the single source of truth for the current user.

### `app_router.dart`

- Configures `GoRouter` with all routes.
- The `redirect` function checks:
  1. If user is not authenticated (from `userViewModelProvider`) → redirect to `/`.
  2. If user is authenticated but `isProfileComplete == false` → redirect to `/setup`.
  3. If user is authenticated and on an auth page → redirect to `/home`.
- Defines a `ShellRoute` wrapping `/home`, `/explore`, `/barter-requests`, and `/profile/:userId`.

### `firestore_keys.dart`

- String constants for all collection names and field names.
- Prevents typos in Firestore paths.

### Provider Wiring

```dart
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  ),
);
```

## Existing Widgets/ViewModels to Reuse

- None — this is foundational.

## Acceptance Criteria

- [ ] `AppUser` model compiles and serializes to/from JSON correctly.
- [ ] `AuthRepository` abstract contains all required method signatures.
- [ ] `AuthRepositoryImpl` implements all methods using Firebase.
- [ ] `signUp` creates both a Firebase Auth user and a Firestore document.
- [ ] `signIn` authenticates and the user provider updates.
- [ ] `signOut` clears auth state and the user provider emits `null`.
- [ ] `resetPassword` sends email without error.
- [ ] Router redirect works: unauthenticated → `/`, incomplete profile → `/setup`, authenticated → `/home`.
- [ ] `userViewModelProvider` emits a live stream of the current user document.
- [ ] All Firestore writes use `FieldValue.serverTimestamp()`.
- [ ] Only `auth_repository_impl.dart` imports `firebase_auth` or `cloud_firestore`.
- [ ] ViewModel only uses the abstract `AuthRepository` interface.

## What NOT to Do

- Do NOT write any UI code in this task.
- Do NOT use `DateTime.now()` for any Firestore timestamps.
- Do NOT import `cloud_firestore` or `firebase_auth` in the ViewModel.
- Do NOT store `matchEmbedding` in the `AppUser` model.
