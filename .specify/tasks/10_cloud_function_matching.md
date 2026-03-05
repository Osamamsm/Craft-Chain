# Task 10 — Cloud Function: AI Matching

## What This Task Builds

The Firebase Cloud Functions that power the AI matching system. This includes computing OpenAI embeddings for user skills, calculating cosine similarity between users, writing match scores to Firestore, and sending push notifications.

## Files to Create

All files go in the `functions/` directory at the project root.

| File               | Location     |
| ------------------ | ------------ |
| `index.js`         | `functions/` |
| `matching.js`      | `functions/` |
| `notifications.js` | `functions/` |
| `package.json`     | `functions/` |
| `.env.example`     | `functions/` |

## What the Logic Does

### `matching.js` — Embedding & Scoring

#### `computeMatchEmbeddings` (Firestore Trigger)

- **Trigger**: `onDocumentWritten('users/{userId}')` — fires when a user document is created or updated.
- **Guard**: Only proceed if `canTeach` or `wantsToLearn` arrays changed. Skip otherwise.
- **Steps**:
  1. Read the user's `canTeach` and `wantsToLearn` arrays.
  2. Concatenate into a single string: `"teaches: Flutter, React, Python. wants to learn: Calligraphy, Arabic"`.
  3. Call OpenAI API: `POST https://api.openai.com/v1/embeddings` with model `text-embedding-3-small`.
  4. Store the returned embedding vector in the user document: `matchEmbedding` field.
  5. Trigger `computeMatchScores` for this user.

#### `computeMatchScores` (Called after embedding update)

- **Steps**:
  1. Read the updated user's embedding and gender.
  2. Query all other users with the SAME gender who have a `matchEmbedding` field.
  3. For each other user, compute cosine similarity between the two embeddings.
  4. Convert similarity to a 0–100 score: `Math.round(similarity * 100)`.
  5. Write to `matches/{userId}/suggestions/{otherUserId}` with `score` and `updatedAt: serverTimestamp()`.
  6. Also write the reverse: `matches/{otherUserId}/suggestions/{userId}` with the same score (cosine similarity is symmetric).

#### Cosine Similarity Function

```javascript
function cosineSimilarity(vecA, vecB) {
  let dotProduct = 0;
  let normA = 0;
  let normB = 0;
  for (let i = 0; i < vecA.length; i++) {
    dotProduct += vecA[i] * vecB[i];
    normA += vecA[i] * vecA[i];
    normB += vecB[i] * vecB[i];
  }
  if (normA === 0 || normB === 0) return 0;
  return dotProduct / (Math.sqrt(normA) * Math.sqrt(normB));
}
```

### `notifications.js` — Push Notifications

#### `onBarterCreated` (Firestore Trigger)

- **Trigger**: `onDocumentCreated('barters/{barterId}')`.
- Sends FCM push to `user2Id`: "{user1Name} wants to barter with you!".
- Payload: `{ type: 'barter_request', targetId: barterId }`.

#### `onBarterStatusChanged` (Firestore Trigger)

- **Trigger**: `onDocumentUpdated('barters/{barterId}')`.
- If status changed to `'active'` → send FCM to `user1Id`: "{user2Name} accepted your barter request!".
- If status changed to `'cancelled'` → send FCM to `user1Id`: "{user2Name} declined your barter request.".
- Payload: `{ type: 'barter_accepted' | 'barter_declined', targetId: barterId }`.

#### `onNewMessage` (Firestore Trigger)

- **Trigger**: `onDocumentCreated('barters/{barterId}/messages/{messageId}')`.
- Sends FCM to the other user (not the sender): "{senderName}: {text preview}".
- Payload: `{ type: 'new_message', targetId: barterId }`.

#### `sessionReminder` (Scheduled Function)

- **Trigger**: Runs every 15 minutes via Cloud Scheduler.
- Queries `barters` where `status == 'active'` and `scheduledAt` is between now and now + 1 hour.
- Sends FCM reminder to both users: "Your session with {otherName} starts in 1 hour".
- Payload: `{ type: 'session_reminder', targetId: barterId }`.

### `index.js` — Entry Point

- Exports all Cloud Functions from `matching.js` and `notifications.js`.

### `package.json`

- Dependencies: `firebase-admin`, `firebase-functions`, `openai` (or use `node-fetch` for direct API calls).

### `.env.example`

- `OPENAI_API_KEY=your-api-key-here`.

## Acceptance Criteria

- [ ] `computeMatchEmbeddings` fires on user document write.
- [ ] Only runs when `canTeach` or `wantsToLearn` actually changed.
- [ ] OpenAI embedding API is called with the correct model and input.
- [ ] Embedding is stored in the user document.
- [ ] `computeMatchScores` computes cosine similarity for all same-gender users.
- [ ] Scores are written to both directions: `matches/A/suggestions/B` and `matches/B/suggestions/A`.
- [ ] Gender filter is applied when querying users for scoring.
- [ ] All notification triggers fire correctly and send FCM with proper payload.
- [ ] Session reminder runs on schedule and sends timely notifications.
- [ ] All Firestore writes use `admin.firestore.FieldValue.serverTimestamp()`.

## What NOT to Do

- Do NOT expose the OpenAI API key in client code.
- Do NOT compute embeddings or scores in the Flutter app.
- Do NOT send notifications from the Flutter client.
- Do NOT match users of different genders.
- Do NOT use `new Date()` for Firestore timestamps — use `admin.firestore.FieldValue.serverTimestamp()`.
- Do NOT skip the reverse write for match scores (both users should see each other's score).
- Do NOT write raw English strings in Cloud Function notification payloads when they surface in the Dart app — the Flutter app must look up its own `.tr()` keys.
- Before adding any color to the Flutter layer, open `app_colors.dart` and `app_theme.dart` first to check if an equivalent already exists.
