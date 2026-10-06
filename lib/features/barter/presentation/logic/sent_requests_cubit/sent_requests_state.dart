part of 'sent_requests_cubit.dart';

sealed class GetSentRequestsState extends Equatable {
  const GetSentRequestsState();

  // List<Object?> (was List<Object>) because feedback below is nullable.
  @override
  List<Object?> get props => [];
}

final class GetSentRequestsInitial extends GetSentRequestsState {}

final class GetSentRequestsLoading extends GetSentRequestsState {}

final class GetSentRequestsSuccess extends GetSentRequestsState {
  final List<SentBarterRequest> requests;
  final SentRequestsFeedback? feedback;

  const GetSentRequestsSuccess({required this.requests, this.feedback});

  @override
  List<Object?> get props => [requests, feedback];
}

final class GetSentRequestsFailure extends GetSentRequestsState {
  final String message;
  const GetSentRequestsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class SentRequestsFeedback extends Equatable {
  final String message;
  final bool isError;

  const SentRequestsFeedback({required this.message, required this.isError});

  @override
  List<Object?> get props => [message, isError];
}