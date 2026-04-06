/// Barter status values.
enum BarterStatus { pending, active, completed, cancelled }

/// Lightweight barter model used for fake-data simulation.
/// (Real implementation will use freezed + Firestore once repo layer is wired.)
class BarterModel {
  const BarterModel({
    required this.barterId,
    required this.user1Id,
    required this.user2Id,
    required this.user1Name,
    required this.user2Name,
    required this.user1Initials,
    required this.user2Initials,
    required this.user1ColorSeed,
    required this.user2ColorSeed,
    required this.user1Teaches,
    required this.user2Teaches,
    required this.status,
    this.lastMessageText,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.hiddenBy = const [],
  });

  final String barterId;
  final String user1Id;
  final String user2Id;

  // Denormalised display data (avoids extra user fetches in fake-data mode).
  final String user1Name;
  final String user2Name;
  final String user1Initials;
  final String user2Initials;
  final int user1ColorSeed;
  final int user2ColorSeed;

  /// Skill user1 teaches (= what user2 learns).
  final String user1Teaches;

  /// Skill user2 teaches (= what user1 learns).
  final String user2Teaches;

  final BarterStatus status;
  final String? lastMessageText;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final List<String> hiddenBy;

  BarterModel copyWith({
    BarterStatus? status,
    String? lastMessageText,
    DateTime? lastMessageTime,
    int? unreadCount,
    List<String>? hiddenBy,
  }) {
    return BarterModel(
      barterId: barterId,
      user1Id: user1Id,
      user2Id: user2Id,
      user1Name: user1Name,
      user2Name: user2Name,
      user1Initials: user1Initials,
      user2Initials: user2Initials,
      user1ColorSeed: user1ColorSeed,
      user2ColorSeed: user2ColorSeed,
      user1Teaches: user1Teaches,
      user2Teaches: user2Teaches,
      status: status ?? this.status,
      lastMessageText: lastMessageText ?? this.lastMessageText,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      hiddenBy: hiddenBy ?? this.hiddenBy,
    );
  }
}
