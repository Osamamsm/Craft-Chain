import 'package:craft_chain/features/profile/presentation/logic/profile_setup_cubit/profile_setup_state.dart';
import 'package:craft_chain/features/profile/presentation/widgets/wizard_widgets/avatar_picker.dart';
import 'package:craft_chain/features/profile/presentation/widgets/wizard_widgets/profile_bio_field.dart';
import 'package:craft_chain/features/profile/presentation/widgets/wizard_widgets/profile_personal_info.dart';
import 'package:craft_chain/features/profile/presentation/widgets/wizard_widgets/profile_preview_card.dart';
import 'package:craft_chain/features/profile/presentation/widgets/wizard_widgets/wizard_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:craft_chain/features/profile/presentation/logic/profile_setup_cubit/profile_setup_cubit.dart';

class ProfileWizardMobileBody extends StatelessWidget {
  const ProfileWizardMobileBody({
    super.key,
    required this.state,
    required this.nameController,
    required this.nameFocusNode,
    required this.cityController,
    required this.cityFocusNode,
    required this.bioController,
    required this.onPickPhoto,
  });

  final ProfileSetupState state;
  final TextEditingController nameController;
  final FocusNode nameFocusNode;
  final TextEditingController cityController;
  final FocusNode cityFocusNode;
  final TextEditingController bioController;
  final VoidCallback onPickPhoto;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileSetupCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),

        // Avatar
        Center(
          child: AvatarPicker(
            photoFile: state.photoFile,
            onTap: onPickPhoto,
            radius: 48,
            showLabel: true,
          ),
        ),

        const SizedBox(height: 20),

        // Gender
        ProfilePersonalInfo(
          state: state,
          nameController: nameController,
          nameFocusNode: nameFocusNode,
        ),

        const SizedBox(height: 14),

        // City
        const WizardFieldLabel(labelKey: 'profile.city_label'),
        WizardTextField(
          controller: cityController,
          focusNode: cityFocusNode,
          hintText: 'profile.city_hint',
          prefixIcon: Icons.location_on_outlined,
          onChanged: cubit.updateCity,
        ),

        const SizedBox(height: 14),

        // Bio
        ProfileBioField(state: state, controller: bioController),

        const SizedBox(height: 8),

        ProfilePreviewCard(state: state),

        const SizedBox(height: 24),
      ],
    );
  }
}
