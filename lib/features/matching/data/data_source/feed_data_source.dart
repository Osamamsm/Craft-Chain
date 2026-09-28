import 'package:craft_chain/features/matching/data/models/match_model.dart';

abstract class FeedDataSource {
  Future<List<MatchModel>> getMatchingUsers();
}
