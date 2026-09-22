import 'package:craft_chain/features/profile/data/models/review.dart';
import 'package:craft_chain/features/profile/domain/entities/user_profile_entity.dart';

// ── States ────────────────────────────────────────────────────────────────────

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  ProfileSuccess({
    required this.user,
    required this.reviews,
    required this.isOwnProfile,
    this.isSaving = false,
    this.isSaved = false,
  });

  final UserProfileEntity user;
  final List<Review> reviews;
  final bool isOwnProfile;

  /// True while [ProfileCubit.saveProfile] is in progress.
  final bool isSaving;

  /// Flipped to true after a successful save; consumed by BlocListener.
  final bool isSaved;

  ProfileSuccess copyWith({
    UserProfileEntity? user,
    List<Review>? reviews,
    bool? isSaving,
    bool? isSaved,
    bool? isOwnProfile
  }) {
    return ProfileSuccess(
      user: user ?? this.user,
      reviews: reviews ?? this.reviews,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      isOwnProfile: isOwnProfile ?? this.isOwnProfile
    );
  }
}

class ProfileFailure extends ProfileState {
  ProfileFailure({required this.message});

  final String message;
}
