import 'dart:async';

import 'package:craft_chain/features/auth/domain/repo/session_repo.dart';
import 'package:craft_chain/features/auth/presentation/Cubits/session_cubit/session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionCubit extends Cubit<SessionState> {
  final SessionRepo _sessionRepo;
  StreamSubscription? _authStateSubscription;
  SessionCubit(this._sessionRepo) : super(const SessionInitial()) {
    _authStateSubscription = _sessionRepo.onAuthStateChange.listen((authState) {
      switch (authState.event) {
        case AuthChangeEvent.passwordRecovery:
          if (authState.user != null) {
            emit(PasswordRecovery(user: authState.user!));
          }
          break;

        case AuthChangeEvent.signedIn:
          if (authState.user != null) {
            emit(Authenticated(user: authState.user!));
          }
          break;

        case AuthChangeEvent.signedOut:
          emit(const Unauthenticated());
          break;

        default:
          break;
      }
    });
  }

  Future<void> checkAuthStatus() async {
    emit(SessionLoading());
    final result = _sessionRepo.getCurrentUser();
    result.fold((failure) => emit(SessionError(message: failure.message)), (
      user,
    ) {
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(const Unauthenticated());
      }
    });
  }

  Future<void> signOut() async {
    emit(SessionLoading());
    final result = await _sessionRepo.signOut();
    result.fold(
      (failure) => emit(SessionError(message: failure.message)),
      (_) => emit(const Unauthenticated()),
    );
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
