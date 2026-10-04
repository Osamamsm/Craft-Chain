import 'package:craft_chain/core/error/failures.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_action_result.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_chat.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_chat_preview.dart';
import 'package:craft_chain/features/barter/domain/entities/meeting_platform.dart';
import 'package:craft_chain/features/barter/domain/entities/received_barter_request.dart';
import 'package:craft_chain/features/barter/domain/entities/sent_barter_request.dart';
import 'package:dartz/dartz.dart';

abstract class BartersRepo {
  Future<Either<Failure, BarterActionResult>> sendBarterRequest({
    required String recipientId,
    required int requesterSkillId,
    required int recipientSkillId,
  });

  Future<Either<Failure, BarterActionResult>> acceptBarter(String barterId);
  Future<Either<Failure, BarterActionResult>> rejectBarter(String barterId);
  Future<Either<Failure, BarterActionResult>> cancelBarter(String barterId);

  Future<Either<Failure, BarterActionResult>> proposeMeeting({
    required String barterId,
    required DateTime scheduledAt,
    required String meetingPlatformId,
  });

  Future<Either<Failure, BarterActionResult>> respondToMeetingProposal({
    required String barterId,
    required bool accept,
  });

  Future<Either<Failure, BarterActionResult>> withdrawMeetingProposal(
    String barterId,
  );

  Future<Either<Failure, List<BarterChatPreview>>> getActiveBarters();
  Future<Either<Failure, List<ReceivedBarterRequest>>> getReceivedRequests();
  Future<Either<Failure, List<SentBarterRequest>>> getSentRequests();

  Future<Either<Failure, BarterChat>> getBarterChat({
    required String barterId,
    int limit = 50,
    DateTime? before,
  });

  Future<Either<Failure, List<MeetingPlatform>>> getMeetingPlatforms();
}
