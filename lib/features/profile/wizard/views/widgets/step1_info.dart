import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/profile/wizard/view_model/profile_setup_cubit/profile_setup_cubit.dart';
import 'package:craft_chain/features/profile/wizard/view_model/profile_setup_cubit/profile_setup_state.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/avatar_picker.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/gender_selector.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/profile_preview_card.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/wizard_form_widgets.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/wizard_step_footer.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/wizard_step_scaffold.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/wizard_tip_box.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  static const int _maxChars = 300;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.read<ProfileSetupCubit>();

    if (nameController.text != state.name) nameController.text = state.name;
    if (cityController.text != state.city) cityController.text = state.city;
    if (bioController.text != state.bio) bioController.text = state.bio;

    // ── Bio field ────────────────────────────────────────────────────────────
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
            maxLines: 4,
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
            padding: const EdgeInsets.only(top: 5, bottom: 8),
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
          // ── Photo + name + gender row ─────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: avatar picker
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
                    Column(
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
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Right: name + gender
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WizardFieldLabel(labelKey: 'profile.full_name_label'),
                    WizardTextField(
                      controller: nameController,
                      focusNode: nameFocusNode,
                      hintText: 'profile.full_name_hint',
                      prefixIcon: Icons.person_outline_rounded,
                      onChanged: cubit.updateName,
                    ),
                    const SizedBox(height: 16),
                    WizardFieldLabel(labelKey: 'profile.i_am_label'),
                    GenderSelector(
                      selected: state.gender,
                      onSelect: cubit.updateGender,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // ── City + Bio row ────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
                    const SizedBox(height: 16),
                    const WizardTipBox(
                      titleKey: 'profile.city_tip_title',
                      bodyKey: 'profile.city_tip_body',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bioField,
                    ProfilePreviewCard(state: state),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
        ],
      );
    } else {
      bodyContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          // ── Avatar ────────────────────────────────────────────────────────
          Center(
            child: AvatarPicker(
              photoFile: state.photoFile,
              onTap: onPickPhoto,
              radius: 48,
              showLabel: true,
            ),
          ),
          const SizedBox(height: 20),
          // ── Name ──────────────────────────────────────────────────────────
          WizardFieldLabel(labelKey: 'profile.full_name_label'),
          WizardTextField(
            controller: nameController,
            focusNode: nameFocusNode,
            hintText: 'profile.full_name_hint',
            prefixIcon: Icons.person_outline_rounded,
            onChanged: cubit.updateName,
          ),
          const SizedBox(height: 14),
          // ── Gender ────────────────────────────────────────────────────────
          WizardFieldLabel(labelKey: 'profile.i_am_label'),
          GenderSelector(selected: state.gender, onSelect: cubit.updateGender),
          const SizedBox(height: 14),
          // ── City ──────────────────────────────────────────────────────────
          WizardFieldLabel(labelKey: 'profile.city_label'),
          WizardTextField(
            controller: cityController,
            focusNode: cityFocusNode,
            hintText: 'profile.city_hint',
            prefixIcon: Icons.location_on_outlined,
            onChanged: cubit.updateCity,
          ),
          const SizedBox(height: 14),
          // ── Bio ───────────────────────────────────────────────────────────
          bioField,
          const SizedBox(height: 8),
          ProfilePreviewCard(state: state),
          const SizedBox(height: 24),
        ],
      );
    }

    return WizardStepScaffold(
      titleKey: 'profile.step_1_title',
      subtitleKey: 'profile.step_1_subtitle',
      isWeb: isWeb,
      showBack: false,
      body: bodyContent,
      footer: WizardStepFooter(
        isValid: state.isStep1Valid,
        isLastStep: false,
        isLoading: false,
        isWeb: isWeb,
        showBack: false,
      ),
    ).animate().fadeIn(duration: 250.ms);
  }
}
