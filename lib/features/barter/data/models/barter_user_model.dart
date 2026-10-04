import 'package:craft_chain/features/barter/domain/entities/barter_user.dart';

class BarterUserModel extends BarterUser {
  const BarterUserModel({
    required super.id,
    required super.fullName,
    super.photoUrl,
    super.rating,
  });

  factory BarterUserModel.fromJson(Map<String, dynamic> json) =>
      BarterUserModel(
        id: json['id'] as String,
        fullName: json['full_name'] as String,
        photoUrl: json['photo_url'] as String?,
        rating: (json['rating'] as num?)?.toDouble(),
      );
}
