import 'dart:convert';

import 'package:craft_chain/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:craft_chain/features/profile/data/models/complete_profile_params_model.dart';
import 'package:craft_chain/features/profile/domain/entities/user_profile_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient _supabaseClient;

  ProfileRemoteDataSourceImpl(this._supabaseClient);
  @override
  Future<void> completeProfile({
    required CompleteProfileParamsModel params,
  }) async {
    print(params.toString());
    final photoBytes = await params.photo.readAsBytes();

    await _supabaseClient.functions.invoke(
      "complete-profile",
      body: {
        "full_name": params.fullName,
        "gender": params.gender,
        "city": params.city,
        "bio": params.bio,
        "teaching_skills": _skillsToJson(params.teachingSkills),
        "learning_skills": _skillsToJson(params.learningSkills),
        "photo": base64Encode(photoBytes),
      },
    );
  }

  @override
  Future<UserProfileEntity> getUserProfile({String? userId}) {
    // TODO: implement getUserProfile
    throw UnimplementedError();
  }
}

List<Map<String, dynamic>> _skillsToJson(
  List<CompleteProfileSkillParamsModel> skills,
) => skills
    .map(
      (e) => {
        "skill_id": e.skillId,
        "proficiency": e.proficiency,
        "years_of_experience": e.yearsOfExperience,
      },
    )
    .toList();
