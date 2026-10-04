import 'package:craft_chain/features/barter/data/models/barter_user_model.dart';
import 'package:craft_chain/features/barter/data/models/model_utils.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_status.dart';
import 'package:craft_chain/features/barter/domain/entities/sent_barter_request.dart';

class SentBarterRequestModel extends SentBarterRequest {
  const SentBarterRequestModel({
    required super.barterId,
    required super.status,
    required super.createdAt,
    required super.recipient,
    required super.youWillTeach,
    required super.youWillLearn,
  });

  factory SentBarterRequestModel.fromJson(Map<String, dynamic> json) =>
      SentBarterRequestModel(
        barterId: json['barter_id'] as String,
        status: BarterStatus.fromString(json['status'] as String),
        createdAt: parseDate(json['created_at'] as String),
        recipient: BarterUserModel(
          id: json['recipient_id'] as String,
          fullName: json['recipient_name'] as String,
          photoUrl: json['recipient_photo'] as String?,
        ),
        youWillTeach: json['you_will_teach'] as String,
        youWillLearn: json['you_will_learn'] as String,
      );
}
