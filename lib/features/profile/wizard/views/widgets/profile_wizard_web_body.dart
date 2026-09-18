import 'package:craft_chain/features/profile/wizard/view_model/profile_setup_cubit/profile_setup_state.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/profile_bio_field.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/profile_location_section.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/profile_personal_info.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/profile_photo_card.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/profile_preview_card.dart';
import 'package:flutter/material.dart';

class ProfileWizardWebBody extends StatelessWidget {
  const ProfileWizardWebBody({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ProfilePhotoCard(state: state, onPickPhoto: onPickPhoto),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ProfilePersonalInfo(
                state: state,
                nameController: nameController,
                nameFocusNode: nameFocusNode,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ProfileLocationSection(
                cityController: cityController,
                cityFocusNode: cityFocusNode,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: [
                  ProfileBioField(state: state, controller: bioController),
                  ProfilePreviewCard(state: state),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}
