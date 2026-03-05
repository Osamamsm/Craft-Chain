import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'auth_state.dart';

export 'auth_state.dart';

/// Stub Cubit — Firebase will be wired in task 01b.
/// Views call these methods; they simulate async work for now.
@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    await Future.delayed(const Duration(milliseconds: 1200));
    // TODO(task-01b): call authRepository.signUp()
    emit(state.copyWith(isLoading: false));
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    await Future.delayed(const Duration(milliseconds: 1200));
    // TODO(task-01b): call authRepository.signIn()
    emit(state.copyWith(isLoading: false));
  }

  Future<void> resetPassword({required String email}) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    await Future.delayed(const Duration(milliseconds: 1200));
    // TODO(task-01b): call authRepository.resetPassword()
    emit(state.copyWith(isLoading: false, isPasswordResetSent: true));
  }

  void clearError() => emit(state.copyWith(clearError: true));
}
