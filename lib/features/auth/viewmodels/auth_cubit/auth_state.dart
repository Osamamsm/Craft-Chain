/// Immutable state class for [AuthCubit].
class AuthState {
  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isPasswordResetSent = false,
  });

  final bool isLoading;
  final String? errorMessage;
  final bool isPasswordResetSent;

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? isPasswordResetSent,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isPasswordResetSent: isPasswordResetSent ?? this.isPasswordResetSent,
    );
  }
}
