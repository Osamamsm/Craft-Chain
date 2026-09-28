import 'package:craft_chain/features/matching/data/models/match_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'feed_data_source.dart';

class FeedRemoteDataSourceImpl implements FeedDataSource {
  final SupabaseClient _supabaseClient;
  FeedRemoteDataSourceImpl(this._supabaseClient);

  static const int _pageSize = 10;

  @override
  Future<List<MatchModel>> getMatchingUsers({
    required int page,
    int? categoryId,
  }) async {
    final response = await _supabaseClient.rpc(
      'get_matching_users',
      params: {
        'p_category_id': categoryId,
        'p_limit': _pageSize,
        'p_offset': page * _pageSize,
      },
    );

    return (response as List)
        .map((e) => MatchModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
