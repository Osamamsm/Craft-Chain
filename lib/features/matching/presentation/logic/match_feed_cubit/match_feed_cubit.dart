import 'package:craft_chain/features/matching/domain/repo/feed_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'match_feed_state.dart';

class MatchFeedCubit extends Cubit<MatchFeedState> {
  final FeedRepo _feedRepo;
  MatchFeedCubit(this._feedRepo) : super(MatchFeedInitial());

  int? _categoryId;

  Future<void> loadMatches({int? categoryId}) async {
    _categoryId = categoryId;
    emit(MatchFeedLoading());

    final result = await _feedRepo.getMatchingUsers(
      page: 1,
      categoryId: categoryId,
    );

    if (categoryId != _categoryId) return;

    result.fold(
      (failure) => emit(MatchFeedFailure(failure.message)),
      (matches) => emit(
        MatchFeedSuccess(
          matches: matches,
          totalCount: matches.length,
          page: 0,
          selectedCategoryId: categoryId,
        ),
      ),
    );
  }

  void setCategory(int? categoryId) {
    if (categoryId == _categoryId && state is MatchFeedSuccess) return;
    loadMatches(categoryId: categoryId);
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! MatchFeedSuccess ||
        current.isLoadingMore ||
        !current.hasMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));

    final nextPage = current.page + 1;
    final categoryId = _categoryId;
    final result = await _feedRepo.getMatchingUsers(
      page: nextPage,
      categoryId: categoryId,
    );

    if (categoryId != _categoryId) return;

    result.fold(
      (failure) => emit(current.copyWith(isLoadingMore: false)),
      (matches) => emit(
        current.copyWith(
          matches: [...current.matches, ...matches],
          page: nextPage,
          isLoadingMore: false,
        ),
      ),
    );
  }
}
