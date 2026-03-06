import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/profile/viewmodels/profile_setup_cubit/profile_setup_cubit.dart';
import 'package:craft_chain/features/profile/viewmodels/profile_setup_cubit/profile_setup_state.dart';
import 'package:craft_chain/features/profile/views/widgets/profile_preview_card.dart';
import 'package:craft_chain/features/profile/views/widgets/wizard_form_widgets.dart';
import 'package:craft_chain/features/profile/views/widgets/wizard_step_footer.dart';
import 'package:craft_chain/features/profile/views/widgets/wizard_step_scaffold.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Step5Bio extends StatelessWidget {
  const Step5Bio({super.key, 
    required this.state,
    required this.bioController,
    required this.isWeb,
  });
  final ProfileSetupState state;
  final TextEditingController bioController;
  final bool isWeb;

  static const int _maxChars = 300;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.read<ProfileSetupCubit>();

    if (bioController.text != state.bio) {
      bioController.text = state.bio;
    }

    final bioField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WizardFieldLabel(labelKey: 'profile.bio_label'),
        Container(
          decoration: BoxDecoration(
            color: colors.surface2,
            border: Border.all(
              color: state.bio.isNotEmpty ? colors.primary : colors.inputBorder,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(13),
          child: TextField(
            controller: bioController,
            maxLines: 5,
            maxLength: _maxChars,
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
            onChanged: (v) {
              if (v.length <= _maxChars) cubit.updateBio(v);
            },
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 14),
            child: Text(
              'profile.bio_char_count'.tr(
                namedArgs: {
                  'current': '${state.bio.length}',
                  'max': '$_maxChars',
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

    Widget bodyContent;

    if (isWeb) {
      bodyContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: bioField),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WizardFieldLabel(labelKey: 'profile.preview_label'),
                    ProfilePreviewCard(state: state),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const AlmostThereCard(),
          const SizedBox(height: 28),
        ],
      );
    } else {
      bodyContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfilePreviewCard(state: state),
          const SizedBox(height: 20),
          bioField,
          const AlmostThereCard(),
          const SizedBox(height: 24),
        ],
      );
    }

    return WizardStepScaffold(
      titleKey: 'profile.step_5_title',
      subtitleKey: 'profile.step_5_subtitle',
      isWeb: isWeb,
      body: bodyContent,
      footer: WizardStepFooter(
        isValid: state.isStep5Valid,
        isLastStep: true,
        isLoading: state.isLoading,
        isWeb: isWeb,
      ),
    ).animate().fadeIn(duration: 250.ms);
  }
}
