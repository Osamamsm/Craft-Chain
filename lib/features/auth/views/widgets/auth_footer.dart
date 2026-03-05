import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({
    super.key,
    required this.prompt,
    required this.actionLabel,
    required this.onTap,
    required this.colors,
  });

  final String prompt;
  final String actionLabel;
  final VoidCallback onTap;
  final AppColorPalette colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.bodyMedium.copyWith(color: colors.secondaryText),
          children: [
            TextSpan(text: '$prompt '),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: onTap,
                child: Text(
                  actionLabel,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
