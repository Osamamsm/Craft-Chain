import 'dart:io';

import 'package:craft_chain/core/constants/app_skills.dart';
import 'package:craft_chain/features/profile/domain/entities/complete_profile_params.dart';
import 'package:image_picker/image_picker.dart';

enum ProfileSetupStep { info, teachSkills, learnSkills }

class ProfileSetupState {
  const ProfileSetupState({
    this.currentStep = ProfileSetupStep.info,
    this.name = '',
    this.gender,
    this.photoFile,
    this.city = '',
    this.teachSkills = const {},
    this.learnSkills = const {},
    this.bio = '',
    this.isLoading = false,
    this.errorMessage,
    this.isComplete = false,
  });

  // Limits mirror the complete-profile edge function. Reuse them for
  // TextField.maxLength so the user can't exceed what the server accepts.
  static const maxNameLength = 100;
  static const maxCityLength = 100;
  static const maxBioLength = 500;

  final ProfileSetupStep currentStep;
  final String name;
  final String? gender;
  final XFile? photoFile;
  final String city;

  /// Selected skill IDs (UUIDs from the skills table).
  final Set<Skill> teachSkills;
  final Set<Skill> learnSkills;

  final String bio;
  final bool isLoading;
  final String? errorMessage;
  final bool isComplete;

  // ── Progress ───────────────────────────────────────────────────────────────

  int get stepIndex => ProfileSetupStep.values.indexOf(currentStep);
  int get totalSteps => ProfileSetupStep.values.length;
  double get progress => (stepIndex + 1) / totalSteps;

  // ── Validation ─────────────────────────────────────────────────────────────

  bool get isStep1Valid =>
      _lengthBetween(name, 2, maxNameLength) &&
      gender != null &&
      photoFile != null &&
      _lengthBetween(city, 1, maxCityLength) &&
      _lengthBetween(bio, 1, maxBioLength);

  bool get isStep2Valid => teachSkills.isNotEmpty;
  bool get isStep3Valid => learnSkills.isNotEmpty;

  bool get isFormValid => isStep1Valid && isStep2Valid && isStep3Valid;

  bool get isCurrentStepValid => switch (currentStep) {
    ProfileSetupStep.info => isStep1Valid,
    ProfileSetupStep.teachSkills => isStep2Valid,
    ProfileSetupStep.learnSkills => isStep3Valid,
  };

  static bool _lengthBetween(String value, int min, int max) {
    final length = value.trim().length;
    return length >= min && length <= max;
  }

  // ── Mapping ────────────────────────────────────────────────────────────────

  /// Builds the domain params. Only call when [isFormValid] is true.
  CompleteProfileParams toParams() {
    assert(isFormValid, 'toParams() called on an incomplete form');

    return CompleteProfileParams(
      fullName: name.trim(),
      gender: gender!,
      city: city.trim(),
      bio: bio.trim(),
      teachingSkills: _toSkillParams(teachSkills),
      learningSkills: _toSkillParams(learnSkills),
      photo: File(photoFile!.path),
    );
  }

  static List<CompleteProfileSkillParams> _toSkillParams(Set<Skill> skills) =>
      skills.map((skill) => CompleteProfileSkillParams(skillId: skill.id)).toList();

  // ── copyWith ───────────────────────────────────────────────────────────────

  ProfileSetupState copyWith({
    ProfileSetupStep? currentStep,
    String? name,
    String? gender,
    XFile? photoFile,
    bool clearPhoto = false,
    String? city,
    Set<Skill>? teachSkills,
    Set<Skill>? learnSkills,
    String? bio,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? isComplete,
  }) {
    return ProfileSetupState(
      currentStep: currentStep ?? this.currentStep,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      photoFile: clearPhoto ? null : (photoFile ?? this.photoFile),
      city: city ?? this.city,
      teachSkills: teachSkills ?? this.teachSkills,
      learnSkills: learnSkills ?? this.learnSkills,
      bio: bio ?? this.bio,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
