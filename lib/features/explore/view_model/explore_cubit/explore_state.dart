import 'package:craft_chain/features/matching/model/models/match_suggestion.dart';

abstract class ExploreState {}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {
  ExploreLoading({required this.query});

  final String query;
}

class ExploreSuccess extends ExploreState {
  ExploreSuccess({required this.results, required this.query});

  final List<MatchSuggestion> results;
  final String query;
}

class ExploreFailure extends ExploreState {
  ExploreFailure({required this.query, required this.message});

  final String query;
  final String message;
}
