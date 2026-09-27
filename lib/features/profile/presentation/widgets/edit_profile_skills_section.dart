import 'package:craft_chain/core/constants/app_skills.dart';
import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/skill_chip.dart';
import 'package:craft_chain/core/widgets/skill_selector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';

class EditProfileSkillsSection extends StatelessWidget {
  const EditProfileSkillsSection({
    super.key,
    required this.allSkills,
    required this.teachingSkills,
    required this.learningSkills,
    required this.onToggleTeach,
    required this.onToggleLearn,
  });

  final List<Skill> allSkills;
  final Set<String> teachingSkills;
  final Set<String> learningSkills;

  final ValueChanged<String> onToggleTeach;
  final ValueChanged<String> onToggleLearn;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SkillGroup(
          label: 'profile.edit_teaches_label'.tr(),
          selected: teachingSkills,
          allSkills: allSkills,
          type: SkillChipType.teach,
          onToggle: onToggleTeach,
        ),

        const SizedBox(height: 12),

        _SkillGroup(
          label: 'profile.edit_learn_label'.tr(),
          selected: learningSkills,
          allSkills: allSkills,
          type: SkillChipType.learn,
          onToggle: onToggleLearn,
        ),
      ],
    );
  }
}

class _SkillGroup extends StatefulWidget {
  const _SkillGroup({
    required this.label,
    required this.selected,
    required this.allSkills,
    required this.type,
    required this.onToggle,
  });

  final String label;
  final Set<String> selected;
  final List<Skill> allSkills;
  final SkillChipType type;
  final ValueChanged<String> onToggle;

  @override
  State<_SkillGroup> createState() => _SkillGroupState();
}

class _SkillGroupState extends State<_SkillGroup> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.inputBorder,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.label,
                      style: AppTextStyles.labelUppercase.copyWith(
                        color: colors.secondaryText,
                      ),
                    ),
                  ),

                  if (widget.selected.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(
                          alpha: 0.12,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${widget.selected.length}',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: colors.primary,
                        ),
                      ),
                    ),

                  const SizedBox(width: 8),

                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: colors.secondaryText,
                  ),
                ],
              ),
            ),
          ),

          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                0,
                16,
                16,
              ),
              child: SkillSelector(
                allSkills: widget.allSkills,
                selected: widget.selected,
                type: widget.type,
                onToggle: widget.onToggle,
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}