import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class WizardFieldLabel extends StatelessWidget {
  const WizardFieldLabel({required this.labelKey, super.key});
  final String labelKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        labelKey.tr(),
        style: AppTextStyles.labelUppercase.copyWith(
          color: context.colors.secondaryText,
        ),
      ),
    );
  }
}

class WizardTextField extends StatelessWidget {
  const WizardTextField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.prefixIcon,
    required this.onChanged,
    this.textInputAction = TextInputAction.next,
    super.key,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final IconData prefixIcon;
  final ValueChanged<String> onChanged;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Focus(
      focusNode: focusNode,
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasFocus;
          return Container(
            height: 48,
            decoration: BoxDecoration(
              color: isFocused ? colors.surface : colors.surface2,
              border: Border.all(
                color: isFocused ? colors.primary : colors.inputBorder,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: controller,
              textInputAction: textInputAction,
              style: AppTextStyles.bodyMedium.copyWith(color: colors.onSurface),
              decoration: InputDecoration(
                hintText: hintText.tr(),
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: colors.secondaryText,
                ),
                prefixIcon: Icon(
                  prefixIcon,
                  size: 16,
                  color: colors.secondaryText,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
              ),
              onChanged: onChanged,
            ),
          );
        },
      ),
    );
  }
}

class WizardSearchBar extends StatelessWidget {
  const WizardSearchBar({required this.controller, super.key});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: colors.surface2,
        border: Border.all(color: colors.inputBorder, width: 1.5),
        borderRadius: BorderRadius.circular(11),
      ),
      child: TextField(
        controller: controller,
        style: AppTextStyles.bodyMedium.copyWith(color: colors.onSurface),
        decoration: InputDecoration(
          hintText: 'profile.search_skills'.tr(),
          hintStyle: AppTextStyles.bodySmall.copyWith(
            color: colors.secondaryText,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 17,
            color: colors.secondaryText,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

class WizardSectionLabel extends StatelessWidget {
  const WizardSectionLabel({required this.labelKey, super.key});
  final String labelKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        labelKey.tr().toUpperCase(),
        style: AppTextStyles.labelUppercase.copyWith(
          color: context.colors.secondaryText,
          fontSize: 10,
        ),
      ),
    );
  }
}
