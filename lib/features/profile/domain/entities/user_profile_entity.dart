import 'package:equatable/equatable.dart';
import 'profile_skill_entity.dart';

enum Gender { male, female }

extension GenderX on Gender {
  static Gender? fromString(String? value) {
    if (value == null) return null;
    return Gender.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Unknown gender: $value'),
    );
  }
}

class UserProfileEntity extends Equatable {
  final String id;
  final String fullName;
  final String? photoUrl;
  final Gender? gender;
  final String? city;
  final String? bio;
  final double rating;
  final int barterCount;
  final bool isProfileComplete;
  final bool isActive;
  final DateTime createdAt;
  final int skillsCount;
  final List<ProfileSkillEntity> teaches;
  final List<ProfileSkillEntity> wantsToLearn;

  const UserProfileEntity({
    required this.id,
    required this.fullName,
    this.photoUrl,
    this.gender,
    this.city,
    this.bio,
    required this.rating,
    required this.barterCount,
    required this.isProfileComplete,
    required this.isActive,
    required this.createdAt,
    required this.skillsCount,
    required this.teaches,
    required this.wantsToLearn,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    photoUrl,
    gender,
    city,
    bio,
    rating,
    barterCount,
    isProfileComplete,
    isActive,
    createdAt,
    skillsCount,
    teaches,
    wantsToLearn,
  ];
}
