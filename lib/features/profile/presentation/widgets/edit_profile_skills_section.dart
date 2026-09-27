import 'package:craft_chain/core/constants/app_skills.dart';
import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/skill_chip.dart';
import 'package:craft_chain/core/widgets/skill_selector.dart';
import 'package:material_ui/material_ui.dart';
import 'package:easy_localization/easy_localization.dart';

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SkillGroup(
          label: 'profile.edit_teaches_label'.tr(),
          allSkills: allSkills,
          selected: teachingSkills,
          type: SkillChipType.teach,
          onToggle: onToggleTeach,
        ),

        const SizedBox(height: 20),

        _SkillGroup(
          label: 'profile.edit_learn_label'.tr(),
          allSkills: allSkills,
          selected: learningSkills,
          type: SkillChipType.learn,
          onToggle: onToggleLearn,
        ),
      ],
    );
  }
}

class _SkillGroup extends StatelessWidget {
  const _SkillGroup({
    required this.label,
    required this.allSkills,
    required this.selected,
    required this.type,
    required this.onToggle,
  });

  final String label;
  final List<Skill> allSkills;
  final Set<String> selected;
  final SkillChipType type;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelUppercase.copyWith(
            color: context.colors.secondaryText,
          ),
        ),

        const SizedBox(height: 10),

        SkillSelector(
          allSkills: allSkills,
          selected: selected,
          type: type,
          onToggle: onToggle,
        ),
      ],
    );
  }
}
