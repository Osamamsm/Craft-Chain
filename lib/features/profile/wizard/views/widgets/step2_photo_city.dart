import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/profile/wizard/viewmodels/profile_setup_cubit/profile_setup_cubit.dart';
import 'package:craft_chain/features/profile/wizard/viewmodels/profile_setup_cubit/profile_setup_state.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/avatar_picker.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/wizard_form_widgets.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/wizard_step_footer.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/wizard_step_scaffold.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/wizard_tip_box.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Step2PhotoCity extends StatelessWidget {
  const Step2PhotoCity({
    super.key,
    required this.state,
    required this.cityController,
    required this.cityFocusNode,
    required this.onPickPhoto,
    required this.isWeb,
  });

  final ProfileSetupState state;
  final TextEditingController cityController;
  final FocusNode cityFocusNode;
  final VoidCallback onPickPhoto;
  final bool isWeb;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.read<ProfileSetupCubit>();

    if (cityController.text != state.city) {
      cityController.text = state.city;
    }

    Widget bodyContent;

    if (isWeb) {
      bodyContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'profile.photo_card_title'.tr(),
                        style: AppTextStyles.titleMedium.copyWith(
                          color: colors.onSurface,
                        ),
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
                              Icon(
                                Icons.upload_rounded,
                                size: 14,
                                color: colors.primary,
                              ),
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
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WizardFieldLabel(labelKey: 'profile.city_label'),
                WizardTextField(
                  controller: cityController,
                  focusNode: cityFocusNode,
                  hintText: 'profile.city_hint',
                  prefixIcon: Icons.location_on_outlined,
                  onChanged: cubit.updateCity,
                ),
                const SizedBox(height: 12),
                const WizardTipBox(
                  titleKey: 'profile.city_tip_title',
                  bodyKey: 'profile.city_tip_body',
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
        ],
      );
    } else {
      bodyContent = Column(
        children: [
          Center(
            child: AvatarPicker(
              photoFile: state.photoFile,
              onTap: onPickPhoto,
              radius: 52,
              showLabel: true,
            ),
          ),
          const SizedBox(height: 22),
          WizardFieldLabel(labelKey: 'profile.city_label'),
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
          const SizedBox(height: 24),
        ],
      );
    }

    return WizardStepScaffold(
      titleKey: 'profile.step_2_title',
      subtitleKey: 'profile.step_2_subtitle',
      isWeb: isWeb,
      body: bodyContent,
      footer: WizardStepFooter(
        isValid: state.isStep2Valid,
        isLastStep: false,
        isLoading: false,
        isWeb: isWeb,
      ),
    ).animate().fadeIn(duration: 250.ms);
  }
}
