import 'package:craft_chain/features/matching/model/models/match_suggestion.dart';
import 'package:craft_chain/features/matching/view_model/match_feed_cubit/match_feed_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// ── Fake data (UI-only) ───────────────────────────────────────────────────────
// TODO: remove this and call the real repository once it's implemented.

const _kFakeMatches = <MatchSuggestion>[
  MatchSuggestion(
    userId: 'u1',
    name: 'Khalid Abdullah',
    city: 'Dubai, UAE',
    canTeach: ['Flutter', 'Dart', 'Firebase'],
    wantsToLearn: ['Figma', 'UI Design'],
    matchScore: 94,
    rating: 4.8,
    barterCount: 12,
  ),
  MatchSuggestion(
    userId: 'u2',
    name: 'Mohammed Hassan',
    city: 'Riyadh, KSA',
    canTeach: ['Calligraphy', 'Painting', 'Drawing'],
    wantsToLearn: ['Python', 'Data Science'],
    matchScore: 87,
    rating: 4.6,
    barterCount: 8,
  ),
  MatchSuggestion(
    userId: 'u3',
    name: 'Ahmed Al-Rashid',
    city: 'Cairo, EG',
    canTeach: ['React', 'TypeScript', 'Node.js'],
    wantsToLearn: ['Flutter', 'Dart'],
    matchScore: 83,
    rating: 4.4,
    barterCount: 6,
  ),
  MatchSuggestion(
    userId: 'u4',
    name: 'Omar Farouq',
    city: 'Amman, JO',
    canTeach: ['Figma', 'Branding', 'Motion Design'],
    wantsToLearn: ['Marketing', 'SEO'],
    matchScore: 79,
    rating: 4.9,
    barterCount: 21,
  ),
  MatchSuggestion(
    userId: 'u5',
    name: 'Yusuf Karim',
    city: 'Casablanca, MA',
    canTeach: ['Spanish', 'French', 'English'],
    wantsToLearn: ['Arabic', 'Chinese'],
    matchScore: 76,
    rating: 4.7,
    barterCount: 14,
  ),
  MatchSuggestion(
    userId: 'u6',
    name: 'Bilal Tahir',
    city: 'Karachi, PK',
    canTeach: ['Python', 'ML / AI', 'Data Science'],
    wantsToLearn: ['Entrepreneurship', 'Public Speaking'],
    matchScore: 72,
    rating: 4.1,
    barterCount: 4,
  ),
  MatchSuggestion(
    userId: 'u7',
    name: 'Tariq Mansour',
    city: 'Beirut, LB',
    canTeach: ['Photography', 'Video Editing', 'Podcasting'],
    wantsToLearn: ['Flutter', 'Firebase'],
    matchScore: 68,
    rating: 4.3,
    barterCount: 7,
  ),
  MatchSuggestion(
    userId: 'u8',
    name: 'Saad Al-Zahrani',
    city: 'Jeddah, KSA',
    canTeach: ['Marketing', 'Copywriting', 'Sales'],
    wantsToLearn: ['React', 'TypeScript'],
    matchScore: 65,
    rating: 4.0,
    barterCount: 3,
  ),
  MatchSuggestion(
    userId: 'u9',
    name: 'Nasser Khalil',
    city: 'Baghdad, IQ',
    canTeach: ['Music', 'Animation'],
    wantsToLearn: ['Project Management', 'Finance'],
    matchScore: 62,
    rating: 4.5,
    barterCount: 9,
  ),
  MatchSuggestion(
    userId: 'u10',
    name: 'Hamza Al-Emrani',
    city: 'Tunis, TN',
    canTeach: ['Illustrator', 'Photoshop', '3D Modeling'],
    wantsToLearn: ['English', 'Spanish'],
    matchScore: 58,
    rating: 3.9,
    barterCount: 2,
  ),
];

// ── Category → skills mapping (mirrors AppSkills) ─────────────────────────────

const _kCategorySkills = <MatchFeedFilter, List<String>>{
  MatchFeedFilter.tech: [
    'Flutter', 'Dart', 'Firebase', 'React', 'Node.js', 'Python',
    'Swift', 'Kotlin', 'ML / AI', 'Data Science', 'UI/UX',
    'TypeScript', 'Vue.js',
  ],
  MatchFeedFilter.design: [
    'Figma', 'Illustrator', 'Photoshop', 'Branding',
    '3D Modeling', 'Motion Design', 'Sketch', 'After Effects',
  ],
  MatchFeedFilter.crafts: [
    'Calligraphy', 'Photography', 'Video Editing', 'Music',
    'Drawing', 'Animation', 'Painting', 'Podcasting',
  ],
  MatchFeedFilter.languages: [
    'English', 'Arabic', 'French', 'Spanish',
    'German', 'Chinese', 'Italian', 'Japanese',
  ],
  MatchFeedFilter.business: [
    'Marketing', 'SEO', 'Copywriting', 'Project Management',
    'Entrepreneurship', 'Finance', 'Public Speaking', 'Sales',
  ],
};

// ── Cubit ─────────────────────────────────────────────────────────────────────
@injectable
class MatchFeedCubit extends Cubit<MatchFeedState> {
  MatchFeedCubit() : super(MatchFeedInitial());

  Future<void> loadMatches() async {
    emit(MatchFeedLoading());
    // TODO: replace with real repository call.
    await Future.delayed(const Duration(milliseconds: 900));
    emit(MatchFeedSuccess(matches: _kFakeMatches));
  }

  void setFilter(MatchFeedFilter filter) {
    final filtered = filter == MatchFeedFilter.all
        ? _kFakeMatches
        : _kFakeMatches.where((s) {
            final skills = _kCategorySkills[filter] ?? const [];
            return s.canTeach.any(skills.contains) ||
                s.wantsToLearn.any(skills.contains);
          }).toList();

    emit(MatchFeedSuccess(matches: filtered, selectedFilter: filter));
  }
}
