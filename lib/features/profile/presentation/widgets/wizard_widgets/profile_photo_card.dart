import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/profile/presentation/logic/profile_setup_cubit/profile_setup_state.dart';
import 'package:craft_chain/features/profile/presentation/widgets/wizard_widgets/avatar_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';

class ProfilePhotoCard extends StatelessWidget {
  const ProfilePhotoCard({
    super.key,
    required this.state,
    required this.onPickPhoto,
  });

  final ProfileSetupState state;
  final VoidCallback onPickPhoto;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.inputBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          AvatarPicker(
            photoFile: state.photoFile,
            onTap: onPickPhoto,
            radius: 40,
          ),
          const SizedBox(width: 20),
          _PhotoCardDetails(onPickPhoto: onPickPhoto),
        ],
      ),
    );
  }
}

class _PhotoCardDetails extends StatelessWidget {
  const _PhotoCardDetails({required this.onPickPhoto});

  final VoidCallback onPickPhoto;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'profile.photo_card_title'.tr(),
          style: AppTextStyles.titleMedium.copyWith(color: colors.onSurface),
        ),
        const SizedBox(height: 4),
        Text(
          'profile.photo_card_desc'.tr(),
          style: AppTextStyles.bodySmall.copyWith(
            color: colors.secondaryText,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onPickPhoto,
          child: Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: colors.infoBackground,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.upload_rounded, size: 14, color: colors.primary),
                const SizedBox(width: 6),
                Text(
                  'profile.change_photo'.tr(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
