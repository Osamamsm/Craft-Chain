import 'package:craft_chain/features/profile/wizard/view_model/profile_setup_cubit/profile_setup_cubit.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/wizard_form_widgets.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/wizard_tip_box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class ProfileLocationSection extends StatelessWidget {
  const ProfileLocationSection({
    super.key,
    required this.cityController,
    required this.cityFocusNode,
  });

  final TextEditingController cityController;
  final FocusNode cityFocusNode;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileSetupCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardFieldLabel(labelKey: 'profile.city_label'),
        WizardTextField(
          controller: cityController,
          focusNode: cityFocusNode,
          hintText: 'profile.city_hint',
          prefixIcon: Icons.location_on_outlined,
          onChanged: cubit.updateCity,
        ),
        const SizedBox(height: 16),
        const WizardTipBox(
          titleKey: 'profile.city_tip_title',
          bodyKey: 'profile.city_tip_body',
        ),
      ],
    );
  }
}
