import 'package:craft_chain/features/barter/domain/entities/barter_status.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_user.dart';
import 'package:craft_chain/features/barter/domain/entities/meeting_platform.dart';
import 'package:craft_chain/features/barter/domain/entities/meeting_proposal.dart';
import 'package:equatable/equatable.dart';

class BarterChatInfo extends Equatable {
  const BarterChatInfo({
    required this.barterId,
    required this.status,
    required this.otherUser,
    required this.mySkill,
    required this.theirSkill,
    this.scheduledAt,
    this.meetingPlatform,
    this.pendingProposal,
  });

  final String barterId;
  final BarterStatus status;
  final BarterUser otherUser;
  final String mySkill;
  final String theirSkill;

  final DateTime? scheduledAt;
  final MeetingPlatform? meetingPlatform;

  final MeetingProposal? pendingProposal;

  bool get isScheduled => scheduledAt != null;
  bool get hasPendingProposal => pendingProposal != null;

  bool get canProposeMeeting => status == BarterStatus.active;

  bool get canRespondToProposal =>
      canProposeMeeting && pendingProposal != null && !pendingProposal!.isMine;

  bool get canWithdrawProposal =>
      canProposeMeeting && pendingProposal != null && pendingProposal!.isMine;

  @override
  List<Object?> get props => [
        barterId,
        status,
        otherUser,
        mySkill,
        theirSkill,
        scheduledAt,
        meetingPlatform,
        pendingProposal,
      ];
}

