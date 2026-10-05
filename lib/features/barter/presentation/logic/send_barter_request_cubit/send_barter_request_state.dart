part of 'send_barter_request_cubit.dart';

sealed class SendBarterRequestState extends Equatable {
  const SendBarterRequestState();

  @override
  List<Object> get props => [];
}

final class SendBarterRequestInitial extends SendBarterRequestState {}

final class SendBarterRequestLoading extends SendBarterRequestState {}

final class SendBarterRequestLoaded extends SendBarterRequestState {
  final BarterActionResult result;
  const SendBarterRequestLoaded(this.result);
  @override
  List<Object> get props => [result];
}

final class SendBarterRequestError extends SendBarterRequestState {
  final String error;
  const SendBarterRequestError(this.error);
  @override
  List<Object> get props => [error];
}

