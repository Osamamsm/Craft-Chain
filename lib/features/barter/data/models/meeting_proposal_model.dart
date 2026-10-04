import 'package:craft_chain/features/barter/data/models/meeting_platform_model.dart';
import 'package:craft_chain/features/barter/data/models/model_utils.dart';
import 'package:craft_chain/features/barter/domain/entities/meeting_proposal.dart';

class MeetingProposalModel extends MeetingProposal {
  const MeetingProposalModel({
    required super.proposedBy,
    required super.isMine,
    required super.scheduledAt,
    required super.meetingPlatform,
  });

  factory MeetingProposalModel.fromJson(Map<String, dynamic> json) =>
      MeetingProposalModel(
        proposedBy: json['proposed_by'] as String,
        isMine: json['is_mine'] as bool,
        scheduledAt: parseDate(json['scheduled_at'] as String),
        meetingPlatform: MeetingPlatformModel.fromJson(
          json['meeting_platform'] as Map<String, dynamic>,
        ),
      );
}
