import 'package:equatable/equatable.dart';
import 'profile_skill_entity.dart';

enum Gender { male, female }

extension GenderX on Gender {
  static Gender fromString(String value) {
    return Gender.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Unknown gender: $value'),
    );
  }
}

class UserProfileEntity extends Equatable {
  final String id;
  final String fullName;
  final String photoUrl;
  final Gender gender;
  final String city;
  final String bio;
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
    required this.photoUrl,
    required this.gender,
    required this.city,
    required this.bio,
    required this.rating,
    required this.barterCount,
    required this.isProfileComplete,
    required this.isActive,
    required this.createdAt,
    required this.skillsCount,
    required this.teaches,
    required this.wantsToLearn,
  });

  factory UserProfileEntity.placeHolder() => UserProfileEntity(
    id: '',
    fullName: 'fullName',
    rating: 0,
    barterCount: 0,
    isProfileComplete: true,
    isActive: true,
    createdAt: DateTime.now(),
    skillsCount: 0,
    teaches: [],
    wantsToLearn: [],
    photoUrl: '',
    gender: Gender.male,
    city: '',
    bio: '',
  );

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

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
