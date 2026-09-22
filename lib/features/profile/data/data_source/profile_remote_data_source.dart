import 'package:craft_chain/features/profile/data/models/complete_profile_params_model.dart';
import 'package:craft_chain/features/profile/domain/entities/user_profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<void> completeProfile({required CompleteProfileParamsModel params});

  Future<UserProfileEntity> getUserProfile({String? userId});
}
