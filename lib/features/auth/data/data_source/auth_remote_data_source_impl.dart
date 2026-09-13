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
  }) async {
    final response = await _authClient.signInWithEmail(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw AuthException('Signin Failed - No user returned');
    }
    return (UserModel.fromSupabase(response.user!));
  }

  @override
  Future<void> resetPasswordForEmail({required String email}) {
    return _authClient.resetPasswordForEmail(email: email);
  }

  @override
  Future<void> verifyPasswordResetOtp({
    required String email,
    required String otp,
  }) {
    return _authClient.verifyPasswordResetOtp(email: email, otp: otp);
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
