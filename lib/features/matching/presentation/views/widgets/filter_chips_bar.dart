import 'package:craft_chain/core/constants/app_skills.dart';
import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';

/// Horizontally scrollable row of category chips for the match feed.
///
/// The first chip is "All" (category id `null`), followed by one chip per
/// category in [AppSkills.all]. Tapping a chip calls [onCategorySelected]
/// with that category's id, or `null` for "All".
///
/// Purely presentational: it holds no state and calls no business logic.
class FilterChipsBar extends StatelessWidget {
  const FilterChipsBar({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final int? selectedCategoryId; // null = All
  final ValueChanged<int?> onCategorySelected;

  /// Outer horizontal padding around the chip row.
  final EdgeInsets padding;

  // "Other" (id 15) has no skills, so filtering by it always returns nothing.
  static final List<SkillCategory> _categories =
      AppSkills.all.where((c) => c.skills.isNotEmpty).toList();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: [
          _FilterChip(
            label: 'match.filter_all'.tr(),
            isSelected: selectedCategoryId == null,
            onTap: () => onCategorySelected(null),
          ),
          for (final category in _categories)
            _FilterChip(
              label: category.nameKey.tr(),
              isSelected: category.id == selectedCategoryId,
              onTap: () => onCategorySelected(category.id),
            ),
        ].map((chip) => Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: chip,
            )).toList(),
      ),
    );
  }
}

// ── Private chip widget ───────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colors.primary : colors.inputBorder,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? colors.onPrimary : colors.secondaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}