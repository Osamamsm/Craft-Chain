import '../../domain/entities/profile_skill_entity.dart';

class ProfileSkillModel extends ProfileSkillEntity {
  const ProfileSkillModel({
    required super.skillId,
    required super.name,
    required super.categoryId,
    super.proficiency,
    super.yearsOfExperience,
  });

  factory ProfileSkillModel.fromJson(Map<String, dynamic> json) {
    return ProfileSkillModel(
      skillId: json['skill_id'] as int,
      name: json['name'] as String,
      categoryId: json['category_id'] as int,
      proficiency: ProficiencyLevelX.fromString(json['proficiency'] as String?),
      yearsOfExperience: (json['years_of_experience'] as num?)?.toDouble(),
    );
  }

  static List<ProfileSkillModel> listFromJson(List<dynamic>? jsonList) {
    if (jsonList == null) return const [];
    return jsonList
        .map((e) => ProfileSkillModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
