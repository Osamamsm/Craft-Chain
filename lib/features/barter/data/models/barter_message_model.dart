import 'package:craft_chain/features/barter/data/models/model_utils.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_message.dart';

class BarterMessageModel extends BarterMessage {
  const BarterMessageModel({
    required super.id,
    required super.senderId,
    required super.text,
    required super.isRead,
    required super.createdAt,
    required super.isMine,
  });

  factory BarterMessageModel.fromJson(Map<String, dynamic> json) =>
      BarterMessageModel(
        id: json['id'] as String,
        senderId: json['sender_id'] as String,
        text: json['text'] as String,
        isRead: json['is_read'] as bool,
        createdAt: parseDate(json['created_at'] as String),
        isMine: json['is_mine'] as bool,
      );
}
