import 'package:craft_chain/core/widgets/skill_chip.dart';
import 'package:flutter/material.dart';

/// A wrap of tappable [SkillChip]s that toggles selection.
///
/// Pass [allSkills] as the full list to display. Selected chips are highlighted
/// using [type]'s colour palette. Tapping any chip calls [onToggle] with that
/// skill string — the parent manages the selected set.
///
/// Usage:
/// ```dart
/// SkillSelector(
///   allSkills: AppSkills.flat,
///   selected: _canTeach,
///   type: SkillChipType.teach,
///   onToggle: (skill) => setState(() {
///     _canTeach.contains(skill)
///         ? _canTeach.remove(skill)
///         : _canTeach.add(skill);
///   }),
/// )
/// ```
class SkillSelector extends StatelessWidget {
  const SkillSelector({
    super.key,
    required this.allSkills,
    required this.selected,
    required this.type,
    required this.onToggle,
  });

  final List<String> allSkills;
  final Set<String> selected;
  final SkillChipType type;
  final void Function(String skill) onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: allSkills
          .map(
            (skill) => SkillChip(
              label: skill,
              type: type,
              isSelected: selected.contains(skill),
              onTap: () => onToggle(skill),
            ),
          )
          .toList(),
    );
  }
}
