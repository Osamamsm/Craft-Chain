import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/matching/view_model/match_feed_cubit/match_feed_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Horizontally scrollable row of filter chips for the match feed.
///
/// The selected chip is filled with [AppColors.primary]; inactive chips are
/// outlined. Tapping a chip calls [onFilterSelected] with the new filter.
///
/// This widget is purely presentational — it holds no state and calls no
/// business logic directly.
class FilterChipsBar extends StatelessWidget {
  const FilterChipsBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final MatchFeedFilter selectedFilter;
  final ValueChanged<MatchFeedFilter> onFilterSelected;

  /// Outer horizontal padding around the chip row.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: MatchFeedFilter.values.map((filter) {
          final isSelected = filter == selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _FilterChip(
              label: filter.labelKey.tr(),
              isSelected: isSelected,
              onTap: () => onFilterSelected(filter),
            ),
          );
        }).toList(),
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
