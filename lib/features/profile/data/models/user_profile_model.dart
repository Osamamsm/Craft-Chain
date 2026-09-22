import '../../domain/entities/user_profile_entity.dart';
import 'profile_skill_model.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.id,
    required super.fullName,
    required super.photoUrl,
    required super.gender,
    required super.city,
    required super.bio,
    required super.rating,
    required super.barterCount,
    required super.isProfileComplete,
    required super.isActive,
    required super.createdAt,
    required super.skillsCount,
    required super.teaches,
    required super.wantsToLearn,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      photoUrl: json['photo_url'] as String,
      gender: GenderX.fromString(json['gender'] as String),
      city: json['city'] as String,
      bio: json['bio'] as String,
      rating: (json['rating'] as num).toDouble(),
      barterCount: json['barter_count'] as int,
      isProfileComplete: json['is_profile_complete'] as bool,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      skillsCount: json['skills_count'] as int,
      teaches: ProfileSkillModel.listFromJson(
        json['teaches'] as List<dynamic>?,
      ),
      wantsToLearn: ProfileSkillModel.listFromJson(
        json['wants_to_learn'] as List<dynamic>?,
      ),
    );
  }
}
