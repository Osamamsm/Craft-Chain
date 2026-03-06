import 'package:flutter/material.dart';
import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';

enum SkillChipType { teach, learn, neutral }

class SkillChip extends StatelessWidget {
  const SkillChip({
    super.key,
    required this.label,
    this.type = SkillChipType.neutral,
    this.isSelected = false,
    this.onTap,
    this.showRemoveIcon = false,
  });

  final String label;
  final SkillChipType type;
  final bool isSelected;
  final VoidCallback? onTap;

  /// When true, shows a ✕ icon after the label (used in "Selected" section).
  final bool showRemoveIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    Color bg;
    Color textColor;
    Color borderColor;

    if (isSelected) {
      switch (type) {
        case SkillChipType.teach:
          bg = colors.teachChipBg;
          textColor = colors.teachChipText;
          borderColor = colors.teachChipText;
          break;
        case SkillChipType.learn:
          bg = colors.infoBackground;
          textColor = colors.primary;
          borderColor = colors.primary;
          break;
        case SkillChipType.neutral:
          bg = colors.infoBackground;
          textColor = colors.primary;
          borderColor = colors.primary;
          break;
      }
    } else {
      bg = colors.surface2;
      textColor = colors.secondaryText;
      borderColor = colors.inputBorder;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (showRemoveIcon) ...[
              const SizedBox(width: 4),
              Icon(Icons.close, size: 12, color: textColor),
            ],
          ],
        ),
      ),
    );
  }
}
