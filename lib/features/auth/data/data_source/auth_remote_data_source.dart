import 'package:craft_chain/features/auth/data/models/user_model.dart';

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

  Future<void> updatePassword({required String password});

  Future<UserModel> signInWithGoogle();
}
