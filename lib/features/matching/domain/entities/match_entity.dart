import 'package:equatable/equatable.dart';
import 'skill_entity.dart';

class MatchEntity extends Equatable {
  final String userId;
  final String fullName;
  final String? photoUrl;
  final String? city;
  final double rating;
  final int barterCount;
  final int matchPercent;
  final List<SkillEntity> teaches;
  final List<SkillEntity> wantsToLearn;

  const MatchEntity({
    required this.userId,
    required this.fullName,
    this.photoUrl,
    this.city,
    required this.rating,
    required this.barterCount,
    required this.matchPercent,
    required this.teaches,
    required this.wantsToLearn,
  });

  factory MatchEntity.placeholder() => MatchEntity(
    userId: 'skeleton',
    fullName: 'Loading Name Here',
    city: 'Some City',
    teaches: List.generate(
      3,
      (index) => SkillEntity(id: 1, name: 'Skill ${index + 1}'),
    ),
    wantsToLearn: List.generate(
      3,
      (index) => SkillEntity(id: 2, name: 'Skill ${index + 1}'),
    ),
    matchPercent: 82,
    rating: 4.5,
    barterCount: 8,
  );

  /// "TOP" badge on the card
  bool get isTop => rating >= 4.5;

  /// Letter shown in the avatar when there is no photo
  String get initial =>
      fullName.trim().isEmpty ? '?' : fullName.trim()[0].toUpperCase();

  @override
  List<Object?> get props => [
    userId,
    fullName,
    photoUrl,
    city,
    rating,
    barterCount,
    matchPercent,
    teaches,
    wantsToLearn,
  ];
}
