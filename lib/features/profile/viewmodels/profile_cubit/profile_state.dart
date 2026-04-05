import 'package:craft_chain/features/auth/models/app_user.dart';
import 'package:craft_chain/features/profile/model/review.dart';

// ── States ────────────────────────────────────────────────────────────────────

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  ProfileSuccess({
    required this.user,
    required this.reviews,
    this.isSaving = false,
    this.isSaved = false,
  });

  final AppUser user;
  final List<Review> reviews;

  /// True while [ProfileCubit.saveProfile] is in progress.
  final bool isSaving;

  /// Flipped to true after a successful save; consumed by BlocListener.
  final bool isSaved;

  ProfileSuccess copyWith({
    AppUser? user,
    List<Review>? reviews,
    bool? isSaving,
    bool? isSaved,
  }) {
    return ProfileSuccess(
      user: user ?? this.user,
      reviews: reviews ?? this.reviews,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

class ProfileFailure extends ProfileState {
  ProfileFailure(this.message);

  /// Translation key for the error message.
  final String message;
}
