import 'package:craft_chain/core/constants/app_skills.dart';
import 'package:craft_chain/features/profile/domain/repo/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'profile_setup_state.dart';

class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  ProfileSetupCubit(this._repo) : super(const ProfileSetupState());

  final ProfileRepo _repo;

  // ── Info step ──────────────────────────────────────────────────────────────

  void updateName(String name) => _edit((s) => s.copyWith(name: name));

  void updateGender(String gender) => _edit((s) => s.copyWith(gender: gender));

  void updatePhoto(XFile? photo) =>
      _edit((s) => s.copyWith(photoFile: photo, clearPhoto: photo == null));

  void updateCity(String city) => _edit((s) => s.copyWith(city: city));

  void updateBio(String bio) => _edit((s) => s.copyWith(bio: bio));

  // ── Skills steps ───────────────────────────────────────────────────────────

  void toggleTeachSkill(Skill skill) =>
      _edit((s) => s.copyWith(teachSkills: _toggled(s.teachSkills, skill)));

  void toggleLearnSkill(Skill skill) =>
      _edit((s) => s.copyWith(learnSkills: _toggled(s.learnSkills, skill)));

  // ── Navigation ─────────────────────────────────────────────────────────────

  void nextStep() {
    if (!state.isCurrentStepValid) return;
    _goToStep(state.stepIndex + 1);
  }

  void previousStep() => _goToStep(state.stepIndex - 1);

  // ── Submit ─────────────────────────────────────────────────────────────────

  Future<void> completeProfile() async {
    if (state.isLoading || !state.isFormValid) return;

    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _repo.completeProfile(params: state.toParams());

    if (isClosed) return;

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isLoading: false, isComplete: true)),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Applies [change] to the current state and clears any previous error.
  void _edit(ProfileSetupState Function(ProfileSetupState s) change) =>
      emit(change(state).copyWith(clearError: true));

  void _goToStep(int index) {
    if (index < 0 || index >= ProfileSetupStep.values.length) return;
    _edit((s) => s.copyWith(currentStep: ProfileSetupStep.values[index]));
  }

  /// Returns a new set with [item] added if missing, removed if present.
  Set<Skill> _toggled(Set<Skill> source, Skill skill) {
    final result = {...source};
    if (!result.remove(skill)) result.add(skill);
    return result;
  }
}
