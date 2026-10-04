import 'package:craft_chain/features/barter/data/models/barter_chat_info_model.dart';
import 'package:craft_chain/features/barter/data/models/barter_message_model.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_chat.dart';

class BarterChatModel extends BarterChat {
  const BarterChatModel({required super.info, required super.messages});

  factory BarterChatModel.fromJson(Map<String, dynamic> json) =>
      BarterChatModel(
        info: BarterChatInfoModel.fromJson(
          json['barter'] as Map<String, dynamic>,
        ),
        messages: (json['messages'] as List)
            .map((m) => BarterMessageModel.fromJson(m as Map<String, dynamic>))
            .toList(),
      );
}
