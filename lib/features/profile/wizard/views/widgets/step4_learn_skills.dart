import 'package:craft_chain/core/widgets/skill_chip.dart';
import 'package:craft_chain/features/profile/wizard/viewmodels/profile_setup_cubit/profile_setup_cubit.dart';
import 'package:craft_chain/features/profile/wizard/viewmodels/profile_setup_cubit/profile_setup_state.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/skill_selector.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/wizard_step_footer.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/wizard_step_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Step4LearnSkills extends StatelessWidget {
  const Step4LearnSkills({super.key, 
    required this.state,
    required this.searchController,
    required this.searchQuery,
    required this.isWeb,
  });
  final ProfileSetupState state;
  final TextEditingController searchController;
  final String searchQuery;
  final bool isWeb;

  @override
  Widget build(BuildContext context) {
    return WizardStepScaffold(
      titleKey: 'profile.step_4_title',
      subtitleKey: 'profile.step_4_subtitle',
      isWeb: isWeb,
      body: SkillSelector(
        selectedSkills: state.learnSkills,
        type: SkillChipType.learn,
        searchController: searchController,
        searchQuery: searchQuery,
        onToggle: context.read<ProfileSetupCubit>().toggleLearnSkill,
      ),
      footer: WizardStepFooter(
        isValid: state.isStep4Valid,
        isLastStep: false,
        isLoading: false,
        isWeb: isWeb,
      ),
    ).animate().fadeIn(duration: 250.ms);
  }
}
