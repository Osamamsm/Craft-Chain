import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class GenderSelector extends StatelessWidget {
  const GenderSelector({
    required this.selected,
    required this.onSelect,
    super.key,
  });
  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _GenderOption(
            labelKey: 'profile.gender_male',
            icon: Icons.person_outline_rounded,
            selected: selected == 'male',
            onTap: () => onSelect('male'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _GenderOption(
            labelKey: 'profile.gender_female',
            icon: Icons.person_outline_rounded,
            selected: selected == 'female',
            onTap: () => onSelect('female'),
          ),
        ),
      ],
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.labelKey,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final String labelKey;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 48,
        decoration: BoxDecoration(
          color: selected ? colors.infoBackground : colors.surface2,
          border: Border.all(
            color: selected ? colors.primary : colors.inputBorder,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? colors.primary : colors.secondaryText,
            ),
            const SizedBox(width: 7),
            Text(
              labelKey.tr(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: selected ? colors.primary : colors.secondaryText,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
