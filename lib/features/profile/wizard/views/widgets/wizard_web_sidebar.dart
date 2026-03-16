import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/profile/wizard/viewmodels/profile_setup_cubit/profile_setup_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Step metadata
// ─────────────────────────────────────────────────────────────────────────────

class WizardStepMeta {
  const WizardStepMeta({required this.labelKey, required this.descKey});
  final String labelKey;
  final String descKey;
}

const wizardStepMeta = [
  WizardStepMeta(
    labelKey: 'profile.sidebar_step1_label',
    descKey: 'profile.sidebar_step1_desc',
  ),
  WizardStepMeta(
    labelKey: 'profile.sidebar_step2_label',
    descKey: 'profile.sidebar_step2_desc',
  ),
  WizardStepMeta(
    labelKey: 'profile.sidebar_step3_label',
    descKey: 'profile.sidebar_step3_desc',
  ),
  WizardStepMeta(
    labelKey: 'profile.sidebar_step4_label',
    descKey: 'profile.sidebar_step4_desc',
  ),
  WizardStepMeta(
    labelKey: 'profile.sidebar_step5_label',
    descKey: 'profile.sidebar_step5_desc',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Web Sidebar
// ─────────────────────────────────────────────────────────────────────────────

const double kSidebarWidth = 280.0;

class WizardWebSidebar extends StatelessWidget {
  const WizardWebSidebar({
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
    final currentIdx = stepIndex;

    return Container(
      width: kSidebarWidth,
      height: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(right: BorderSide(color: colors.inputBorder)),
      ),
      padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Brand row ──────────────────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colors.primary, colors.gradientStart],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.code_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 9),
              Text(
                'app_name'.tr(),
                style: AppTextStyles.titleMedium.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),

          // ── Step list ──────────────────────────────────────────────────────
          Expanded(
            child: Column(
              children: List.generate(ProfileSetupStep.values.length, (i) {
                final isDone = i < currentIdx;
                final isActive = i == currentIdx;
                return _WebStepRow(
                  index: i,
                  meta: wizardStepMeta[i],
                  isDone: isDone,
                  isActive: isActive,
                );
              }),
            ),
          ),

          // ── Overall progress ───────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: colors.inputBorder)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'profile.overall_progress'.tr(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.secondaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LayoutBuilder(
                  builder: (context, constraints) => Stack(
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Web Step Row (private — only used by WizardWebSidebar above)
// ─────────────────────────────────────────────────────────────────────────────

class _WebStepRow extends StatelessWidget {
  const _WebStepRow({
    required this.index,
    required this.meta,
    required this.isDone,
    required this.isActive,
  });

  final int index;
  final WizardStepMeta meta;
  final bool isDone;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    Color rowBg = Colors.transparent;
    if (isActive) rowBg = colors.infoBackground;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: rowBg,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Opacity(
        opacity: isDone ? 0.6 : 1.0,
        child: Row(
          children: [
            // ── Step bubble ─────────────────────────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone
                    ? AppColors.avatarTeal
                    : isActive
                    ? colors.primary
                    : Colors.transparent,
                border: (!isDone && !isActive)
                    ? Border.all(color: colors.inputBorder, width: 1.5)
                    : null,
              ),
              child: Center(
                child: isDone
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
                      )
                    : Text(
                        '${index + 1}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isActive ? Colors.white : colors.secondaryText,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),

            // ── Label + desc ─────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meta.labelKey.tr(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isActive ? colors.primary : colors.secondaryText,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    isDone
                        ? 'profile.sidebar_step_complete'.tr()
                        : meta.descKey.tr(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.secondaryText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
