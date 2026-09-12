import 'package:craft_chain/core/supabase/auth_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthClientImpl implements AuthClient {
  final GoTrueClient _goTrueClient;
  SupabaseAuthClientImpl(this._goTrueClient);

  @override
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<void> resetPasswordForEmail({required String email}) {
    // TODO: implement resetPasswordForEmail
    throw UnimplementedError();
  }

  @override
  Future<AuthResponse> verifyPasswordResetOtp({
    required String email,
    required String otp,
  }) {
    // TODO: implement verifyPasswordResetOtp
    throw UnimplementedError();
  }

  @override
  Future<UserResponse> updatePassword({required String password}) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }

  @override
  Future<bool> signInWithOAuth(OAuthProvider provider, String callbackUrl) {
    // TODO: implement signInWithOAuth
    throw UnimplementedError();
  }
}
