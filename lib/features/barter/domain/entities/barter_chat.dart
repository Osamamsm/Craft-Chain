import 'package:craft_chain/features/barter/domain/entities/barter_chat_info.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_message.dart';
import 'package:equatable/equatable.dart';

/// Result of `get_barter_chat`: header + one page of messages (oldest first).
///
/// There is no `hasMore` flag from the server: if `messages.length` equals the
/// requested limit, assume there may be older messages.
class BarterChat extends Equatable {
  const BarterChat({required this.info, required this.messages});

  final BarterChatInfo info;
  final List<BarterMessage> messages;

  @override
  List<Object?> get props => [info, messages];
}
