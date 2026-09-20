import 'dart:io';

import 'package:craft_chain/features/profile/domain/entities/complete_profile_params.dart';

class CompleteProfileParamsModel {
  final String fullName;
  final String gender;
  final String city;
  final String bio;
  final List<CompleteProfileSkillParams> teachingSkills;
  final List<CompleteProfileSkillParams> learningSkills;
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
      teachingSkills: entity.teachingSkills,
      learningSkills: entity.learningSkills,
      photo: entity.photo,
    );
  }
}
