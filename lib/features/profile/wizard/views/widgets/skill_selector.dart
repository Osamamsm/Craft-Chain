import 'package:craft_chain/core/constants/app_skills.dart';
import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/skill_chip.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/wizard_form_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SkillSelector extends StatelessWidget {
  const SkillSelector({
    required this.selectedSkills,
    required this.type,
    required this.searchController,
    required this.searchQuery,
    required this.onToggle,
    super.key,
  });

  final Set<String> selectedSkills;
  final SkillChipType type;
  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final countColor = type == SkillChipType.teach
        ? colors.teachChipText
        : colors.primary;

    final q = searchQuery.toLowerCase();
    final filteredCategories = AppSkills.all
        .map((category) {
          final filtered = category.skills
              .where((s) => q.isEmpty || s.toLowerCase().contains(q))
              .toList();
          return _FilteredCategory(nameKey: category.nameKey, skills: filtered);
        })
        .where((c) => c.skills.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedSkills.isNotEmpty) ...[
          Row(
            children: [
              Expanded(child: Divider(color: colors.inputBorder)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'profile.n_selected'.tr(
                    namedArgs: {'count': '${selectedSkills.length}'},
                  ),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: countColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(child: Divider(color: colors.inputBorder)),
            ],
          ),
          const SizedBox(height: 14),
        ],
        WizardSearchBar(controller: searchController),
        const SizedBox(height: 14),
        if (selectedSkills.isNotEmpty && q.isEmpty) ...[
          WizardSectionLabel(labelKey: 'profile.section_selected'),
          _ChipWrap(
            skills: selectedSkills.toList(),
            selectedSkills: selectedSkills,
            type: type,
            onToggle: onToggle,
            showRemove: true,
          ),
          const SizedBox(height: 10),
        ],
        for (final cat in filteredCategories) ...[
          WizardSectionLabel(labelKey: cat.nameKey),
          _ChipWrap(
            skills: cat.skills
                .where((s) => q.isNotEmpty || !selectedSkills.contains(s))
                .toList(),
            selectedSkills: selectedSkills,
            type: type,
            onToggle: onToggle,
            showRemove: false,
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

class _FilteredCategory {
  const _FilteredCategory({required this.nameKey, required this.skills});
  final String nameKey;
  final List<String> skills;
}

class _ChipWrap extends StatelessWidget {
  const _ChipWrap({
    required this.skills,
    required this.selectedSkills,
    required this.type,
    required this.onToggle,
    required this.showRemove,
  });
  final List<String> skills;
  final Set<String> selectedSkills;
  final SkillChipType type;
  final ValueChanged<String> onToggle;
  final bool showRemove;

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Wrap(
        spacing: 7,
        runSpacing: 7,
        children: skills
            .map(
              (s) => SkillChip(
                label: s,
                type: type,
                isSelected: selectedSkills.contains(s),
                showRemoveIcon: showRemove && selectedSkills.contains(s),
                onTap: () => onToggle(s),
              ),
            )
            .toList(),
      ),
    );
  }
}
