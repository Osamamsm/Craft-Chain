import 'package:craft_chain/features/barter/domain/entities/sent_barter_request.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_status.dart';
import 'package:craft_chain/features/barter/domain/repo/barters_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sent_requests_state.dart';

class SentRequestsCubit extends Cubit<SentRequestsState> {
  final BartersRepo _bartersRepo;

  SentRequestsCubit(this._bartersRepo) : super(GetSentRequestsInitial());

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
  /// 3. keep it on success, or flip THAT card back to pending on failure.
  /// Reconciliation always works on the current state (not a snapshot), so
  /// two cancels in flight can't undo each other.
  Future<void> cancelRequest(String barterId) async {
    final current = state;
    if (current is! GetSentRequestsSuccess) return;

    final target = current.requests
        .where((r) => r.barterId == barterId)
        .firstOrNull;
    // Ignore double taps / requests that are no longer pending.
    if (target == null || target.status != BarterStatus.pending) return;

    // 1. optimistic update (feedback = null)
    emit(
      GetSentRequestsSuccess(
        requests: [
          for (final r in current.requests)
            r.barterId == barterId
                ? r.copyWith(status: BarterStatus.cancelled)
                : r,
        ],
      ),
    );

    // 2. real call
    final result = await _bartersRepo.cancelBarter(barterId);
    if (isClosed) return;

    // 3. reconcile against the CURRENT state
    await result.fold(
      // Technical failure (server / network): flip this card back.
      (failure) async {
        final latest = state;
        if (latest is! GetSentRequestsSuccess) return;
        emit(
          GetSentRequestsSuccess(
            requests: [
              for (final r in latest.requests)
                r.barterId == barterId
                    ? r.copyWith(status: BarterStatus.pending)
                    : r,
            ],
            feedback: SentRequestsFeedback(
              message: failure.message,
              isError: true,
            ),
          ),
        );
      },
      (actionResult) async {
        final latest = state;
        if (actionResult.success) {
          if (latest is GetSentRequestsSuccess) {
            emit(
              GetSentRequestsSuccess(
                requests: latest.requests,
                feedback: SentRequestsFeedback(
                  message: actionResult.message,
                  isError: false,
                ),
              ),
            );
          }
          return;
        }
        // Logical failure (e.g. the recipient accepted in the meantime):
        // flip back, show the server message, then resync because our local
        // data was stale.
        if (latest is GetSentRequestsSuccess) {
          emit(
            GetSentRequestsSuccess(
              requests: [
                for (final r in latest.requests)
                  r.barterId == barterId
                      ? r.copyWith(status: BarterStatus.pending)
                      : r,
              ],
              feedback: SentRequestsFeedback(
                message: actionResult.message,
                isError: true,
              ),
            ),
          );
        }
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
