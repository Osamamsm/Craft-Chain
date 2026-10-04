import 'package:craft_chain/features/barter/data/models/barter_user_model.dart';
import 'package:craft_chain/features/barter/data/models/meeting_platform_model.dart';
import 'package:craft_chain/features/barter/data/models/meeting_proposal_model.dart';
import 'package:craft_chain/features/barter/data/models/model_utils.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_chat_info.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_status.dart';

class BarterChatInfoModel extends BarterChatInfo {
  const BarterChatInfoModel({
    required super.barterId,
    required super.status,
    required super.otherUser,
    required super.mySkill,
    required super.theirSkill,
    super.scheduledAt,
    super.meetingPlatform,
    super.pendingProposal,
  });

  factory BarterChatInfoModel.fromJson(Map<String, dynamic> json) {
    final platform = json['meeting_platform'] as Map<String, dynamic>?;
    final hasPlatform = platform != null && platform['id'] != null;

    final proposal = json['pending_proposal'] as Map<String, dynamic>?;

    return BarterChatInfoModel(
      barterId: json['barter_id'] as String,
      status: BarterStatus.fromString(json['status'] as String),
      otherUser: BarterUserModel.fromJson(
        json['other_user'] as Map<String, dynamic>,
      ),
      mySkill: json['my_skill'] as String,
      theirSkill: json['their_skill'] as String,
      scheduledAt: parseDateOrNull(json['scheduled_at'] as String?),
      meetingPlatform: hasPlatform
          ? MeetingPlatformModel.fromJson(platform)
          : null,
      pendingProposal: proposal == null
          ? null
          : MeetingProposalModel.fromJson(proposal),
    );
  }
}
