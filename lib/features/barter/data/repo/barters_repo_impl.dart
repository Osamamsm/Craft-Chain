import 'package:craft_chain/core/error/exception_mapper.dart';
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
  Future<Either<Failure, BarterActionResult>> acceptBarter(
    String barterId,
  ) async {
    try {
      final result = await _bartersDataSource.acceptBarter(barterId);
      return Right(result);
    } catch (e) {
      return Left(ExceptionMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BarterActionResult>> cancelBarter(
    String barterId,
  ) async {
    try {
      final result = await _bartersDataSource.cancelBarter(barterId);
      return Right(result);
    } catch (e) {
      return Left(ExceptionMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<BarterChatPreview>>> getActiveBarters() async {
    try {
      final result = await _bartersDataSource.getActiveBarters();
      return Right(result);
    } catch (e) {
      return Left(ExceptionMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BarterChat>> getBarterChat({
    required String barterId,
    int limit = 50,
    DateTime? before,
  }) async {
    try {
      final result = await _bartersDataSource.getBarterChat(
        barterId: barterId,
        limit: limit,
        before: before,
      );
      return Right(result);
    } catch (e) {
      return Left(ExceptionMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<MeetingPlatform>>> getMeetingPlatforms() async {
    try {
      final result = await _bartersDataSource.getMeetingPlatforms();
      return Right(result);
    } catch (e) {
      return Left(ExceptionMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ReceivedBarterRequest>>>
  getReceivedRequests() async {
    try {
      final result = await _bartersDataSource.getReceivedRequests();
      return Right(result);
    } catch (e) {
      return Left(ExceptionMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<SentBarterRequest>>> getSentRequests() async {
    try {
      final result = await _bartersDataSource.getSentRequests();
      return Right(result);
    } catch (e) {
      return Left(ExceptionMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BarterActionResult>> proposeMeeting({
    required String barterId,
    required DateTime scheduledAt,
    required String meetingPlatformId,
  }) async {
    try {
      final result = await _bartersDataSource.proposeMeeting(
        barterId: barterId,
        scheduledAt: scheduledAt,
        meetingPlatformId: meetingPlatformId,
      );
      return Right(result);
    } catch (e) {
      return Left(ExceptionMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BarterActionResult>> rejectBarter(
    String barterId,
  ) async {
    try {
      final result = await _bartersDataSource.rejectBarter(barterId);
      return Right(result);
    } catch (e) {
      return Left(ExceptionMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BarterActionResult>> respondToMeetingProposal({
    required String barterId,
    required bool accept,
  }) async {
    try {
      final result = await _bartersDataSource.respondToMeetingProposal(
        barterId: barterId,
        accept: accept,
      );
      return Right(result);
    } catch (e) {
      return Left(ExceptionMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BarterActionResult>> sendBarterRequest({
    required String recipientId,
    required int requesterSkillId,
    required int recipientSkillId,
  }) async {
    try {
      final result = await _bartersDataSource.sendBarterRequest(
        recipientId: recipientId,
        requesterSkillId: requesterSkillId,
        recipientSkillId: recipientSkillId,
      );
      return Right(result);
    } catch (e) {
      return Left(ExceptionMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BarterActionResult>> withdrawMeetingProposal(
    String barterId,
  ) async {
    try {
      final result = await _bartersDataSource.withdrawMeetingProposal(barterId);
      return Right(result);
    } catch (e) {
      return Left(ExceptionMapper.mapExceptionToFailure(e));
    }
  }
}
