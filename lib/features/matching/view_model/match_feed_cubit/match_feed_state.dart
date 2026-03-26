// ── Filter enum ───────────────────────────────────────────────────────────────

import 'package:craft_chain/features/matching/model/models/match_suggestion.dart';

enum MatchFeedFilter { all, tech, design, languages, crafts, business }

extension MatchFeedFilterX on MatchFeedFilter {
  String get labelKey => switch (this) {
    MatchFeedFilter.all => 'match.filter_all',
    MatchFeedFilter.tech => 'match.filter_tech',
    MatchFeedFilter.design => 'match.filter_design',
    MatchFeedFilter.languages => 'match.filter_languages',
    MatchFeedFilter.crafts => 'match.filter_crafts',
    MatchFeedFilter.business => 'match.filter_business',
  };
}

// ── States ────────────────────────────────────────────────────────────────────

abstract class MatchFeedState {}

class MatchFeedInitial extends MatchFeedState {}

class MatchFeedLoading extends MatchFeedState {}

class MatchFeedSuccess extends MatchFeedState {
  MatchFeedSuccess({
    required this.matches,
    this.selectedFilter = MatchFeedFilter.all,
  });

  final List<MatchSuggestion> matches;
  final MatchFeedFilter selectedFilter;
}

class MatchFeedFailure extends MatchFeedState {
  MatchFeedFailure(this.message);

  /// Translation key for the error message.
  final String message;
}
