import 'package:craft_chain/features/barter/domain/entities/barter_status.dart';
import 'package:craft_chain/features/barter/domain/entities/sent_barter_request.dart';
import 'package:craft_chain/features/barter/domain/repo/barters_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sent_requests_state.dart';

class GetSentRequestsCubit extends Cubit<GetSentRequestsState> {
  final BartersRepo _bartersRepo;

  GetSentRequestsCubit(this._bartersRepo) : super(GetSentRequestsInitial());

  Future<void> getSentRequests() async {
    emit(GetSentRequestsLoading());
    final result = await _bartersRepo.getSentRequests();
    result.fold(
      (failure) => emit(GetSentRequestsFailure(message: failure.message)),
      (requests) => emit(GetSentRequestsSuccess(requests: requests)),
    );
  }

  /// Cancels a pending request with optimistic UI:
  /// 1. flip the card to "cancelled" immediately,
  /// 2. call the RPC,
  /// 3. keep it on success, or roll back on failure; both show a snackbar.
  Future<void> cancelRequest(String barterId) async {
    final current = state;
    if (current is! GetSentRequestsSuccess) return;

    final target =
        current.requests.where((r) => r.barterId == barterId).firstOrNull;
    // Ignore double taps / requests that are no longer pending.
    if (target == null || target.status != BarterStatus.pending) return;

    final previous = current.requests;
    final optimistic = [
      for (final r in previous)
        r.barterId == barterId ? r.copyWith(status: BarterStatus.cancelled) : r,
    ];

    // 1. optimistic update (feedback = null)
    emit(GetSentRequestsSuccess(requests: optimistic));

    // 2. real call
    final result = await _bartersRepo.cancelBarter(barterId);
    if (isClosed) return;

    // 3. reconcile
    await result.fold(
      // Technical failure (server / network): roll back.
      (failure) async => emit(
        GetSentRequestsSuccess(
          requests: previous,
          feedback: SentRequestsFeedback(message: failure.message, isError: true),
        ),
      ),
      (actionResult) async {
        if (actionResult.success) {
          emit(
            GetSentRequestsSuccess(
              requests: optimistic,
              feedback: SentRequestsFeedback(
                message: actionResult.message,
                isError: false,
              ),
            ),
          );
          return;
        }
        // Logical failure (e.g. the recipient accepted in the meantime):
        // roll back, show the server message, then resync with the server
        // because our local data was stale.
        emit(
          GetSentRequestsSuccess(
            requests: previous,
            feedback: SentRequestsFeedback(
              message: actionResult.message,
              isError: true,
            ),
          ),
        );
        await _silentRefresh();
      },
    );
  }

  /// Refetches without emitting Loading (no skeleton flash).
  Future<void> _silentRefresh() async {
    final result = await _bartersRepo.getSentRequests();
    if (isClosed) return;
    result.fold(
      (_) {}, // keep what we have; a failed refresh isn't worth an error
      (requests) => emit(GetSentRequestsSuccess(requests: requests)),
    );
  }
}