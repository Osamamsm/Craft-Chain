import 'dart:async';

import 'package:craft_chain/features/auth/domain/repo/session_repo.dart';
import 'package:craft_chain/features/auth/presentation/Cubits/session_cubit/session_cubit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionCubit extends Cubit<SessionState> {
  final SessionRepo _sessionRepo;
  StreamSubscription? _authStateSubscription;
  SessionCubit(this._sessionRepo) : super(const SessionInitial()) {
    _authStateSubscription = _sessionRepo.onAuthStateChange.listen((user) {
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(const Unauthenticated());
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

  Stream<SessionState> get authStateChanges async* {
    yield SessionLoading();
    await for (final user in _sessionRepo.onAuthStateChange) {
      if (user != null) {
        yield Authenticated(user: user);
      } else {
        yield const Unauthenticated();
      }
    }
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
