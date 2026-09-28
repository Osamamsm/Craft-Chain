import 'package:craft_chain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:craft_chain/features/matching/domain/entities/match_entity.dart';

abstract class FeedRepo {
  Future<Either<Failure, List<MatchEntity>>> getMatchingUsers();
}
