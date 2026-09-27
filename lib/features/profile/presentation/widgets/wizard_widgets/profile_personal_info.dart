import 'package:craft_chain/features/profile/presentation/logic/profile_setup_cubit/profile_setup_cubit.dart';
import 'package:craft_chain/features/profile/presentation/logic/profile_setup_cubit/profile_setup_state.dart';
import 'package:craft_chain/features/profile/presentation/widgets/wizard_widgets/gender_selector.dart';
import 'package:craft_chain/features/profile/presentation/widgets/wizard_widgets/wizard_form_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class ProfilePersonalInfo extends StatelessWidget {
  const ProfilePersonalInfo({
    super.key,
    required this.state,
    required this.nameController,
    required this.nameFocusNode,
  });

  final ProfileSetupState state;
  final TextEditingController nameController;
  final FocusNode nameFocusNode;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileSetupCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardFieldLabel(labelKey: 'profile.full_name_label'),
        WizardTextField(
          controller: nameController,
          focusNode: nameFocusNode,
          hintText: 'profile.full_name_hint',
          prefixIcon: Icons.person_outline_rounded,
          onChanged: cubit.updateName,
        ),
        const SizedBox(height: 16),
        const WizardFieldLabel(labelKey: 'profile.i_am_label'),
        GenderSelector(selected: state.gender, onSelect: cubit.updateGender),
      ],
    );
  }
}
