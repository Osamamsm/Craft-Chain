import 'dart:typed_data';

import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/skill_chip.dart';
import 'package:craft_chain/features/profile/viewmodels/profile_setup_cubit/profile_setup_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Profile preview card — shown in step 5
// ─────────────────────────────────────────────────────────────────────────────

class ProfilePreviewCard extends StatefulWidget {
  const ProfilePreviewCard({required this.state, super.key});
  final ProfileSetupState state;

  @override
  State<ProfilePreviewCard> createState() => _ProfilePreviewCardState();
}

class _ProfilePreviewCardState extends State<ProfilePreviewCard> {
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _loadBytes();
  }

  @override
  void didUpdateWidget(ProfilePreviewCard old) {
    super.didUpdateWidget(old);
    if (widget.state.photoFile?.path != old.state.photoFile?.path) {
      _loadBytes();
    }
  }

  Future<void> _loadBytes() async {
    if (widget.state.photoFile == null) return;
    final bytes = await widget.state.photoFile!.readAsBytes();
    if (mounted) setState(() => _imageBytes = bytes);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final s = widget.state;
    final initials = s.name.isNotEmpty ? s.name[0].toUpperCase() : '?';
    final topTeach = s.teachSkills.take(2).toList();
    final topLearn = s.learnSkills.take(1).toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.inputBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Container(
              width: 46,
              height: 46,
              color: AppColors.avatarTeal,
              child: _imageBytes != null
                  ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                  : Center(
                      child: Text(
                        initials,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.name.isNotEmpty ? s.name : '—',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                if (s.city.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 11,
                        color: colors.secondaryText,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        s.city,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    ...topTeach.map(
                      (skill) => SkillChip(
                        label: skill,
                        type: SkillChipType.teach,
                        isSelected: true,
                      ),
                    ),
                    if (s.teachSkills.length > 2)
                      SkillChip(
                        label: '+${s.teachSkills.length - 2}',
                        type: SkillChipType.teach,
                        isSelected: true,
                      ),
                    ...topLearn.map(
                      (skill) => SkillChip(
                        label: skill,
                        type: SkillChipType.learn,
                        isSelected: true,
                      ),
                    ),
                  ],
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
// "Almost there" motivational card — shown at the bottom of step 5
// ─────────────────────────────────────────────────────────────────────────────

class AlmostThereCard extends StatelessWidget {
  const AlmostThereCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.teachChipBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.avatarTeal,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'profile.almost_there_title'.tr(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.teachChipText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'profile.almost_there_body'.tr(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.teachChipText,
                    height: 1.5,
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
