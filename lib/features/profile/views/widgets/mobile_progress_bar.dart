import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Mobile progress bar (only shown on mobile)
// ─────────────────────────────────────────────────────────────────────────────

class MobileProgressBar extends StatelessWidget {
  const MobileProgressBar({
    required this.stepIndex,
    required this.totalSteps,
    required this.progress,
    super.key,
  });
  final int stepIndex;
  final int totalSteps;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      color: colors.surface,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'profile.step_of'.tr(
                  namedArgs: {
                    'current': '${stepIndex + 1}',
                    'total': '$totalSteps',
                  },
                ),
                style: AppTextStyles.labelUppercase.copyWith(
                  color: colors.secondaryText,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: colors.inputBorder,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                    height: 5,
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colors.primary, AppColors.avatarTeal],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}
