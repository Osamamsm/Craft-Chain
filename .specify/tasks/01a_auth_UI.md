# Task 01a — Authentication UI

## What This Task Builds

All authentication screens: Welcome, Sign Up, Sign In, and Forgot Password. These are the first screens a user sees. They must look clean, professional, and set the tone for the app.

> **Figma**: Before starting, the user will provide the Figma URL for these screens. Match the design exactly.

## Files to Create

| File                          | Location                   |
| ----------------------------- | -------------------------- |
| `welcome_screen.dart`         | `lib/features/auth/views/` |
| `sign_up_screen.dart`         | `lib/features/auth/views/` |
| `sign_in_screen.dart`         | `lib/features/auth/views/` |
| `forgot_password_screen.dart` | `lib/features/auth/views/` |

## UI Details

### Welcome Screen

- App logo centered at the top.
- App name "CraftChain" in large text with `AppTextStyles.headlineLarge`.
- Tagline: "Exchange skills, grow together" in `AppTextStyles.bodyLarge`.
- Two full-width buttons:
  - "Get Started" (filled button, `AppColors.primary`).
  - "Sign In" (outlined button, `AppColors.primary`).
- Background: subtle gradient or solid `AppColors.background`.
- Entry animation using `flutter_animate`: fade + slide up for every element, staggered.

### Sign Up Screen

- AppBar with back button, title "Create Account".
- Email `TextField` with email icon and validation (email format).
- Password `TextField` with lock icon, obscured, min 6 characters.
- Confirm Password `TextField`.
- "Create Account" button — full width, disabled until form is valid.
- Footer link: "Already have an account? **Sign In**" — navigates to Sign In.
- Show `CircularProgressIndicator` in the button while loading.
- Show error message below the form on failure (use `AppColors.error`).

### Sign In Screen

- AppBar with back button, title "Sign In".
- Email `TextField` with validation.
- Password `TextField` with obscured text.
- "Sign In" button — full width, disabled until both fields are non-empty.
- "Forgot Password?" text button below the sign in button.
- Footer link: "Don't have an account? **Sign Up**".
- Loading and error states same as Sign Up.

### Forgot Password Screen

- AppBar with back button, title "Reset Password".
- Email `TextField` with validation.
- "Send Reset Link" button — full width.
- On success: show a success message with a checkmark icon and a "Back to Sign In" link.
- On failure: show error message.

## Existing Widgets to Reuse

- None yet — these are the first screens being built.

## Acceptance Criteria

- [ ] All four screens render correctly on mobile and web.
- [ ] Form validation works: email format, password length ≥ 6, password confirmation matches.
- [ ] Buttons are disabled until forms are valid.
- [ ] Loading state shows spinner in the button.
- [ ] Error state shows error text below the form.
- [ ] Navigation between screens uses `context.go()` / `context.push()`.
- [ ] All colors come from `AppColors`, all text styles from `AppTextStyles`.
- [ ] Entry animations are smooth and staggered using `flutter_animate`.
- [ ] Screens look correct on both mobile (< 700px) and web (≥ 700px).
- [ ] Screens look correct in both light and dark themes.

## What NOT to Do

- Do NOT call Firebase Auth directly from any view. The buttons should call ViewModel methods only.
- Do NOT hardcode any colors or font sizes.
- Do NOT use `Navigator.push()`.
- Do NOT add any business logic (e.g., checking if profile is complete — that is handled by the router redirect).
