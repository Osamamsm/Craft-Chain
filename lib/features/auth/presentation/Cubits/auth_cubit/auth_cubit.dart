import 'package:craft_chain/features/auth/domain/repo/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;

  AuthCubit(this._authRepo) : super(const AuthInitial());

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    final result = await _authRepo.signUpWithEmail(
      email: email,
      password: password,
      name: fullName,
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading());
    final result = await _authRepo.signInWithEmail(
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> resetPasswordForEmail({required String email}) async {}

  Future<void> verifyPasswordResetOtp({
    required String email,
    required String otp,
  }) async {}

  Future<void> updatePassword({required String password}) async {}

  Future<void> signInWithOAuth(
    OAuthProvider provider,
    String callbackUrl,
  ) async {}
}
