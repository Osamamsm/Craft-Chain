import 'package:craft_chain/features/profile/domain/entities/update_profile_params.dart';
import 'package:craft_chain/features/profile/domain/repo/profile_repo.dart';
import 'package:craft_chain/features/profile/presentation/logic/profile_cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _profileRepo;
  ProfileCubit(this._profileRepo) : super(ProfileInitial());

  Future<void> getUserProfile({
    String? userId,
    required bool isOwnProfile,
  }) async {
    emit(ProfileLoading());
    final result = await _profileRepo.getUserProfile(userId: userId);
    result.fold(
      (failure) => emit(ProfileFailure(message: failure.message)),
      (userProfile) => emit(
        ProfileSuccess(
          user: userProfile,
          reviews: [],
          isOwnProfile: isOwnProfile,
        ),
      ),
    );
  }

  Future<void> updateProfile({required UpdateProfileParams params}) async {
    final current = state;
    if (current is! ProfileSuccess || current.isSaving) return;

    // Nothing changed: the edge function would return NO_CHANGES (400).
    if (params.isEmpty) return;

    emit(current.copyWith(isSaving: true, isSaved: false, saveError: null));

    final updateResult = await _profileRepo.updateProfile(params: params);

    await updateResult.fold(
      (failure) async {
        emit(
          current.copyWith(
            isSaving: false,
            isSaved: false,
            saveError: failure.message,
          ),
        );
      },
      (_) async {
        final profileResult = await _profileRepo.getUserProfile(
          userId: current.user.id,
        );

        profileResult.fold(
          // Saved, but the reload failed: keep old data, still report success.
          (_) => emit(
            current.copyWith(isSaving: false, isSaved: true, saveError: null),
          ),
          (fresh) => emit(
            ProfileSuccess(
              user: fresh,
              reviews: current.reviews,
              isOwnProfile: current.isOwnProfile,
              isSaving: false,
              isSaved: true,
            ),
          ),
        );
      },
    );
  }

  Future<bool?> checkIsProfileComplete() async {
    final result = await _profileRepo.isProfileComplete();
    return result.fold((failure) => null, (isComplete) => isComplete);
  }
}
