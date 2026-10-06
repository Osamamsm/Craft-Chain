import 'package:craft_chain/features/barter/data/models/barter_user_model.dart';
import 'package:craft_chain/features/barter/data/models/model_utils.dart';
import 'package:craft_chain/features/barter/domain/entities/received_barter_request.dart';

class ReceivedBarterRequestModel extends ReceivedBarterRequest {
  const ReceivedBarterRequestModel({
    required super.barterId,
    required super.createdAt,
    required super.requester,
    required super.willTeachYou,
    required super.wantsToLearn,
  });

  factory ReceivedBarterRequestModel.fromJson(Map<String, dynamic> json) =>
      ReceivedBarterRequestModel(
        barterId: json['barter_id'] as String,
        createdAt: parseDate(json['created_at'] as String),
        requester: BarterUserModel(
          id: json['requester_id'] as String,
          fullName: json['requester_name'] as String,
          photoUrl: json['requester_photo'] as String,
          rating: (json['requester_rating'] as num?)?.toDouble(),
        ),
        willTeachYou: json['will_teach_you'] as String,
        wantsToLearn: json['wants_to_learn'] as String,
      );
}
