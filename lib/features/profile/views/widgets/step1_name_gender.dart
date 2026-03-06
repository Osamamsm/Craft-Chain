import 'package:craft_chain/features/profile/viewmodels/profile_setup_cubit/profile_setup_cubit.dart';
import 'package:craft_chain/features/profile/viewmodels/profile_setup_cubit/profile_setup_state.dart';
import 'package:craft_chain/features/profile/views/widgets/gender_selector.dart';
import 'package:craft_chain/features/profile/views/widgets/wizard_form_widgets.dart';
import 'package:craft_chain/features/profile/views/widgets/wizard_step_footer.dart';
import 'package:craft_chain/features/profile/views/widgets/wizard_step_scaffold.dart';
import 'package:craft_chain/features/profile/views/widgets/wizard_tip_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Step1NameGender extends StatelessWidget {
  const Step1NameGender({
    super.key,
    required this.state,
    required this.nameController,
    required this.nameFocusNode,
    required this.isWeb,
  });

  final ProfileSetupState state;
  final TextEditingController nameController;
  final FocusNode nameFocusNode;
  final bool isWeb;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileSetupCubit>();

    if (nameController.text != state.name) {
      nameController.text = state.name;
    }

    Widget bodyContent;

    if (isWeb) {
      bodyContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WizardFieldLabel(labelKey: 'profile.full_name_label'),
                    WizardTextField(
                      controller: nameController,
                      focusNode: nameFocusNode,
                      hintText: 'profile.full_name_hint',
                      prefixIcon: Icons.person_outline_rounded,
                      onChanged: cubit.updateName,
                    ),
                    const SizedBox(height: 16),
                    WizardFieldLabel(labelKey: 'profile.i_am_label'),
                    GenderSelector(
                      selected: state.gender,
                      onSelect: cubit.updateGender,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
            ],
          ),
          const SizedBox(height: 20),
          const WizardTipBox(
            titleKey: 'profile.gender_tip_title',
            bodyKey: 'profile.gender_tip_body',
          ),
          const SizedBox(height: 28),
        ],
      );
    } else {
      bodyContent = Column(
        children: [
          const SizedBox(height: 24),
          WizardFieldLabel(labelKey: 'profile.full_name_label'),
          WizardTextField(
            controller: nameController,
            focusNode: nameFocusNode,
            hintText: 'profile.full_name_hint',
            prefixIcon: Icons.person_outline_rounded,
            onChanged: cubit.updateName,
          ),
          const SizedBox(height: 16),
          WizardFieldLabel(labelKey: 'profile.i_am_label'),
          GenderSelector(selected: state.gender, onSelect: cubit.updateGender),
          const SizedBox(height: 16),
          const WizardTipBox(
            titleKey: 'profile.gender_tip_title',
            bodyKey: 'profile.gender_tip_body',
          ),
          const SizedBox(height: 24),
        ],
      );
    }

    return WizardStepScaffold(
      titleKey: 'profile.step_1_title',
      subtitleKey: 'profile.step_1_subtitle',
      isWeb: isWeb,
      showBack: false,
      body: bodyContent,
      footer: WizardStepFooter(
        isValid: state.isStep1Valid,
        isLastStep: false,
        isLoading: false,
        isWeb: isWeb,
        showBack: false,
      ),
    ).animate().fadeIn(duration: 250.ms);
  }
}
