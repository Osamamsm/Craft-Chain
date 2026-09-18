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

  final ProfileSetupStep currentStep;
  final String name;
  final String? gender;
  final XFile? photoFile;
  final String city;
  final Set<String> teachSkills;
  final Set<String> learnSkills;
  final String bio;
  final bool isLoading;
  final String? errorMessage;
  final bool isComplete;

  int get stepIndex => ProfileSetupStep.values.indexOf(currentStep);
  int get totalSteps => ProfileSetupStep.values.length;
  double get progress => (stepIndex + 1) / totalSteps;

  bool get isStep1Valid =>
      name.trim().length >= 2 &&
      gender != null &&
      photoFile != null &&
      city.trim().isNotEmpty &&
      bio.trim().isNotEmpty;
  bool get isStep2Valid => teachSkills.isNotEmpty;
  bool get isStep3Valid => learnSkills.isNotEmpty;

  bool get isCurrentStepValid {
    switch (currentStep) {
      case ProfileSetupStep.info:
        return isStep1Valid;
      case ProfileSetupStep.teachSkills:
        return isStep2Valid;
      case ProfileSetupStep.learnSkills:
        return isStep3Valid;
    }
  }

  ProfileSetupState copyWith({
    ProfileSetupStep? currentStep,
    String? name,
    String? gender,
    XFile? photoFile,
    bool clearPhoto = false,
    String? city,
    Set<String>? teachSkills,
    Set<String>? learnSkills,
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
