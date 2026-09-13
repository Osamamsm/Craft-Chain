import 'package:craft_chain/core/error/exception_mapper.dart';
import 'package:craft_chain/core/error/failures.dart';
import 'package:craft_chain/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:craft_chain/features/auth/domain/entities/user_entity.dart';
import 'package:craft_chain/features/auth/domain/repo/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepoImpl(this._authRemoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userModel = await _authRemoteDataSource.signUpWithEmail(
        email: email,
        password: password,
        name: name,
      );
      return Right(userModel);
    } catch (e) {
      return Left(ExceptionMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _authRemoteDataSource.signInWithEmail(
        email: email,
        password: password,
      );
      return Right(userModel as UserEntity);
    } catch (e) {
      return Left(ExceptionMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> resetPasswordForEmail({required String email}) {
    // TODO: implement resetPasswordForEmail
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updatePassword({required String password}) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> verifyPasswordResetOtp({
    required String email,
    required String otp,
  }) {
    // TODO: implement verifyPasswordResetOtp
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> signInWithOAuth(
    OAuthProvider provider,
    String callbackUrl,
  ) {
    // TODO: implement signInWithOAuth
    throw UnimplementedError();
  }
}
