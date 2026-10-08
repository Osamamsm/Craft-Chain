part of 'active_barters_cubit.dart';

sealed class ActiveBartersState extends Equatable {
  const ActiveBartersState();

  @override
  List<Object> get props => [];
}

final class ActiveBartersInitial extends ActiveBartersState {}

final class ActiveBartersLoading extends ActiveBartersState {}

final class ActiveBartersSuccess extends ActiveBartersState {
  final List<BarterChatPreview> chats;
  const ActiveBartersSuccess(this.chats);

  @override
  List<Object> get props => [chats];
}

final class ActiveBartersFailure extends ActiveBartersState {
  final String message;
  const ActiveBartersFailure(this.message);

  @override
  List<Object> get props => [message];
}

