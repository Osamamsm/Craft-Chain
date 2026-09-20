import 'package:craft_chain/features/profile/domain/entities/complete_profile_params.dart';

class CompleteProfileParamsModel extends CompleteProfileParams {
  CompleteProfileParamsModel({
    required super.fullName,
    required super.gender,
    required super.city,
    required super.bio,
    required super.teachingSkills,
    required super.learningSkills,
    required super.photo,
  });
}
