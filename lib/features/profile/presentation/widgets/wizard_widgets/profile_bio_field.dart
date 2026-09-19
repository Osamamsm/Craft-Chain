import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/profile/presentation/logic/profile_setup_cubit/profile_setup_cubit.dart';
import 'package:craft_chain/features/profile/presentation/logic/profile_setup_cubit/profile_setup_state.dart';
import 'package:craft_chain/features/profile/presentation/widgets/wizard_widgets/wizard_form_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class ProfileBioField extends StatelessWidget {
  const ProfileBioField({
    super.key,
    required this.state,
    required this.controller,
  });

  final ProfileSetupState state;
  final TextEditingController controller;

  static const int maxCharacters = 300;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.read<ProfileSetupCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardFieldLabel(labelKey: 'profile.bio_label'),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: colors.surface2,
            border: Border.all(
              color: state.bio.isNotEmpty ? colors.primary : colors.inputBorder,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            maxLines: 4,
            maxLength: maxCharacters,
            buildCounter:
                (_, {required currentLength, required isFocused, maxLength}) =>
                    null,
            style: AppTextStyles.bodyMedium.copyWith(color: colors.onSurface),
            decoration: InputDecoration.collapsed(
              hintText: 'profile.bio_hint'.tr(),
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: colors.secondaryText,
              ),
            ),
            onChanged: (value) {
              if (value.length <= maxCharacters) {
                cubit.updateBio(value);
              }
            },
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 8),
            child: Text(
              'profile.bio_char_count'.tr(
                namedArgs: {
                  'current': '${state.bio.length}',
                  'max': '$maxCharacters',
                },
              ),
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.secondaryText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
