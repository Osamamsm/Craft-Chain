/// Data model for a single entry in the match feed.
///
/// The [matchScore] is a pre-computed value (0–100) written by the backend
/// Cloud Function. The app NEVER computes this locally — it only reads it.
///
/// NOTE: This is a plain Dart class for the UI-only phase. Replace with a
/// @freezed model once Firestore is connected.
class MatchSuggestion {
  const MatchSuggestion({
    required this.userId,
    required this.name,
    required this.city,
    this.avatarUrl,
    required this.canTeach,
    required this.wantsToLearn,
    required this.matchScore,
    required this.rating,
    required this.barterCount,
  });

  final String userId;
  final String name;
  final String city;
  final String? avatarUrl;
  final List<String> canTeach;
  final List<String> wantsToLearn;
  final double matchScore;
  final double rating;
  final int barterCount;

  /// Up to 2 uppercase initials from the display name.
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  /// A placeholder instance used by Skeletonizer to render loading skeletons.
  static MatchSuggestion get placeholder => const MatchSuggestion(
    userId: 'placeholder',
    name: 'Loading Name Here',
    city: 'Some City',
    canTeach: ['Skill One', 'Skill Two', 'Skill Three'],
    wantsToLearn: ['Learn Skill A', 'Learn Skill B'],
    matchScore: 82,
    rating: 4.5,
    barterCount: 8,
  );
}
