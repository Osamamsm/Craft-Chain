import 'package:craft_chain/core/error/exceptions.dart';
import 'package:craft_chain/core/supabase/auth_client.dart';
import 'package:craft_chain/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:craft_chain/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthClient _authClient;
  AuthRemoteDataSourceImpl(this._authClient);
  @override
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _authClient.signUpWithEmail(
      email: email,
      password: password,
      name: name,
    );

    if (response.user == null) {
      throw AuthException('Signup Failed - No user returned');
    }
    return (UserModel.fromSupabase(response.user!));
  }

  @override
  Future<UserModel> signInWithEmail({
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
  Future<void> verifyPasswordResetOtp({
    required String email,
    required String otp,
  }) {
    // TODO: implement verifyPasswordResetOtp
    throw UnimplementedError();
  }

  @override
  Future<void> updatePassword({required String password}) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }

  @override
  Future<bool> signInWithOAuth(OAuthProvider provider, String callbackUrl) {
    // TODO: implement signInWithOAuth
    throw UnimplementedError();
  }
}
