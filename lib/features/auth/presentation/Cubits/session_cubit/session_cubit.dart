import 'dart:async';

import 'package:craft_chain/features/auth/domain/repo/session_repo.dart';
import 'package:craft_chain/features/auth/presentation/Cubits/session_cubit/session_state.dart';
import 'package:craft_chain/features/profile/domain/repo/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionCubit extends Cubit<SessionState> {
  final SessionRepo _sessionRepo;
  final ProfileRepo _profileRepo;
  StreamSubscription? _authStateSubscription;
  SessionCubit(this._sessionRepo, this._profileRepo) : super(const SessionInitial()) {
    _authStateSubscription = _sessionRepo.onAuthStateChange.listen((authState) {
      switch (authState.event) {
        case AuthChangeEvent.passwordRecovery:
          if (authState.user != null) {
            emit(PasswordRecovery(user: authState.user!));
          }
          break;

        case AuthChangeEvent.signedIn:
          if (authState.user != null) {
            _checkProfileAndEmitAuthenticated(authState.user!);
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
        _checkProfileAndEmitAuthenticated(user);
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

  Future<void> _checkProfileAndEmitAuthenticated(user) async {
    final result = await _profileRepo.isProfileComplete();
    final isComplete = result.fold((_) => false, (complete) => complete);
    emit(Authenticated(user: user, isProfileComplete: isComplete));
  }

  void markProfileComplete() {
    if (state is Authenticated) {
      emit(Authenticated(
        user: (state as Authenticated).user,
        isProfileComplete: true,
      ));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
