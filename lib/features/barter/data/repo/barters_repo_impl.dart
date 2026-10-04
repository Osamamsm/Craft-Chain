import 'package:craft_chain/core/error/failures.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_action_result.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_chat.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_chat_preview.dart';
import 'package:craft_chain/features/barter/domain/entities/meeting_platform.dart';
import 'package:craft_chain/features/barter/domain/entities/received_barter_request.dart';
import 'package:craft_chain/features/barter/domain/entities/sent_barter_request.dart';
import 'package:craft_chain/features/barter/domain/repo/barters_repo.dart';
import 'package:dartz/dartz.dart';
import '../data_source/barters_data_source.dart';

class BartersRepoImpl implements BartersRepo {
  final BartersDataSource _bartersDataSource;

  BartersRepoImpl(this._bartersDataSource);
  @override
  Future<Either<Failure, BarterActionResult>> acceptBarter(String barterId) {
    // TODO: implement acceptBarter
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, BarterActionResult>> cancelBarter(String barterId) {
    // TODO: implement cancelBarter
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<BarterChatPreview>>> getActiveBarters() {
    // TODO: implement getActiveBarters
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, BarterChat>> getBarterChat({
    required String barterId,
    int limit = 50,
    DateTime? before,
  }) {
    // TODO: implement getBarterChat
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<MeetingPlatform>>> getMeetingPlatforms() {
    // TODO: implement getMeetingPlatforms
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ReceivedBarterRequest>>> getReceivedRequests() {
    // TODO: implement getReceivedRequests
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SentBarterRequest>>> getSentRequests() {
    // TODO: implement getSentRequests
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, BarterActionResult>> proposeMeeting({
    required String barterId,
    required DateTime scheduledAt,
    required String meetingPlatformId,
  }) {
    // TODO: implement proposeMeeting
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, BarterActionResult>> rejectBarter(String barterId) {
    // TODO: implement rejectBarter
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, BarterActionResult>> respondToMeetingProposal({
    required String barterId,
    required bool accept,
  }) {
    // TODO: implement respondToMeetingProposal
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, BarterActionResult>> sendBarterRequest({
    required String recipientId,
    required int requesterSkillId,
    required int recipientSkillId,
  }) {
    // TODO: implement sendBarterRequest
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, BarterActionResult>> withdrawMeetingProposal(
    String barterId,
  ) {
    // TODO: implement withdrawMeetingProposal
    throw UnimplementedError();
  }
}
