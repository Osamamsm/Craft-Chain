import 'package:craft_chain/features/barter/data/data_source/barters_data_source.dart';
import 'package:craft_chain/features/barter/data/models/barter_action_result_model.dart';
import 'package:craft_chain/features/barter/data/models/barter_chat_model.dart';
import 'package:craft_chain/features/barter/data/models/barter_chat_preview_model.dart';
import 'package:craft_chain/features/barter/data/models/meeting_platform_model.dart';
import 'package:craft_chain/features/barter/data/models/received_barter_request_model.dart';
import 'package:craft_chain/features/barter/data/models/sent_barter_request_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BartersRemoteDataSource implements BartersDataSource {
  BartersRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<BarterActionResultModel> sendBarterRequest({
    required String recipientId,
    required int requesterSkillId,
    required int recipientSkillId,
  }) async {
    final response = await _client.rpc(
      'send_barter_request',
      params: {
        'p_recipient_id': recipientId,
        'p_requester_skill_id': requesterSkillId,
        'p_recipient_skill_id': recipientSkillId,
      },
    );
    return BarterActionResultModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<BarterActionResultModel> acceptBarter(String barterId) async {
    final response = await _client.rpc(
      'accept_barter',
      params: {'p_barter_id': barterId},
    );
    return BarterActionResultModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<BarterActionResultModel> rejectBarter(String barterId) async {
    final response = await _client.rpc(
      'reject_barter',
      params: {'p_barter_id': barterId},
    );
    return BarterActionResultModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<BarterActionResultModel> cancelBarter(String barterId) async {
    final response = await _client.rpc(
      'cancel_barter',
      params: {'p_barter_id': barterId},
    );
    return BarterActionResultModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<BarterActionResultModel> proposeMeeting({
    required String barterId,
    required DateTime scheduledAt,
    required String meetingPlatformId,
  }) async {
    final response = await _client.rpc(
      'propose_barter_meeting',
      params: {
        'p_barter_id': barterId,
        'p_scheduled_at': scheduledAt.toUtc().toIso8601String(),
        'p_meeting_platform_id': meetingPlatformId,
      },
    );
    return BarterActionResultModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<BarterActionResultModel> respondToMeetingProposal({
    required String barterId,
    required bool accept,
  }) async {
    final response = await _client.rpc(
      'respond_to_meeting_proposal',
      params: {'p_barter_id': barterId, 'p_accept': accept},
    );
    return BarterActionResultModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<BarterActionResultModel> withdrawMeetingProposal(
    String barterId,
  ) async {
    final response = await _client.rpc(
      'withdraw_meeting_proposal',
      params: {'p_barter_id': barterId},
    );
    return BarterActionResultModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<List<BarterChatPreviewModel>> getActiveBarters() async {
    final response = await _client.rpc('get_active_barters');
    return (response as List)
        .map((e) => BarterChatPreviewModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ReceivedBarterRequestModel>> getReceivedRequests() async {
    final response = await _client.rpc('get_received_barter_requests');
    return (response as List)
        .map(
          (e) => ReceivedBarterRequestModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<List<SentBarterRequestModel>> getSentRequests() async {
    final response = await _client.rpc('get_sent_barter_requests');
    return (response as List)
        .map((e) => SentBarterRequestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<BarterChatModel> getBarterChat({
    required String barterId,
    int limit = 50,
    DateTime? before,
  }) async {
    final response = await _client.rpc(
      'get_barter_chat',
      params: {
        'p_barter_id': barterId,
        'p_limit': limit,
        if (before != null) 'p_before': before.toUtc().toIso8601String(),
      },
    );
    return BarterChatModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<List<MeetingPlatformModel>> getMeetingPlatforms() async {
    final response = await _client
        .from('meeting_platforms')
        .select()
        .eq('is_active', true)
        .order('sort_order');
    return response.map(MeetingPlatformModel.fromJson).toList();
  }
}
