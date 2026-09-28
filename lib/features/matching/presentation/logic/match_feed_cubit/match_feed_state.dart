import 'package:craft_chain/features/matching/domain/entities/match_entity.dart';

abstract class MatchFeedState {}

class MatchFeedInitial extends MatchFeedState {}

class MatchFeedLoading extends MatchFeedState {}

class MatchFeedSuccess extends MatchFeedState {
  MatchFeedSuccess({
    required this.matches,
    required this.totalCount,
    this.page = 1,
    this.selectedCategoryId,
    this.isLoadingMore = false,
  });

  final List<MatchEntity> matches;
  final int totalCount;
  final int page;
  final int? selectedCategoryId;
  final bool isLoadingMore;

  bool get hasMore => matches.length < totalCount;

  MatchFeedSuccess copyWith({
    List<MatchEntity>? matches,
    int? totalCount,
    int? page,
    bool? isLoadingMore,
  }) => MatchFeedSuccess(
    matches: matches ?? this.matches,
    totalCount: totalCount ?? this.totalCount,
    page: page ?? this.page,
    selectedCategoryId: selectedCategoryId,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}

class MatchFeedFailure extends MatchFeedState {
  MatchFeedFailure(this.message);

  final String message;
}
