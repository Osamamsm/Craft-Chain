import 'dart:async';

import 'package:craft_chain/features/explore/view_model/explore_cubit/explore_state.dart';
import 'package:craft_chain/features/matching/model/models/match_suggestion.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// ── Fake data (UI-only) ───────────────────────────────────────────────────────
// TODO: remove this and call the real ExploreRepository once it's implemented.

const _kFakeUsers = <MatchSuggestion>[
  MatchSuggestion(
    userId: 'e1',
    name: 'Khalid Abdullah',
    city: 'Dubai, UAE',
    canTeach: ['Flutter', 'Dart', 'Firebase'],
    wantsToLearn: ['Figma', 'UI Design'],
    matchScore: 0,
    rating: 4.9,
    barterCount: 21,
  ),
  MatchSuggestion(
    userId: 'e2',
    name: 'Omar Farouq',
    city: 'Amman, JO',
    canTeach: ['Figma', 'Branding', 'Motion Design'],
    wantsToLearn: ['Marketing', 'SEO'],
    matchScore: 0,
    rating: 4.8,
    barterCount: 18,
  ),
  MatchSuggestion(
    userId: 'e3',
    name: 'Yusuf Karim',
    city: 'Casablanca, MA',
    canTeach: ['Spanish', 'French', 'English'],
    wantsToLearn: ['Arabic', 'Chinese'],
    matchScore: 0,
    rating: 4.7,
    barterCount: 14,
  ),
  MatchSuggestion(
    userId: 'e4',
    name: 'Mohammed Hassan',
    city: 'Riyadh, KSA',
    canTeach: ['Calligraphy', 'Painting', 'Drawing'],
    wantsToLearn: ['Python', 'Data Science'],
    matchScore: 0,
    rating: 4.6,
    barterCount: 9,
  ),
  MatchSuggestion(
    userId: 'e5',
    name: 'Tariq Mansour',
    city: 'Beirut, LB',
    canTeach: ['Photography', 'Video Editing', 'Podcasting'],
    wantsToLearn: ['Flutter', 'Firebase'],
    matchScore: 0,
    rating: 4.5,
    barterCount: 12,
  ),
  MatchSuggestion(
    userId: 'e6',
    name: 'Nasser Khalil',
    city: 'Baghdad, IQ',
    canTeach: ['Music Theory', 'Animation'],
    wantsToLearn: ['Project Management', 'Finance'],
    matchScore: 0,
    rating: 4.4,
    barterCount: 7,
  ),
  MatchSuggestion(
    userId: 'e7',
    name: 'Ahmed Al-Rashid',
    city: 'Cairo, EG',
    canTeach: ['React', 'TypeScript', 'Node.js'],
    wantsToLearn: ['Flutter', 'Dart'],
    matchScore: 0,
    rating: 4.3,
    barterCount: 5,
  ),
  MatchSuggestion(
    userId: 'e8',
    name: 'Bilal Tahir',
    city: 'Karachi, PK',
    canTeach: ['Python', 'ML / AI', 'Data Science'],
    wantsToLearn: ['Entrepreneurship', 'Public Speaking'],
    matchScore: 0,
    rating: 4.2,
    barterCount: 6,
  ),
  MatchSuggestion(
    userId: 'e9',
    name: 'Saad Al-Zahrani',
    city: 'Jeddah, KSA',
    canTeach: ['Marketing', 'Copywriting', 'Sales'],
    wantsToLearn: ['React', 'TypeScript'],
    matchScore: 0,
    rating: 4.1,
    barterCount: 3,
  ),
  MatchSuggestion(
    userId: 'e10',
    name: 'Hamza Al-Emrani',
    city: 'Tunis, TN',
    canTeach: ['Illustrator', 'Photoshop', '3D Modeling'],
    wantsToLearn: ['English', 'Spanish'],
    matchScore: 0,
    rating: 3.9,
    barterCount: 2,
  ),
  MatchSuggestion(
    userId: 'e11',
    name: 'Faisal Al-Otaibi',
    city: 'Kuwait City, KW',
    canTeach: ['Entrepreneurship', 'Public Speaking', 'Finance'],
    wantsToLearn: ['Python', 'Data Science'],
    matchScore: 0,
    rating: 4.7,
    barterCount: 16,
  ),
  MatchSuggestion(
    userId: 'e12',
    name: 'Rami Aziz',
    city: 'Alexandria, EG',
    canTeach: ['SEO', 'Content Writing', 'Social Media'],
    wantsToLearn: ['Figma', 'UI Design'],
    matchScore: 0,
    rating: 4.0,
    barterCount: 4,
  ),
];

// ── Cubit ─────────────────────────────────────────────────────────────────────

@injectable
class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit() : super(ExploreInitial());

  static const _kDebounce = Duration(milliseconds: 300);

  Timer? _debounceTimer;


  void onQueryChanged(String query) {
    _debounceTimer?.cancel();

    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      emit(ExploreInitial());
      return;
    }

    emit(ExploreLoading(query: trimmed));

    _debounceTimer = Timer(_kDebounce, () => _runSearch(trimmed));
  }

  void clear() {
    _debounceTimer?.cancel();
    emit(ExploreInitial());
  }

  Future<void> _runSearch(String query) async {
    // TODO: replace with real repository call when Firestore is connected.
    // The real implementation must include .where('gender', isEqualTo: ...)
    // at the query level — never filter in Dart after fetching.
    await Future.delayed(const Duration(milliseconds: 700));

    if (isClosed) return;

    final q = query.toLowerCase();
    final results = _kFakeUsers.where((u) {
      return u.name.toLowerCase().contains(q) ||
          u.canTeach.any((s) => s.toLowerCase().contains(q)) ||
          u.wantsToLearn.any((s) => s.toLowerCase().contains(q));
    }).toList()
      // Results ordered by rating descending, per spec.
      ..sort((a, b) => b.rating.compareTo(a.rating));

    emit(ExploreSuccess(results: results, query: query));
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
