import 'package:craft_chain/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:craft_chain/features/auth/domain/entities/user_entity.dart';
import 'package:craft_chain/features/auth/domain/repo/auth_repo.dart';
import 'package:gotrue/src/types/types.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepoImpl(this._authRemoteDataSource);

  @override
  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) {
    // TODO: implement signUpWithEmail
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  }) {
    // TODO: implement signInWithEmail
    throw UnimplementedError();
  }

  @override
  Future<void> resetPasswordForEmail({required String email}) {
    // TODO: implement resetPasswordForEmail
    throw UnimplementedError();
  }

  @override
  Future<void> updatePassword({required String password}) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }

  @override
  Future<void> verifyPasswordResetOtp({
    required String email,
    required String otp,
  }) {
    // TODO: implement verifyPasswordResetOtp
    throw UnimplementedError();
  }

  @override
  Future<bool> signInWithOAuth(OAuthProvider provider, String callbackUrl) {
    // TODO: implement signInWithOAuth
    throw UnimplementedError();
  }
}
