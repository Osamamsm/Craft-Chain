import 'package:craft_chain/features/barter/domain/entities/barter_status.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_user.dart';
import 'package:equatable/equatable.dart';

class BarterChatPreview extends Equatable {
  const BarterChatPreview({
    required this.barterId,
    required this.status,
    required this.otherUser,
    required this.mySkill,
    required this.theirSkill,
    required this.unreadCount,
    this.lastMessageText,
    this.lastMessageTime,
    this.scheduledAt,
  });

  final String barterId;
  final BarterStatus status;
  final BarterUser otherUser;

  final String mySkill;

  final String theirSkill;

  final String? lastMessageText;
  final DateTime? lastMessageTime;
  final DateTime? scheduledAt;
  final int unreadCount;

  bool get hasUnread => unreadCount > 0;
  bool get isCompleted => status == BarterStatus.completed;

  @override
  List<Object?> get props => [
        barterId,
        status,
        otherUser,
        mySkill,
        theirSkill,
        lastMessageText,
        lastMessageTime,
        scheduledAt,
        unreadCount,
      ];
}
