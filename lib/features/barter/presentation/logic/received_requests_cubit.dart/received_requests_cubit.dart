import 'dart:math';

import 'package:craft_chain/features/barter/domain/entities/received_barter_request.dart';
import 'package:craft_chain/features/barter/domain/repo/barters_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'received_requests_state.dart';

class ReceivedRequestsCubit extends Cubit<ReceivedRequestsState> {
  final BartersRepo _bartersRepo;
  ReceivedRequestsCubit(this._bartersRepo) : super(ReceivedRequestsInitial());

  Future<void> getReceivedRequests() async {
    emit(ReceivedRequestsLoading());
    final result = await _bartersRepo.getReceivedRequests();
    result.fold(
      (failure) => emit(ReceivedRequestsFailure(message: failure.message)),
      (requests) => emit(ReceivedRequestsSuccess(requests: requests)),
    );
  }

  /// Accepts a request with optimistic UI:
  /// 1. the card leaves the list immediately,
  /// 2. call the RPC,
  /// 3. technical failure -> put that one card back where it was;
  ///    logical failure (success:false) -> don't restore (the request is no
  ///    longer pending), just show the message and resync.
  /// Every outcome ends with a snackbar message.
  Future<void> acceptRequest(String barterId) async {
    final current = state;
    if (current is! ReceivedRequestsSuccess) return;

    final index = current.requests.indexWhere((r) => r.barterId == barterId);
    if (index == -1) return; // already handled / double tap
    final request = current.requests[index];

    // 1. optimistic: remove the card (feedback = null)
    emit(
      ReceivedRequestsSuccess(
        requests: [
          for (final r in current.requests)
            if (r.barterId != barterId) r,
        ],
      ),
    );

    // 2. real call
    final result = await _bartersRepo.acceptBarter(barterId);
    if (isClosed) return;

    // 3. reconcile against the CURRENT state (other actions may be in flight)
    await result.fold(
      (failure) async {
        final latest = state;
        if (latest is! ReceivedRequestsSuccess) return;
        emit(
          ReceivedRequestsSuccess(
            requests: [...latest.requests]
              ..insert(min(index, latest.requests.length), request),
            feedback: ReceivedRequestsFeedback(
              message: failure.message,
              isError: true,
              action: ReceivedRequestAction.accept,
            ),
          ),
        );
      },
      (actionResult) async {
        final latest = state;
        if (latest is ReceivedRequestsSuccess) {
          emit(
            ReceivedRequestsSuccess(
              requests: latest.requests,
              feedback: ReceivedRequestsFeedback(
                message: actionResult.message,
                isError: !actionResult.success,
                action: ReceivedRequestAction.accept,
              ),
            ),
          );
        }
        if (!actionResult.success) await _silentRefresh();
      },
    );
  }

  /// Same flow as [acceptRequest], with the reject RPC.
  Future<void> rejectRequest(String barterId) async {
    final current = state;
    if (current is! ReceivedRequestsSuccess) return;

    final index = current.requests.indexWhere((r) => r.barterId == barterId);
    if (index == -1) return;
    final request = current.requests[index];

    emit(
      ReceivedRequestsSuccess(
        requests: [
          for (final r in current.requests)
            if (r.barterId != barterId) r,
        ],
      ),
    );

    final result = await _bartersRepo.rejectBarter(barterId);
    if (isClosed) return;

    await result.fold(
      (failure) async {
        final latest = state;
        if (latest is! ReceivedRequestsSuccess) return;
        emit(
          ReceivedRequestsSuccess(
            requests: [...latest.requests]
              ..insert(min(index, latest.requests.length), request),
            feedback: ReceivedRequestsFeedback(
              message: failure.message,
              isError: true,
              action: ReceivedRequestAction.reject,
            ),
          ),
        );
      },
      (actionResult) async {
        final latest = state;
        if (latest is ReceivedRequestsSuccess) {
          emit(
            ReceivedRequestsSuccess(
              requests: latest.requests,
              feedback: ReceivedRequestsFeedback(
                message: actionResult.message,
                isError: !actionResult.success,
                action: ReceivedRequestAction.reject,
              ),
            ),
          );
        }
        if (!actionResult.success) await _silentRefresh();
      },
    );
  }

  /// Refetches without emitting Loading (no skeleton flash).
  Future<void> _silentRefresh() async {
    final result = await _bartersRepo.getReceivedRequests();
    if (isClosed) return;
    result.fold(
      (_) {}, // keep what we have; a failed refresh isn't worth an error
      (requests) => emit(ReceivedRequestsSuccess(requests: requests)),
    );
  }
}