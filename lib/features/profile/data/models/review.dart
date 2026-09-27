/// Data model for a single user review.
///
/// Plain Dart class for the UI-only phase.
/// NOTE: Replace with a @freezed model once Firestore is connected (task-02b).
class Review {
  const Review({
    required this.reviewId,
    required this.barterId,
    required this.reviewerId,
    required this.revieweeId,
    required this.reviewerName,
    required this.skillExchanged,
    required this.rating,
    required this.comment,
    this.reviewerPhotoUrl,
    this.createdAt,
  });

  final String reviewId;
  final String barterId;
  final String reviewerId;
  final String revieweeId;
  final String reviewerName;
  final String? reviewerPhotoUrl;
  final String skillExchanged;
  final double rating;
  final String comment;
  final DateTime? createdAt;

  // ── Derived helpers ──────────────────────────────────────────────────────────

  /// Up to 2 uppercase initials from the reviewer's name.
  String get reviewerInitials {
    final parts = reviewerName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return reviewerName.isNotEmpty ? reviewerName[0].toUpperCase() : '?';
  }

  static final Review placeholder = Review(
    reviewId: 'placeholder',
    barterId: 'barter_placeholder',
    reviewerId: 'reviewer_placeholder',
    revieweeId: 'reviewee_placeholder',
    reviewerName: 'Loading Reviewer Name',
    skillExchanged: 'Some Skill',
    rating: 4.5,
    comment:
        'This is a placeholder review comment used for skeleton loading animations.',
    createdAt: DateTime(2025, 1, 15),
  );

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    reviewId: json['reviewId'] as String,
    barterId: json['barterId'] as String,
    reviewerId: json['reviewerId'] as String,
    revieweeId: json['revieweeId'] as String,
    reviewerName: json['reviewerName'] as String? ?? 'Anonymous',
    reviewerPhotoUrl: json['reviewerPhotoUrl'] as String?,
    skillExchanged: json['skillExchanged'] as String,
    rating: (json['rating'] as num).toDouble(),
    comment: json['comment'] as String,
    // TODO(task-02b): parse as Firestore Timestamp
    createdAt: null,
  );

  Map<String, dynamic> toJson() => {
    'reviewId': reviewId,
    'barterId': barterId,
    'reviewerId': reviewerId,
    'revieweeId': revieweeId,
    'reviewerName': reviewerName,
    if (reviewerPhotoUrl != null) 'reviewerPhotoUrl': reviewerPhotoUrl,
    'skillExchanged': skillExchanged,
    'rating': rating,
    'comment': comment,
    // TODO(task-02b): use FieldValue.serverTimestamp()
  };
}
