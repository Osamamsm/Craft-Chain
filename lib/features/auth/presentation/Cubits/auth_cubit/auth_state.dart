import 'package:craft_chain/features/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final UserEntity user;

  const AuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PasswordResetEmailSent extends AuthState {
  final String email;
  final String message;

  const PasswordResetEmailSent({required this.message, required this.email});

  @override
  List<Object?> get props => [message];
}

class PasswordUpdated extends AuthState {
  final String message;

  const PasswordUpdated({required this.message});
}
