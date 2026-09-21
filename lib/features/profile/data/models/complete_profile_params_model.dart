import 'dart:io';

import 'package:craft_chain/features/profile/domain/entities/complete_profile_params.dart';

class CompleteProfileParamsModel {
  final String fullName;
  final String gender;
  final String city;
  final String bio;
  final List<CompleteProfileSkillParamsModel> teachingSkills;
  final List<CompleteProfileSkillParamsModel> learningSkills;
  final File photo;

  CompleteProfileParamsModel({
    required this.fullName,
    required this.gender,
    required this.city,
    required this.bio,
    required this.teachingSkills,
    required this.learningSkills,
    required this.photo,
  });

  factory CompleteProfileParamsModel.fromEntity(CompleteProfileParams entity) {
    return CompleteProfileParamsModel(
      fullName: entity.fullName,
      gender: entity.gender,
      city: entity.city,
      bio: entity.bio,
      teachingSkills: entity.teachingSkills
          .map((e) => CompleteProfileSkillParamsModel.fromEntity(e))
          .toList(),
      learningSkills: entity.learningSkills
          .map((e) => CompleteProfileSkillParamsModel.fromEntity(e))
          .toList(),
      photo: entity.photo,
    );
  }
}

class CompleteProfileSkillParamsModel {
  final String skillId;
  final String proficiency;
  final double? yearsOfExperience;

  CompleteProfileSkillParamsModel({
    required this.skillId,
    required this.proficiency,
    this.yearsOfExperience,
  });

  factory CompleteProfileSkillParamsModel.fromEntity(
    CompleteProfileSkillParams entity,
  ) {
    return CompleteProfileSkillParamsModel(
      skillId: entity.skillId,
      proficiency: entity.proficiency,
      yearsOfExperience: entity.yearsOfExperience,
    );
  }
}
