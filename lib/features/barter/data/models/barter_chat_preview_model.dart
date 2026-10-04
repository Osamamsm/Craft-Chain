import 'package:craft_chain/features/barter/data/models/barter_user_model.dart';
import 'package:craft_chain/features/barter/data/models/model_utils.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_chat_preview.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_status.dart';

class BarterChatPreviewModel extends BarterChatPreview {
  const BarterChatPreviewModel({
    required super.barterId,
    required super.status,
    required super.otherUser,
    required super.mySkill,
    required super.theirSkill,
    required super.unreadCount,
    super.lastMessageText,
    super.lastMessageTime,
    super.scheduledAt,
  });

  factory BarterChatPreviewModel.fromJson(Map<String, dynamic> json) =>
      BarterChatPreviewModel(
        barterId: json['barter_id'] as String,
        status: BarterStatus.fromString(json['status'] as String),
        otherUser: BarterUserModel(
          id: json['other_user_id'] as String,
          fullName: json['other_user_name'] as String,
          photoUrl: json['other_user_photo'] as String?,
        ),
        mySkill: json['my_skill'] as String,
        theirSkill: json['their_skill'] as String,
        lastMessageText: json['last_message_text'] as String?,
        lastMessageTime: parseDateOrNull(json['last_message_time'] as String?),
        scheduledAt: parseDateOrNull(json['scheduled_at'] as String?),
        unreadCount: (json['unread_count'] as num).toInt(),
      );
}
