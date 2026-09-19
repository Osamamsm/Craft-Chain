import 'package:craft_chain/core/widgets/skill_chip.dart';
import 'package:craft_chain/features/profile/presentation/logic/profile_setup_cubit/profile_setup_cubit.dart';
import 'package:craft_chain/features/profile/presentation/logic/profile_setup_cubit/profile_setup_state.dart';
import 'package:craft_chain/features/profile/presentation/widgets/wizard_widgets/skill_selector.dart';
import 'package:craft_chain/features/profile/presentation/widgets/wizard_widgets/wizard_step_footer.dart';
import 'package:craft_chain/features/profile/presentation/widgets/wizard_widgets/wizard_step_scaffold.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Step2TeachSkills extends StatelessWidget {
  const Step2TeachSkills({
    super.key,
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
      titleKey: 'profile.step_2_title',
      subtitleKey: 'profile.step_2_subtitle',
      isWeb: isWeb,
      body: SkillSelector(
        selectedSkills: state.teachSkills,
        type: SkillChipType.teach,
        searchController: searchController,
        searchQuery: searchQuery,
        onToggle: context.read<ProfileSetupCubit>().toggleTeachSkill,
      ),
      footer: WizardStepFooter(
        isValid: state.isStep2Valid,
        isLastStep: false,
        isLoading: false,
        isWeb: isWeb,
      ),
    ).animate().fadeIn(duration: 250.ms);
  }
}
