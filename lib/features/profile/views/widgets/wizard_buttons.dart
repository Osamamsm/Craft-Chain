import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class WizardPrimaryButton extends StatelessWidget {
  const WizardPrimaryButton({
    required this.label,
    required this.isEnabled,
    required this.onTap,
    this.isLoading = false,
    this.fixedWidth,
    super.key,
  });
  final String label;
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback onTap;
  final double? fixedWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: isEnabled && !isLoading ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50,
        width: fixedWidth,
        constraints: fixedWidth == null
            ? null
            : BoxConstraints(minWidth: fixedWidth!),
        padding: fixedWidth != null
            ? const EdgeInsets.symmetric(horizontal: 20)
            : null,
        decoration: BoxDecoration(
          gradient: isEnabled
              ? LinearGradient(
                  colors: [colors.primary, colors.gradientStart],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isEnabled ? null : colors.surface2,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.onPrimary,
                  ),
                )
              : Text(
                  label,
                  style: AppTextStyles.buttonLarge.copyWith(
                    fontSize: 14,
                    color: isEnabled ? colors.onPrimary : colors.secondaryText,
                  ),
                ),
        ),
      ),
    );
  }
}

class WizardOutlineButton extends StatelessWidget {
  const WizardOutlineButton({
    required this.label,
    required this.onTap,
    this.fixedWidth,
    super.key,
  });
  final String label;
  final VoidCallback onTap;
  final double? fixedWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: fixedWidth,
        padding: fixedWidth != null
            ? const EdgeInsets.symmetric(horizontal: 20)
            : null,
        decoration: BoxDecoration(
          color: colors.surface2,
          border: Border.all(color: colors.inputBorder, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.buttonLarge.copyWith(
              fontSize: 14,
              color: colors.secondaryText,
            ),
          ),
        ),
      ),
    );
  }
}
