import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/profile/domain/entities/user_profile_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';

class EditProfileGenderDisplay extends StatelessWidget {
  const EditProfileGenderDisplay({super.key, required this.gender});

  final Gender gender;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final label = gender == Gender.male
        ? 'profile.gender_male'.tr()
        : 'profile.gender_female'.tr();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.inputBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.person_outline_rounded, color: colors.secondaryText),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'profile.gender_label'.tr().toUpperCase(),
                  style: AppTextStyles.labelUppercase.copyWith(
                    color: colors.secondaryText,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.lock_outline_rounded,
            size: 16,
            color: colors.secondaryText,
          ),

          const SizedBox(width: 4),

          Text(
            'profile.gender_not_editable'.tr(),
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
