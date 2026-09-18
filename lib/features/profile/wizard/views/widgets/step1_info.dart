import 'package:craft_chain/features/profile/wizard/view_model/profile_setup_cubit/profile_setup_state.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/profile_wizard_mobile_body.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/profile_wizard_web_body.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/wizard_step_footer.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/wizard_step_scaffold.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_ui/material_ui.dart';

class Step1Info extends StatelessWidget {
  const Step1Info({
    super.key,
    required this.state,
    required this.nameController,
    required this.nameFocusNode,
    required this.cityController,
    required this.cityFocusNode,
    required this.bioController,
    required this.onPickPhoto,
    required this.isWeb,
  });

  final ProfileSetupState state;

  final TextEditingController nameController;
  final FocusNode nameFocusNode;

  final TextEditingController cityController;
  final FocusNode cityFocusNode;

  final TextEditingController bioController;

  final VoidCallback onPickPhoto;

  final bool isWeb;

  @override
  Widget build(BuildContext context) {
    _syncControllers();

    return WizardStepScaffold(
      titleKey: 'profile.step_1_title',
      subtitleKey: 'profile.step_1_subtitle',
      isWeb: isWeb,
      showBack: false,
      body: _buildContent(),
      footer: WizardStepFooter(
        isValid: state.isStep1Valid,
        isLastStep: false,
        isLoading: false,
        isWeb: isWeb,
        showBack: false,
      ),
    ).animate().fadeIn(duration: 250.ms);
  }

  Widget _buildContent() {
    if (isWeb) {
      return ProfileWizardWebBody(
        state: state,
        nameController: nameController,
        nameFocusNode: nameFocusNode,
        cityController: cityController,
        cityFocusNode: cityFocusNode,
        bioController: bioController,
        onPickPhoto: onPickPhoto,
      );
    }

    return ProfileWizardMobileBody(
      state: state,
      nameController: nameController,
      nameFocusNode: nameFocusNode,
      cityController: cityController,
      cityFocusNode: cityFocusNode,
      bioController: bioController,
      onPickPhoto: onPickPhoto,
    );
  }

  void _syncControllers() {
    if (nameController.text != state.name) {
      nameController.text = state.name;
    }

    if (cityController.text != state.city) {
      cityController.text = state.city;
    }

    if (bioController.text != state.bio) {
      bioController.text = state.bio;
    }
  }
}
