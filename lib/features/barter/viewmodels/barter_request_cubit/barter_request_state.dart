import 'package:craft_chain/features/barter/models/barter.dart';

class BarterRequestState {
  const BarterRequestState({
    this.chats = const [],
    this.received = const [],
    this.sent = const [],
    this.isLoadingChats = false,
    this.isLoadingReceived = false,
    this.isLoadingSent = false,
    this.errorMessage,
  });

  /// Active and completed barters the current user participates in.
  final List<BarterModel> chats;

  /// Incoming pending requests (status == pending, current user == user2).
  final List<BarterModel> received;

  /// Outgoing pending requests (status == pending, current user == user1).
  final List<BarterModel> sent;

  final bool isLoadingChats;
  final bool isLoadingReceived;
  final bool isLoadingSent;


  final String? errorMessage;

  BarterRequestState copyWith({
    List<BarterModel>? chats,
    List<BarterModel>? received,
    List<BarterModel>? sent,
    bool? isLoadingChats,
    bool? isLoadingReceived,
    bool? isLoadingSent,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BarterRequestState(
      chats: chats ?? this.chats,
      received: received ?? this.received,
      sent: sent ?? this.sent,
      isLoadingChats: isLoadingChats ?? this.isLoadingChats,
      isLoadingReceived: isLoadingReceived ?? this.isLoadingReceived,
      isLoadingSent: isLoadingSent ?? this.isLoadingSent,
    );
  }
}
