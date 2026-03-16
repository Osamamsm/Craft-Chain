import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'profile_setup_state.dart';

// TODO(task-02b): Swap fake logic for real repository once ProfileRepositoryImpl is built.

@injectable
class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  ProfileSetupCubit() : super(const ProfileSetupState());

  // ── Step 1 ─────────────────────────────────────────────────────────────────

  void updateName(String name) =>
      emit(state.copyWith(name: name, clearError: true));

  void updateGender(String gender) =>
      emit(state.copyWith(gender: gender, clearError: true));

  // ── Step 2 ─────────────────────────────────────────────────────────────────

  void updatePhoto(XFile? photo) =>
      emit(state.copyWith(photoFile: photo, clearError: true));

  void updateCity(String city) =>
      emit(state.copyWith(city: city, clearError: true));

  // ── Step 3 ─────────────────────────────────────────────────────────────────

  void toggleTeachSkill(String skill) {
    final updated = Set<String>.from(state.teachSkills);
    if (updated.contains(skill)) {
      updated.remove(skill);
    } else {
      updated.add(skill);
    }
    emit(state.copyWith(teachSkills: updated, clearError: true));
  }

  // ── Step 4 ─────────────────────────────────────────────────────────────────

  void toggleLearnSkill(String skill) {
    final updated = Set<String>.from(state.learnSkills);
    if (updated.contains(skill)) {
      updated.remove(skill);
    } else {
      updated.add(skill);
    }
    emit(state.copyWith(learnSkills: updated, clearError: true));
  }

  // ── Step 5 ─────────────────────────────────────────────────────────────────

  void updateBio(String bio) =>
      emit(state.copyWith(bio: bio, clearError: true));


  void nextStep() {
    if (!state.isCurrentStepValid) return;
    final index = state.stepIndex;
    if (index < ProfileSetupStep.values.length - 1) {
      emit(
        state.copyWith(
          currentStep: ProfileSetupStep.values[index + 1],
          clearError: true,
        ),
      );
    }
  }

  void previousStep() {
    final index = state.stepIndex;
    if (index > 0) {
      emit(
        state.copyWith(
          currentStep: ProfileSetupStep.values[index - 1],
          clearError: true,
        ),
      );
    }
  }

  Future<void> completeProfile() async {
    if (!state.isStep5Valid) return;

    emit(state.copyWith(isLoading: true, clearError: true));

    await Future.delayed(const Duration(milliseconds: 1500));

    emit(state.copyWith(isLoading: false, isComplete: true));
  }
}
