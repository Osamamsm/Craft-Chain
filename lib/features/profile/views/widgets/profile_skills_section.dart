import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/widgets/section_label.dart';
import 'package:craft_chain/core/widgets/skill_chip.dart';
import 'package:craft_chain/features/auth/models/app_user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays a user's bio, skills they teach, and skills they want to learn.
///
/// Used in both the mobile single-column layout and the web left column.
class ProfileSkillsSection extends StatelessWidget {
  const ProfileSkillsSection({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── About ──────────────────────────────────────────────────────────
        SectionLabel('profile.about'.tr()),
        const SizedBox(height: 8),
        Text(
          user.bio,
          style: AppTextStyles.bodyMedium.copyWith(
            color: colors.onSurface,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),

        // ── Teaches ────────────────────────────────────────────────────────
        SectionLabel('profile.teaches'.tr()),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: user.canTeach
              .map(
                (s) => SkillChip(
                  label: s,
                  type: SkillChipType.teach,
                  isSelected: true,
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),

        // ── Wants to learn ─────────────────────────────────────────────────
        SectionLabel('profile.wants_to_learn'.tr()),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: user.wantsToLearn
              .map(
                (s) => SkillChip(
                  label: s,
                  type: SkillChipType.learn,
                  isSelected: true,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
