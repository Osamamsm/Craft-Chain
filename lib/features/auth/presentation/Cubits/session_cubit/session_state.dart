import 'package:craft_chain/features/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

class SessionInitial extends SessionState {
  const SessionInitial();
}

class SessionLoading extends SessionState {
  const SessionLoading();
}

class Authenticated extends SessionState {
  final UserEntity user;
  final bool isProfileComplete;

  const Authenticated({required this.user, this.isProfileComplete = false});

  @override
  List<Object?> get props => [user, isProfileComplete];
}

class Unauthenticated extends SessionState {
  const Unauthenticated();
}

class PasswordRecovery extends SessionState {
  final UserEntity user;

  const PasswordRecovery({required this.user});

  @override
  List<Object?> get props => [user];
}

class SessionError extends SessionState {
  final String message;

  const SessionError({required this.message});

  @override
  List<Object?> get props => [message];
}