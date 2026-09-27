import 'package:craft_chain/features/profile/domain/entities/skill_update_entity.dart';

class SkillUpdateModel extends SkillUpdateEntity {
  const SkillUpdateModel({
    required super.skillId,
    super.proficiency,
    super.yearsOfExperience,
  });

  factory SkillUpdateModel.fromEntity(SkillUpdateEntity entity) {
    return SkillUpdateModel(
      skillId: entity.skillId,
      proficiency: entity.proficiency,
      yearsOfExperience: entity.yearsOfExperience,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skill_id': skillId,
      'proficiency': proficiency,
      'years_of_experience': yearsOfExperience,
    };
  }
}
