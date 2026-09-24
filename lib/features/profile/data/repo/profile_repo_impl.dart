import 'package:craft_chain/core/error/exception_mapper.dart';
import 'package:craft_chain/core/error/failures.dart';
import 'package:craft_chain/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:craft_chain/features/profile/data/models/complete_profile_params_model.dart';
import 'package:craft_chain/features/profile/data/models/update_profile_params_model.dart';
import 'package:craft_chain/features/profile/domain/entities/complete_profile_params.dart';
import 'package:craft_chain/features/profile/domain/entities/update_profile_params.dart';
import 'package:craft_chain/features/profile/domain/entities/user_profile_entity.dart';
import 'package:craft_chain/features/profile/domain/repo/profile_repo.dart';
import 'package:dartz/dartz.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, void>> completeProfile({
    required CompleteProfileParams params,
  }) async {
    try {
      return Right(
        await _remoteDataSource.completeProfile(
          params: CompleteProfileParamsModel.fromEntity(params),
        ),
      );
    } catch (e) {
      return Left(ExceptionMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile({
    String? userId,
  }) async {
    try {
      final userProfileModel = await _remoteDataSource.getUserProfile(
        userId: userId,
      );
      return Right(userProfileModel);
    } catch (e) {
      return Left(ExceptionMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile({
    required UpdateProfileParams params,
  }) async {
    try {
      await _remoteDataSource.updateProfile(
        params: await UpdateProfileParamsModel.fromEntity(params),
      );
      return Right(null);
    } catch (e) {
      return Left(ExceptionMapper.mapExceptionToFailure(e));
    }
  }
}
