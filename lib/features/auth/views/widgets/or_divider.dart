import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key, required this.colors});
  final AppColorPalette colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: colors.inputBorder)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or with email',
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.secondaryText,
            ),
          ),
        ),
        Expanded(child: Divider(color: colors.inputBorder)),
      ],
    );
  }
}
