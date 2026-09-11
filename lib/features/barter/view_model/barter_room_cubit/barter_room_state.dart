import 'package:craft_chain/features/barter/models/barter.dart';
import 'package:craft_chain/features/barter/models/message.dart';

class BarterRoomState {
  const BarterRoomState({
    this.barter,
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.isCompleted = false,
    this.errorMessage,
  });

  final BarterModel? barter;
  final List<MessageModel> messages;
  final bool isLoading;
  final bool isSending;
  final bool isCompleted;
  final String? errorMessage;

  BarterRoomState copyWith({
    BarterModel? barter,
    List<MessageModel>? messages,
    bool? isLoading,
    bool? isSending,
    bool? isCompleted,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BarterRoomState(
      barter: barter ?? this.barter,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      isCompleted: isCompleted ?? this.isCompleted,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
