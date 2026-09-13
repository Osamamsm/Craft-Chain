import 'package:craft_chain/core/error/failures.dart';
import 'package:craft_chain/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> resetPasswordForEmail({required String email});

  Future<Either<Failure, void>> verifyPasswordResetOtp({
    required String email,
    required String otp,
  });

  Future<Either<Failure, void>> updatePassword({required String password});

  Future<Either<Failure, bool>> signInWithOAuth(
    OAuthProvider provider,
    String callbackUrl,
  );
}
