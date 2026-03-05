# CraftChain — Constitution

## Absolute Rules

These rules must NEVER be broken, regardless of any task, shortcut, or refactor. Violating any of these rules is a blocker — the code must be fixed before merging.

---

### 1. Gender Filter at Firestore Query Level — Always

Every query that returns users (match feed, explore, search) **must** include a `.where('gender', isEqualTo: currentUser.gender)` clause at the Firestore query level. This filter must **never** be applied only in the UI (e.g., filtering a list in Dart after fetching). The Firestore query itself must exclude opposite-gender users so they are never even downloaded to the device.

### 2. No Business Logic in Views — Ever

Views (screens, widgets) are for presentation only. They:

- Read state from Cubits via `BlocBuilder` / `BlocListener` / `context.read<T>()`
- Call Cubit methods in response to user actions
- Display loading, error, and data states

They must **never** contain:

- Firestore queries or writes
- Conditional business rules (e.g., "if user has no skills, do X")
- Data transformations or calculations
- Navigation guards or auth checks (these go in the router or ViewModel)

### 3. No Direct Firestore Calls from Views or ViewModels — Ever

All Firestore reads and writes must go through **repository implementations** (`*_repository_impl.dart`). ViewModels only interact with the **abstract repository** interface.

The layering is strict:

- **Views** → never import `cloud_firestore` or any repository.
- **ViewModels** → import only the abstract repository. Never import `cloud_firestore`.
- **Repository Impl** → the ONLY place that imports and calls `cloud_firestore`, `firebase_auth`, `firebase_storage`, etc.

### 4. No Hardcoded Colors or Font Sizes — Ever

All colors must come from `AppColors` (`core/theme/app_colors.dart`).
All text styles must come from `AppTextStyles` (`core/theme/app_text_styles.dart`).

Never write:

```dart
// ❌ WRONG
color: Color(0xFF2196F3)
fontSize: 16
```

Always write:

```dart
// ✅ CORRECT
color: AppColors.primary
style: AppTextStyles.bodyMedium
```

### 5. No Packages Added Without Asking

Before adding any new package to `pubspec.yaml`, you must ask and get approval. The approved package list is defined in `plan.md`. Any package not on that list requires explicit permission.

### 6. `serverTimestamp()` Always — Never Device Clock

Every `createdAt`, `updatedAt`, `completedAt`, or any other timestamp field must use `FieldValue.serverTimestamp()` when writing to Firestore. Never use `DateTime.now()` or any device-local time for Firestore timestamps.

```dart
// ❌ WRONG
'createdAt': DateTime.now()

// ✅ CORRECT
'createdAt': FieldValue.serverTimestamp()
```

### 7. `context.go()` Always — Never `Navigator.push()`

All navigation must go through `go_router` using `context.go()`, `context.goNamed()`, `context.push()`, or `context.pushNamed()`.

Never use:

```dart
// ❌ WRONG
Navigator.push(context, MaterialPageRoute(...))
Navigator.of(context).push(...)
```

Always use:

```dart
// ✅ CORRECT
context.go('/home')
context.push('/profile/$userId')
```

### 8. All Firebase Imports Only in Repository Implementations

Only `*_repository_impl.dart` files may import Firebase packages (`cloud_firestore`, `firebase_auth`, `firebase_storage`). No other file in the codebase may import these packages directly. This ensures a clean separation between business logic and the backend provider.

### 9. No Hardcoded Strings — Ever

All user-visible text must use `easy_localization` keys via the `.tr()` extension. Never write a raw string inside a widget:

```dart
// ❌ WRONG
Text('Sign In')
return 'Password is required';

// ✅ CORRECT
Text('auth.sign_in'.tr())
return 'auth.validation_password_required'.tr();
```

Every new key **must** be added to both `assets/translations/en.json` and `assets/translations/ar.json` before the code is considered complete.

### 10. Check Colors & Theme Files Before Adding New Colors — Always

Before introducing any new color value anywhere in the codebase, you **must** open and read:

- `core/theme/app_colors.dart`
- `core/theme/app_theme.dart`

If an equivalent color already exists, **reuse it**. Never add a duplicate color constant. If a genuinely new semantic color is needed, add it to `AppColorPalette` (both `light` and `dark`) in `app_colors.dart` and wire it into `app_theme.dart`.

```dart
// ❌ WRONG — adding a raw color without checking
color: Color(0xFF2563EB)   // already exists as AppColors.light.primary

// ✅ CORRECT — reuse the existing semantic name
color: colors.primary
```
