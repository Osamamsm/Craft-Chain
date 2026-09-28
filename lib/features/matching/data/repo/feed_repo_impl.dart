import 'package:craft_chain/core/error/failures.dart';
import 'package:craft_chain/features/matching/data/data_source/feed_data_source.dart';
import 'package:craft_chain/features/matching/domain/entities/match_entity.dart';
import 'package:craft_chain/features/matching/domain/repo/feed_repo.dart';
import 'package:dartz/dartz.dart';

class FeedRepoImpl implements FeedRepo {
  final FeedDataSource _remoteDataSource;
  FeedRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<MatchEntity>>> getMatchingUsers() {
    // TODO: implement getMatchingUsers
    throw UnimplementedError();
  }
}
