import 'package:craft_chain/features/barter/data/models/barter_action_result_model.dart';
import 'package:craft_chain/features/barter/data/models/barter_chat_model.dart';
import 'package:craft_chain/features/barter/data/models/barter_chat_preview_model.dart';
import 'package:craft_chain/features/barter/data/models/meeting_platform_model.dart';
import 'package:craft_chain/features/barter/data/models/received_barter_request_model.dart';
import 'package:craft_chain/features/barter/data/models/sent_barter_request_model.dart';

abstract class BartersDataSource {
  Future<BarterActionResultModel> sendBarterRequest({
    required String recipientId,
    required int requesterSkillId,
    required int recipientSkillId,
  });

  Future<BarterActionResultModel> acceptBarter(String barterId);
  Future<BarterActionResultModel> rejectBarter(String barterId);
  Future<BarterActionResultModel> cancelBarter(String barterId);

  Future<BarterActionResultModel> proposeMeeting({
    required String barterId,
    required DateTime scheduledAt,
    required String meetingPlatformId,
  });
  Future<BarterActionResultModel> respondToMeetingProposal({
    required String barterId,
    required bool accept,
  });
  Future<BarterActionResultModel> withdrawMeetingProposal(String barterId);

  Future<List<BarterChatPreviewModel>> getActiveBarters();
  Future<List<ReceivedBarterRequestModel>> getReceivedRequests();
  Future<List<SentBarterRequestModel>> getSentRequests();

  Future<BarterChatModel> getBarterChat({
    required String barterId,
    int limit = 50,
    DateTime? before,
  });

  Future<List<MeetingPlatformModel>> getMeetingPlatforms();
}
