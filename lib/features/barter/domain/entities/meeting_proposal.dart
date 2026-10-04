import 'package:craft_chain/features/barter/domain/entities/meeting_platform.dart';
import 'package:equatable/equatable.dart';

class MeetingProposal extends Equatable {
  const MeetingProposal({
    required this.proposedBy,
    required this.isMine,
    required this.scheduledAt,
    required this.meetingPlatform,
  });

  final String proposedBy;

  final bool isMine;

  final DateTime scheduledAt;
  final MeetingPlatform meetingPlatform;

  @override
  List<Object?> get props => [proposedBy, isMine, scheduledAt, meetingPlatform];
}
