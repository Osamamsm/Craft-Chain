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
    this.saveError,
  });

  final UserProfileEntity user;
  final List<Review> reviews;
  final bool isOwnProfile;
  final bool isSaving;
  final bool isSaved;
  final String? saveError;

  ProfileSuccess copyWith({
    UserProfileEntity? user,
    List<Review>? reviews,
    bool? isSaving,
    bool? isSaved,
    bool? isOwnProfile,
    Object? saveError = _unset,
  }) {
    return ProfileSuccess(
      user: user ?? this.user,
      reviews: reviews ?? this.reviews,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      isOwnProfile: isOwnProfile ?? this.isOwnProfile,
      saveError: identical(saveError, _unset)
          ? this.saveError
          : saveError as String?,
    );
  }
}

const _unset = Object();

class ProfileFailure extends ProfileState {
  ProfileFailure({required this.message});

  final String message;
}
