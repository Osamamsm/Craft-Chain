import 'package:craft_chain/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> resetPasswordForEmail({required String email});

  Future<void> verifyPasswordResetOtp({
    required String email,
    required String otp,
  });

  Future<void> updatePassword({required String password});

  Future<bool> signInWithOAuth(OAuthProvider provider, String callbackUrl);
}