import 'dart:convert';

import 'package:craft_chain/features/profile/data/models/skill_update_model.dart';
import 'package:craft_chain/features/profile/domain/entities/update_profile_params.dart';

class UpdateProfileParamsModel {
  final String? fullName;
  final String? gender;
  final String? city;
  final String? bio;
  final String? photoBase64;

  final List<SkillUpdateModel>? teachingSkills;
  final List<SkillUpdateModel>? learningSkills;

  const UpdateProfileParamsModel({
    this.fullName,
    this.gender,
    this.city,
    this.bio,
    this.photoBase64,
    this.teachingSkills,
    this.learningSkills,
  });

  static Future<UpdateProfileParamsModel> fromEntity(
    UpdateProfileParams entity,
  ) async {
    String? photoBase64;

    if (entity.photo != null) {
      final bytes = await entity.photo!.readAsBytes();
      photoBase64 = base64Encode(bytes);
    }

    return UpdateProfileParamsModel(
      fullName: entity.fullName,
      gender: entity.gender,
      city: entity.city,
      bio: entity.bio,
      photoBase64: photoBase64,
      teachingSkills: entity.teachingSkills
          ?.map(SkillUpdateModel.fromEntity)
          .toList(),
      learningSkills: entity.learningSkills
          ?.map(SkillUpdateModel.fromEntity)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (fullName != null) {
      json['full_name'] = fullName;
    }

    if (gender != null) {
      json['gender'] = gender;
    }

    if (city != null) {
      json['city'] = city;
    }

    if (bio != null) {
      json['bio'] = bio;
    }

    if (photoBase64 != null) {
      json['photo'] = photoBase64;
    }

    if (teachingSkills != null) {
      json['teaching_skills'] = teachingSkills!
          .map((skill) => skill.toJson())
          .toList();
    }

    if (learningSkills != null) {
      json['learning_skills'] = learningSkills!
          .map((skill) => skill.toJson())
          .toList();
    }

    return json;
  }
}
