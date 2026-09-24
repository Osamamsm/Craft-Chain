import 'package:craft_chain/core/error/failures.dart';
import 'package:craft_chain/features/profile/domain/entities/complete_profile_params.dart';
import 'package:craft_chain/features/profile/domain/entities/update_profile_params.dart';
import 'package:craft_chain/features/profile/domain/entities/user_profile_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepo {
  Future<Either<Failure, void>> completeProfile({
    required CompleteProfileParams params,
  });

  Future<Either<Failure, UserProfileEntity>> getUserProfile({String? userId});


  Future<Either<Failure, void>> updateProfile({
    required UpdateProfileParams params,
  });
}
