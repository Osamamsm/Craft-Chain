import 'package:craft_chain/core/error/failures.dart';
import 'package:craft_chain/features/profile/domain/entities/complete_profile_params.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepo {
  Future<Either<Failure, void>> completeProfile({
    required CompleteProfileParams params,
  });
}
