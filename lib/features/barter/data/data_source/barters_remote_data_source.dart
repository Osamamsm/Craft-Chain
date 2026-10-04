import 'package:craft_chain/features/barter/data/data_source/barters_data_source.dart';
import 'package:craft_chain/features/barter/data/models/barter_action_result_model.dart';
import 'package:craft_chain/features/barter/data/models/barter_chat_model.dart';
import 'package:craft_chain/features/barter/data/models/barter_chat_preview_model.dart';
import 'package:craft_chain/features/barter/data/models/meeting_platform_model.dart';
import 'package:craft_chain/features/barter/data/models/received_barter_request_model.dart';
import 'package:craft_chain/features/barter/data/models/sent_barter_request_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BartersRemoteDataSource implements BartersDataSource {
  final SupabaseClient _supabaseClient;

  BartersRemoteDataSource(this._supabaseClient);
  @override
  Future<BarterActionResultModel> acceptBarter(String barterId) {
    // TODO: implement acceptBarter
    throw UnimplementedError();
  }

  @override
  Future<BarterActionResultModel> cancelBarter(String barterId) {
    // TODO: implement cancelBarter
    throw UnimplementedError();
  }

  @override
  Future<List<BarterChatPreviewModel>> getActiveBarters() {
    // TODO: implement getActiveBarters
    throw UnimplementedError();
  }

  @override
  Future<BarterChatModel> getBarterChat({
    required String barterId,
    int limit = 50,
    DateTime? before,
  }) {
    // TODO: implement getBarterChat
    throw UnimplementedError();
  }

  @override
  Future<List<MeetingPlatformModel>> getMeetingPlatforms() {
    // TODO: implement getMeetingPlatforms
    throw UnimplementedError();
  }

  @override
  Future<List<ReceivedBarterRequestModel>> getReceivedRequests() {
    // TODO: implement getReceivedRequests
    throw UnimplementedError();
  }

  @override
  Future<List<SentBarterRequestModel>> getSentRequests() {
    // TODO: implement getSentRequests
    throw UnimplementedError();
  }

  @override
  Future<BarterActionResultModel> proposeMeeting({
    required String barterId,
    required DateTime scheduledAt,
    required String meetingPlatformId,
  }) {
    // TODO: implement proposeMeeting
    throw UnimplementedError();
  }

  @override
  Future<BarterActionResultModel> rejectBarter(String barterId) {
    // TODO: implement rejectBarter
    throw UnimplementedError();
  }

  @override
  Future<BarterActionResultModel> respondToMeetingProposal({
    required String barterId,
    required bool accept,
  }) {
    // TODO: implement respondToMeetingProposal
    throw UnimplementedError();
  }

  @override
  Future<BarterActionResultModel> sendBarterRequest({
    required String recipientId,
    required int requesterSkillId,
    required int recipientSkillId,
  }) {
    // TODO: implement sendBarterRequest
    throw UnimplementedError();
  }

  @override
  Future<BarterActionResultModel> withdrawMeetingProposal(String barterId) {
    // TODO: implement withdrawMeetingProposal
    throw UnimplementedError();
  }
}
