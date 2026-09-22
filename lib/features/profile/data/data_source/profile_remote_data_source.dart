import 'package:craft_chain/features/profile/data/models/complete_profile_params_model.dart';
import 'package:craft_chain/features/profile/data/models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<void> completeProfile({required CompleteProfileParamsModel params});

  Future<UserProfileModel> getUserProfile({String? userId});
}
