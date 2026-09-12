import 'package:craft_chain/features/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepo {
  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<UserEntity> signInWithEmail({
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