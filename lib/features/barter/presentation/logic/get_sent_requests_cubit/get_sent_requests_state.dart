part of 'get_sent_requests_cubit.dart';

sealed class GetSentRequestsState extends Equatable {
  const GetSentRequestsState();

  @override
  List<Object> get props => [];
}

final class GetSentRequestsInitial extends GetSentRequestsState {}

final class GetSentRequestsLoading extends GetSentRequestsState {}

final class GetSentRequestsSuccess extends GetSentRequestsState {
  final List<SentBarterRequest> requests;
  const GetSentRequestsSuccess({required this.requests});

  @override
  List<Object> get props => [requests];
}

final class GetSentRequestsFailure extends GetSentRequestsState {
  final String message;
  const GetSentRequestsFailure({required this.message});

  @override
  List<Object> get props => [message];
}
