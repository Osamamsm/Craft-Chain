import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// A small uppercased label used above content sections (About, Teaches, etc.).
///
/// Usage:
/// ```dart
/// SectionLabel('profile.about'.tr())
/// ```
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppTextStyles.labelUppercase.copyWith(
        color: context.colors.secondaryText,
        letterSpacing: 1.2,
      ),
    );
  }
}
