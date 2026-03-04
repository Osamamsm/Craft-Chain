# Task 02a — Profile Setup Wizard UI

## What This Task Builds

The multi-step profile setup wizard that new users must complete before accessing the main app. This is a 5-step flow with progress indication and validation on each step.

> **Figma**: Before starting, the user will provide the Figma URL for these screens. Match the design exactly.

## Files to Create

| File                        | Location                      |
| --------------------------- | ----------------------------- |
| `profile_setup_wizard.dart` | `lib/features/profile/views/` |

## UI Details

### Wizard Structure

- A single screen with a `PageView` or `Stepper` for 5 steps.
- A linear progress indicator at the top showing current step (1 of 5, 2 of 5, etc.).
- "Back" button on steps 2–5 to go to the previous step.
- "Next" button on steps 1–4, "Complete Profile" on step 5.
- "Next" is disabled until the current step's fields are valid.

### Step 1 — Name & Gender

- `TextField` for full name (required, non-empty).
- Gender selector: two selectable chips or a segmented button — "Male" / "Female".
- Both are required. "Next" is disabled until both are filled.

### Step 2 — Photo & City

- Profile photo picker: a circular placeholder with a camera icon. Tapping opens `image_picker`.
- On selection, show the picked image in the circle.
- `TextField` for city (required, non-empty).
- Photo is required.

### Step 3 — Skills You Can Teach

- A grid or wrap of skill chips (from a predefined list of skills).
- User taps to select/deselect. Selected chips use `AppColors.teachChip` (green).
- At least 1 skill must be selected.
- Use `SkillChip` widget from `core/widgets/`.

### Step 4 — Skills You Want to Learn

- Same layout as Step 3 but chips use `AppColors.learnChip` (blue).
- At least 1 skill must be selected.
- Use `SkillChip` widget.

### Step 5 — Bio

- `TextField` (multiline, max 4 lines) for bio text.
- Required, non-empty.
- Character counter below.

### Animations

- Page transitions use slide animation via `flutter_animate`.
- Each step's content fades in.

## Existing Widgets to Reuse

- `SkillChip` from `core/widgets/skill_chip.dart` — for skill selection in steps 3 and 4.
- `UserAvatar` from `core/widgets/user_avatar.dart` — for the photo placeholder.

## Acceptance Criteria

- [ ] All 5 steps render correctly.
- [ ] Progress indicator updates on each step.
- [ ] "Next" is disabled until step is valid.
- [ ] Back navigation between steps works.
- [ ] Photo picker opens and displays selected image.
- [ ] Skill chips are selectable and visually distinct (green for teach, blue for learn).
- [ ] "Complete Profile" button calls the ViewModel method (does not call Firestore directly).
- [ ] All colors from `AppColors`, all text styles from `AppTextStyles`.
- [ ] Looks good on mobile and web (use `ResponsiveLayout` to constrain width on web).
- [ ] Looks correct in both light and dark themes.

## What NOT to Do

- Do NOT call Firestore from this view.
- Do NOT upload the photo directly — call the ViewModel method.
- Do NOT hardcode colors or font sizes.
- Do NOT skip validation — every step must be gated.
