import 'package:craft_chain/features/barter/domain/entities/meeting_platform.dart';

class MeetingPlatformModel extends MeetingPlatform {
  const MeetingPlatformModel({
    required super.id,
    required super.name,
    super.icon,
  });

  factory MeetingPlatformModel.fromJson(Map<String, dynamic> json) =>
      MeetingPlatformModel(
        id: json['id'] as String,
        name: json['name'] as String,
        icon: json['icon'] as String?,
      );
}
