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
    return _goTrueClient.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );
  }

  @override
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _goTrueClient.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> resetPasswordForEmail({required String email}) {
    return _goTrueClient.resetPasswordForEmail(email);
  }

  @override
  Future<AuthResponse> verifyPasswordResetOtp({
    required String email,
    required String otp,
  }) {
    return _goTrueClient.verifyOTP(
      email: email,
      token: otp,
      type: OtpType.recovery,
    );
  }

  @override
  Future<UserResponse> updatePassword({required String password}) {
    return _goTrueClient.updateUser(UserAttributes(password: password));
  }

  @override
  Future<bool> signInWithOAuth(OAuthProvider provider, String callbackUrl) {
    // TODO: implement signInWithOAuth
    throw UnimplementedError();
  }

  @override
  
  User? get getCurrentUser => _goTrueClient.currentUser;

  @override
  
  Stream<AuthState> get onAuthStateChange => _goTrueClient.onAuthStateChange;

  @override
  Future<void> signOut() {
    return _goTrueClient.signOut();
  }
}
