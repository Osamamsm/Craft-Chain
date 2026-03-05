import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class SignUpInfoBox extends StatelessWidget {
  const SignUpInfoBox({super.key, required this.colors});
  final AppColorPalette colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.infoBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: colors.primary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.onBackground,
                ),
                children: [
                  TextSpan(
                    text: 'Next step  ',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(
                    text:
                        "After signing up, you'll pick the skills you teach and want to learn.",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
