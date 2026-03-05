# CraftChain — Complete Specification

## 1. What the App Is

CraftChain is a skill barter marketplace targeting Arab young professionals and students across the Middle East. Users exchange knowledge instead of money: you teach someone a skill you know, and they teach you a skill you want to learn. Everything is professional and educational. No money changes hands — only knowledge.

The app runs on iOS, Android, and web from a single Flutter codebase.

---

## 2. User Model

Every user has:

| Field             | Description                                     |
| ----------------- | ----------------------------------------------- |
| Name              | Display name                                    |
| Profile photo     | Uploaded during onboarding                      |
| City              | Free-text city name                             |
| Gender            | Male or female — used for same-gender filtering |
| canTeach          | List of skills the user can teach others        |
| wantsToLearn      | List of skills the user wants to learn          |
| Bio               | Short free-text description                     |
| Rating            | Average of all reviews received (1–5 scale)     |
| Barter count      | Number of completed barters                     |
| isProfileComplete | Boolean — gates access to main app              |
| isActive          | Boolean — active/inactive status                |

---

## 3. User Journeys

### 3.1 Sign Up & Onboarding

1. User opens app → sees the **Welcome screen** with app branding, tagline, and two buttons: "Sign Up" and "Sign In".
2. User taps "Sign Up" → **Sign Up screen** with email and password fields, a "Create Account" button, and a link to "Already have an account? Sign In".
3. User enters valid email and password → account is created via Firebase Auth.
4. User is redirected to the **Profile Setup Wizard** — a multi-step flow:
   - **Step 1 — Name & Gender**: Text field for name, toggle/selector for gender (male/female).
   - **Step 2 — Photo & City**: Upload profile photo, enter city.
   - **Step 3 — Skills you teach**: Multi-select chip selector for canTeach skills.
   - **Step 4 — Skills you want to learn**: Multi-select chip selector for wantsToLearn skills.
   - **Step 5 — Bio**: Text area for a short bio.
5. User taps "Complete Profile" → `isProfileComplete` is set to `true` in Firestore.
6. User is taken to the **Home / Match Feed** screen.

**Business rules:**

- All wizard fields are required. User cannot skip any step.
- User cannot access the main app screens until `isProfileComplete == true`.
- If the user closes the app mid-wizard and reopens, they return to the wizard.

### 3.2 Sign In

1. User opens app → taps "Sign In" on the Welcome screen.
2. **Sign In screen** with email and password fields, a "Sign In" button, and a "Forgot Password?" link.
3. On success → if `isProfileComplete == true`, go to Home. If `false`, go to Profile Setup Wizard.
4. On failure → show inline error message.

### 3.3 Password Reset

1. User taps "Forgot Password?" on the Sign In screen.
2. **Forgot Password screen** with an email field and "Send Reset Link" button.
3. Firebase sends a password reset email.
4. User sees a confirmation message and a link to go back to Sign In.

### 3.4 Match Feed (Home Screen)

1. User lands on the Home screen after onboarding or sign in.
2. The screen shows a **ranked list of matched users** — people with complementary skills.
3. Matching is precomputed by a Firebase Cloud Function using OpenAI embeddings. The app reads precomputed scores from Firestore; it never computes match scores itself.
4. Each match card shows:
   - User avatar
   - Name
   - City
   - Skills they teach (green chips)
   - Skills they want to learn (blue chips)
   - Match score percentage (e.g., "87% match")
   - Star rating
   - Completed barters count
5. **Filter chips** at the top: All, Tech, Design, Languages, Crafts, Business. Selecting a filter narrows results to users whose skills fall in that category.
6. **Pagination**: Maximum 10 results initially. A "Load More" button or infinite scroll loads the next page.
7. Tapping a card opens the **User Profile Screen**.

**Business rules:**

- Users must NEVER see matches of a different gender. This filter is applied at the Firestore query level, not just in the UI.
- Maximum 10 results per page.
- Results are ordered by match score descending.

### 3.5 Explore / Search

1. User navigates to the **Explore** tab.
2. A search bar at the top allows searching by skill name or username.
3. Results appear in the same card format as the match feed (avatar, name, city, skills, rating).
4. Results are ordered by rating (highest first), not by AI match score.
5. No AI scoring is used in the explore screen.

**Business rules:**

- Same-gender filter still applies.
- Search is case-insensitive.

### 3.6 User Profile Screen

1. User taps a match card or a search result → **User Profile Screen**.
2. The screen shows:
   - Large avatar
   - Name
   - City
   - Star rating (with count)
   - Completed barters count
   - Bio
   - Skills they teach (green chips)
   - Skills they want to learn (blue chips)
   - **Reviews section**: All reviews received. Each review shows: reviewer name, skill exchanged, star rating, and comment.
3. A **"Send Barter Request"** button is fixed at the bottom.
4. If viewing their own profile, the button changes to **"Edit Profile"**.

### 3.7 Edit Own Profile

1. User taps "Edit Profile" on their own profile.
2. All profile fields are editable: name, photo, city, canTeach, wantsToLearn, bio.
3. Gender is NOT editable after initial setup.
4. User saves changes → Firestore document is updated.

### 3.8 Barter Request Flow

1. User taps "Send Barter Request" on another user's profile.
2. A **bottom sheet** appears with two pickers:
   - **"What will you teach them?"** — pick from your own canTeach skills.
   - **"What do you want to learn from them?"** — pick from their canTeach skills.
3. User taps "Send Request" → a barter document is created in Firestore with `status: 'pending'`.
4. The other user receives a **push notification**: "{Name} wants to barter with you!"
5. The recipient opens their **Barter Requests** section and sees the pending request with:
   - Requester's name and avatar
   - What the requester will teach
   - What the requester wants to learn
   - Accept / Decline buttons
6. If **accepted**:
   - Barter status changes to `'active'`.
   - A **Barter Room** is created.
   - Both users are notified and can navigate to the Barter Room.
   - The requester receives a push notification: "{Name} accepted your barter request!"
7. If **declined**:
   - Barter status changes to `'cancelled'`.
   - The requester receives a push notification: "{Name} declined your barter request."

**Business rules:**

- A user cannot send a barter request to themselves.
- A user cannot send a duplicate barter request to the same person for the same skill pair while one is already pending or active.

### 3.9 Barter Room

1. When a barter is accepted, both users can access the **Barter Room**.
2. The room shows:
   - **Header**: Both users' avatars overlapping, with the exchange info: "You teach Flutter ↔ They teach Calligraphy".
   - **Session banner**: Shows the scheduled session time and platform (e.g., "Zoom — March 15, 3:00 PM"). Initially empty until users agree on a time.
   - **Chat area**: Real-time messaging powered by Firestore streams.
   - **"Mark as Completed"** button: Either user can tap this once the session has happened.
3. Users schedule sessions themselves outside the app. The app only stores the agreed time and platform.
4. Once either user marks the barter as completed:
   - Barter status changes to `'completed'`.
   - Both users are prompted to leave a review.

**Business rules:**

- Messages use `serverTimestamp()`, never the device clock.
- Both users see the same chat in real time.
- A completed barter cannot be reopened.

### 3.10 Rating & Review

1. After a barter is marked complete, each user sees a **Review prompt**.
2. The review form has:
   - Star rating (1–5)
   - Text comment
3. On submit:
   - A review document is created in Firestore.
   - The reviewee's `rating` field is recalculated as the average of all their reviews.
   - The reviewee's profile updates in real time.
4. Reviews are public and shown on the reviewee's profile.

**Business rules:**

- Each user can only leave one review per barter.
- Rating must be between 1 and 5 inclusive.
- Comment is required (non-empty).

### 3.11 Notifications

| Event                         | Notification text                           |
| ----------------------------- | ------------------------------------------- |
| Barter request received       | "{Name} wants to barter with you!"          |
| Barter request accepted       | "{Name} accepted your barter request!"      |
| Barter request declined       | "{Name} declined your barter request."      |
| New message in Barter Room    | "{Name}: {message preview}"                 |
| Session reminder (1hr before) | "Your session with {Name} starts in 1 hour" |

**Business rules:**

- Push notifications are sent via Firebase Cloud Messaging (FCM).
- Session reminders are triggered by a Cloud Function (scheduled or triggered).
- Users should be able to tap a notification and navigate to the relevant screen.

---

## 4. Screens Summary

| Screen               | Purpose                                          |
| -------------------- | ------------------------------------------------ |
| Welcome              | App branding, Sign Up / Sign In buttons          |
| Sign Up              | Email + password registration                    |
| Sign In              | Email + password login                           |
| Forgot Password      | Send password reset email                        |
| Profile Setup Wizard | 5-step onboarding flow                           |
| Home / Match Feed    | AI-ranked complementary skill matches            |
| Explore / Search     | Search users by skill or username                |
| User Profile         | Full profile view with reviews                   |
| Edit Profile         | Edit own profile fields                          |
| Barter Request Sheet | Bottom sheet to pick skills for a barter         |
| Barter Requests List | View incoming/outgoing pending requests          |
| Barter Room          | Chat + session info for an active barter         |
| Review Form          | Rate and comment after barter completion         |
| Notifications        | List of all notifications (optional in-app view) |

---

## 5. Business Rules Summary

1. **Gender isolation**: Users must NEVER see matches of a different gender. Enforced at Firestore query level.
2. **Profile gate**: User cannot access main app until `isProfileComplete == true`.
3. **No self-barter**: User cannot send a barter request to themselves.
4. **No duplicate barters**: Cannot send a duplicate request for the same skill pair while one is pending/active.
5. **Server timestamps**: All timestamps use `serverTimestamp()`. Never the device clock.
6. **No in-app calls**: Sessions happen outside the app (Zoom, Google Meet, etc.). The app only stores the agreed time and platform.
7. **No payments**: This is a free barter platform. No money changes hands.
8. **No skill verification**: The app does not verify skills or credentials.
9. **One review per barter per user**: Each user can only review the other once per completed barter.
10. **Completed barters are final**: A completed barter cannot be reopened.

---

## 6. Success Criteria by Screen

### Welcome Screen

- App logo and tagline are visible.
- "Sign Up" and "Sign In" buttons are prominent and functional.
- Clean, professional design sets the tone for the app.

### Sign Up Screen

- Email and password fields validate input (email format, password minimum length).
- Firebase Auth account is created on success.
- Error messages are displayed inline on failure.
- After sign up, user is redirected to Profile Setup Wizard.

### Sign In Screen

- Email and password fields work correctly.
- On success, navigates to Home (if profile complete) or Wizard (if not).
- "Forgot Password?" link navigates correctly.
- Error messages are clear and helpful.

### Forgot Password Screen

- Email field accepts input.
- On submit, Firebase sends reset email.
- Confirmation message is shown.

### Profile Setup Wizard

- All 5 steps are sequential with progress indicator.
- Back navigation between steps works.
- All fields are required — "Next" is disabled until step is valid.
- On final step, `isProfileComplete` is set to `true`.
- User is taken to Home screen.

### Home / Match Feed

- Shows ranked list of complementary users.
- Only same-gender users appear.
- Each card shows all required info (avatar, name, city, skills, score, rating, barter count).
- Filter chips work correctly.
- Pagination loads more results.
- Tapping a card goes to User Profile.

### Explore / Search

- Search bar is prominent.
- Results update as user types (debounced).
- Results show same card format.
- Ordered by rating.
- Same-gender filter applies.

### User Profile Screen

- All profile info is displayed correctly.
- Reviews section loads and shows all reviews.
- "Send Barter Request" button is visible (for other users).
- "Edit Profile" button is visible (for own profile).

### Barter Request Bottom Sheet

- Two skill pickers work correctly.
- Cannot submit without selecting both skills.
- On submit, barter document is created.
- Other user gets push notification.

### Barter Room

- Header shows overlapping avatars and exchange info.
- Session banner shows scheduled time (or empty state).
- Messages load in real time.
- Sending a message works instantly.
- "Mark as Completed" button works.

### Review Form

- Star rating selector (1–5) works.
- Comment text field is required.
- On submit, review is saved and rating is recalculated.

### Notifications

- Push notifications arrive for all listed events.
- Tapping a notification navigates to the correct screen.
- Session reminders fire 1 hour before scheduled time.

---

## 7. Constraints Recap

- **Single codebase**: Flutter for iOS, Android, and web.
- **Same-gender only**: Enforced at query level, never UI-only.
- **No in-app calls**: Sessions use external platforms.
- **No payments**: Free skill exchange only.
- **No skill verification**: Trust-based system.
- **Server timestamps always**: `serverTimestamp()` for all time fields.
- **MVVM architecture**: Models, ViewModels, Views — no exceptions.
- **Cubit state management**: All state through Cubit classes with `BlocProvider`.
- **go_router navigation**: `context.go()` only, never `Navigator.push()`.
- **No hardcoded styles**: All colors and text styles from theme constants.
