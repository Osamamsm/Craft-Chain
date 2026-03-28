import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// A text field with an uppercased label above it.
///
/// Used across profile editing, auth forms, and any other input form.
///
/// Usage:
/// ```dart
/// LabeledTextField(
///   labelKey: 'profile.full_name_label'.tr(),
///   controller: _nameCtrl,
///   hintText: 'profile.full_name_hint'.tr(),
/// )
/// ```
class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // fixes centering on wide screens
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.labelUppercase.copyWith(
            color: context.colors.secondaryText,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
          ),
        ),
      ],
    );
  }
}
