import 'dart:io';

import 'package:craft_chain/features/profile/domain/entities/skill_update_entity.dart';

class UpdateProfileParams {
  final String? fullName;
  final String? gender;
  final String? city;
  final String? bio;

  final File? photo;

  final List<SkillUpdateEntity>? teachingSkills;
  final List<SkillUpdateEntity>? learningSkills;

  const UpdateProfileParams({
    this.fullName,
    this.gender,
    this.city,
    this.bio,
    this.photo,
    this.teachingSkills,
    this.learningSkills,
  });

  bool get hasSkills => teachingSkills != null || learningSkills != null;

  bool get hasPhoto => photo != null;

  bool get isEmpty =>
    fullName == null &&
    gender == null &&
    city == null &&
    bio == null &&
    photo == null &&
    teachingSkills == null &&
    learningSkills == null;
}
