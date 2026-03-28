import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/auth/models/app_user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// ── Mobile stats row ──────────────────────────────────────────────────────────

/// Three frosted-glass stat boxes shown inside the gradient header on mobile.
class MobileStatsRow extends StatelessWidget {
  const MobileStatsRow({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MobileStatBox(
          value: '${user.barterCount}',
          labelKey: 'profile.barters_label',
        ),
        const SizedBox(width: 10),
        _MobileStatBox(
          value: user.rating.toStringAsFixed(1),
          labelKey: 'profile.rating_label',
        ),
        const SizedBox(width: 10),
        _MobileStatBox(
          value: '${user.canTeach.length}',
          labelKey: 'profile.skills_label',
        ),
      ],
    );
  }
}

class _MobileStatBox extends StatelessWidget {
  const _MobileStatBox({required this.value, required this.labelKey});

  final String value;
  final String labelKey;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.titleLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              labelKey.tr(),
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Web stats row ─────────────────────────────────────────────────────────────

/// Four stat boxes (barters / rating / skills offered / skills learning)
/// shown in the white card body on the web layout.
class WebStatsRow extends StatelessWidget {
  const WebStatsRow({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        _WebStatBox(
          value: '${user.barterCount}',
          labelKey: 'profile.total_barters_label',
          colors: colors,
        ),
        const SizedBox(width: 12),
        _WebStatBox(
          value: user.rating.toStringAsFixed(1),
          labelKey: 'profile.avg_rating_label',
          colors: colors,
        ),
        const SizedBox(width: 12),
        _WebStatBox(
          value: '${user.canTeach.length}',
          labelKey: 'profile.skills_offered_label',
          colors: colors,
        ),
        const SizedBox(width: 12),
        _WebStatBox(
          value: '${user.wantsToLearn.length}',
          labelKey: 'profile.skills_learning_label',
          colors: colors,
        ),
      ],
    );
  }
}

class _WebStatBox extends StatelessWidget {
  const _WebStatBox({
    required this.value,
    required this.labelKey,
    required this.colors,
  });

  final String value;
  final String labelKey;
  final AppColorPalette colors;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: colors.surface2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.inputBorder),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.titleLarge.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              labelKey.tr(),
              style: AppTextStyles.labelUppercase.copyWith(
                color: colors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
