import 'dart:convert';

import 'package:craft_chain/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:craft_chain/features/profile/data/models/complete_profile_params_model.dart';
import 'package:craft_chain/features/profile/data/models/update_profile_params_model.dart';
import 'package:craft_chain/features/profile/data/models/user_profile_model.dart';
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
  Future<UserProfileModel> getUserProfile({String? userId}) async {
    final response = await _supabaseClient.rpc(
      "get_user_profile",
      params: {"p_user_id": userId},
    );

    return UserProfileModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<void> updateProfile({required UpdateProfileParamsModel params}) async {
    await _supabaseClient.functions.invoke(
      'update-profile',
      body: params.toJson(),
    );
  }

  @override
  Future<bool> isProfileComplete() async {
    final response = await _supabaseClient
        .from('users')
        .select('is_profile_complete')
        .eq('id', _supabaseClient.auth.currentUser!.id)
        .single();

    return response as bool;
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
