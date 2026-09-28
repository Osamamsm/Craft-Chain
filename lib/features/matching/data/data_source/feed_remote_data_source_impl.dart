import 'package:craft_chain/features/matching/data/models/match_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'feed_data_source.dart';

class FeedRemoteDataSourceImpl implements FeedDataSource {
  final SupabaseClient _supabaseClient;
  FeedRemoteDataSourceImpl(this._supabaseClient);
  @override
  Future<List<MatchModel>> getMatchingUsers() {
    // TODO: implement getMatchingUsers
    throw UnimplementedError();
  }
}
