import 'package:craft_chain/features/auth/models/app_user.dart';
import 'package:craft_chain/features/profile/model/review.dart';
import 'package:craft_chain/features/profile/viewmodels/profile_cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

export 'profile_state.dart';

// ── Fake current-user ID ──────────────────────────────────────────────────────
// TODO(task-02b): Replace with FirebaseAuth.instance.currentUser!.uid
const kFakeCurrentUserId = 'u1';

// ── Fake profiles ─────────────────────────────────────────────────────────────
// TODO(task-02b): Remove and call ProfileRepository instead.

const _kFakeUsers = <String, AppUser>{
  'u1': AppUser(
    uid: 'u1',
    name: 'Khalid Abdulla',
    city: 'Dubai, UAE',
    gender: 'male',
    bio:
        'Flutter developer with 3 years of experience. I love building clean UIs and want to improve my design skills. Happy to teach Dart, state management, Firebase, and clean architecture.',
    canTeach: ['Flutter', 'Dart', 'Firebase', 'Riverpod'],
    wantsToLearn: ['UI Design', 'Figma', 'Branding'],
    rating: 4.8,
    barterCount: 12,
    isProfileComplete: true,
  ),
  'u2': AppUser(
    uid: 'u2',
    name: 'Mohammed Hassan',
    city: 'Riyadh, KSA',
    gender: 'male',
    bio:
        'Traditional calligrapher turned digital artist. I have been practicing Arabic calligraphy for 10+ years and recently started exploring digital art and painting.',
    canTeach: ['Calligraphy', 'Painting', 'Drawing'],
    wantsToLearn: ['Python', 'Data Science'],
    rating: 4.6,
    barterCount: 8,
    isProfileComplete: true,
  ),
  'u3': AppUser(
    uid: 'u3',
    name: 'Ahmed Al-Rashid',
    city: 'Cairo, EG',
    gender: 'male',
    bio:
        'Full-stack developer with a passion for React and TypeScript. Currently exploring mobile development and looking for a Flutter mentor.',
    canTeach: ['React', 'TypeScript', 'Node.js'],
    wantsToLearn: ['Flutter', 'Dart'],
    rating: 4.4,
    barterCount: 6,
    isProfileComplete: true,
  ),
  'u4': AppUser(
    uid: 'u4',
    name: 'Omar Farouq',
    city: 'Amman, JO',
    gender: 'male',
    bio:
        'Creative director and brand strategist. I help startups define their visual identity. Looking to learn more about digital marketing.',
    canTeach: ['Figma', 'Branding', 'Motion Design'],
    wantsToLearn: ['Marketing', 'SEO'],
    rating: 4.9,
    barterCount: 21,
    isProfileComplete: true,
  ),
  'u5': AppUser(
    uid: 'u5',
    name: 'Yusuf Karim',
    city: 'Casablanca, MA',
    gender: 'male',
    bio:
        'Polyglot with fluency in 4 languages. I teach Spanish, French, and English conversation. Currently learning Mandarin and Arabic.',
    canTeach: ['Spanish', 'French', 'English'],
    wantsToLearn: ['Arabic', 'Chinese'],
    rating: 4.7,
    barterCount: 14,
    isProfileComplete: true,
  ),
};

// ── Fake reviews ──────────────────────────────────────────────────────────────
// TODO(task-02b): Remove and call ProfileRepository instead.

final _kFakeReviews = <String, List<Review>>{
  'u1': [
    Review(
      reviewId: 'r1',
      barterId: 'b1',
      reviewerId: 'u3',
      revieweeId: 'u1',
      reviewerName: 'Ahmed Al-Rashid',
      skillExchanged: 'Flutter',
      rating: 5.0,
      comment:
          'Khalid explained Flutter and Riverpod so clearly. One session saved me weeks!',
      createdAt: DateTime(2025, 11, 10),
    ),
    Review(
      reviewId: 'r2',
      barterId: 'b2',
      reviewerId: 'u4',
      revieweeId: 'u1',
      reviewerName: 'Sara B.',
      skillExchanged: 'Firebase',
      rating: 4.5,
      comment: 'Very patient and knowledgeable. Highly recommend!',
      createdAt: DateTime(2025, 11, 22),
    ),
    Review(
      reviewId: 'r3',
      barterId: 'b3',
      reviewerId: 'u5',
      revieweeId: 'u1',
      reviewerName: 'Bilal K.',
      skillExchanged: 'Dart',
      rating: 4.0,
      comment: 'Great teacher. Streams finally clicked for me.',
      createdAt: DateTime(2025, 12, 5),
    ),
  ],
  'u2': [
    Review(
      reviewId: 'r4',
      barterId: 'b4',
      reviewerId: 'u1',
      revieweeId: 'u2',
      reviewerName: 'Khalid Abdulla',
      skillExchanged: 'Calligraphy',
      rating: 5.0,
      comment:
          'Mohammed is an amazing teacher. My calligraphy improved massively in just two sessions.',
      createdAt: DateTime(2025, 10, 18),
    ),
  ],
  'u3': [],
  'u4': [
    Review(
      reviewId: 'r5',
      barterId: 'b5',
      reviewerId: 'u2',
      revieweeId: 'u4',
      reviewerName: 'Mohammed Hassan',
      skillExchanged: 'Figma',
      rating: 5.0,
      comment: 'Omar transformed how I think about design. Incredible session!',
      createdAt: DateTime(2025, 9, 14),
    ),
    Review(
      reviewId: 'r6',
      barterId: 'b6',
      reviewerId: 'u3',
      revieweeId: 'u4',
      reviewerName: 'Ahmed Al-Rashid',
      skillExchanged: 'Branding',
      rating: 4.5,
      comment:
          'Very structured approach to branding. Learned a lot about visual hierarchy.',
      createdAt: DateTime(2025, 10, 1),
    ),
  ],
  'u5': [],
};

// ── Cubit ─────────────────────────────────────────────────────────────────────

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> loadProfile(String userId) async {
    emit(ProfileLoading());
    // TODO(task-02b): replace with real repository call.
    await Future.delayed(const Duration(milliseconds: 900));
    final user = _kFakeUsers[userId] ?? _kFakeUsers.values.first;
    final reviews = _kFakeReviews[userId] ?? const [];
    emit(ProfileSuccess(user: user, reviews: reviews));
  }

  Future<void> saveProfile({
    required String name,
    required String city,
    required String bio,
    required List<String> canTeach,
    required List<String> wantsToLearn,
    String? photoUrl,
  }) async {
    final current = state;
    if (current is! ProfileSuccess) return;

    emit(current.copyWith(isSaving: true, isSaved: false));
    // TODO(task-02b): replace with real repository call.
    await Future.delayed(const Duration(milliseconds: 1200));

    final updated = current.user.copyWith(
      name: name,
      city: city,
      bio: bio,
      canTeach: canTeach,
      wantsToLearn: wantsToLearn,
      photoUrl: photoUrl,
    );

    emit(
      ProfileSuccess(
        user: updated,
        reviews: current.reviews,
        isSaving: false,
        isSaved: true,
      ),
    );
  }
}
