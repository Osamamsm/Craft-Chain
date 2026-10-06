part of 'received_requests_cubit.dart';

sealed class ReceivedRequestsState extends Equatable {
  const ReceivedRequestsState();

  @override
  List<Object?> get props => [];
}

final class ReceivedRequestsInitial extends ReceivedRequestsState {}

class ReceivedRequestsLoading extends ReceivedRequestsState {
  const ReceivedRequestsLoading();
}

class ReceivedRequestsSuccess extends ReceivedRequestsState {
  final List<ReceivedBarterRequest> requests;
  final ReceivedRequestsFeedback? feedback;

  const ReceivedRequestsSuccess({required this.requests, this.feedback});

  @override
  List<Object?> get props => [requests, feedback];
}

class ReceivedRequestsFailure extends ReceivedRequestsState {
  final String message;
  const ReceivedRequestsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

enum ReceivedRequestAction { accept, reject }

class ReceivedRequestsFeedback extends Equatable {
  final String message;
  final bool isError;
  final ReceivedRequestAction action;

  const ReceivedRequestsFeedback({
    required this.message,
    required this.isError,
    required this.action,
  });

  @override
  List<Object?> get props => [message, isError, action];
}
