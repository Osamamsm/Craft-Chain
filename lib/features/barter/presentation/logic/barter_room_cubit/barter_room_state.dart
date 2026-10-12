import 'package:craft_chain/features/barter/domain/entities/barter_chat.dart';
import 'package:equatable/equatable.dart';

sealed class BarterRoomState extends Equatable {
  const BarterRoomState();

  @override
  List<Object?> get props => [];
}

final class BarterRoomInitial extends BarterRoomState {}

final class BarterRoomLoading extends BarterRoomState {}

final class BarterRoomLoaded extends BarterRoomState {
  final BarterChat chat;
  final BarterChatFeedback? feedback;

  const BarterRoomLoaded({required this.chat, this.feedback});

  @override
  List<Object?> get props => [chat, feedback];
}

final class BarterRoomError extends BarterRoomState {
  final String error;

  const BarterRoomError({required this.error});

  @override
  List<Object?> get props => [error];
}

class BarterChatFeedback extends Equatable {
  final String message;
  final bool isError;

  const BarterChatFeedback({required this.message, required this.isError});

  @override
  List<Object?> get props => [message, isError];
}
