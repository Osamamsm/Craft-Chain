import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Reusable labelled form field used by all auth screens.
/// Uses [onChanged] for real-time button-enable tracking,
/// [onSaved] for capturing the final trimmed value on submit,
/// and [validator] for standard Form validation.
/// No TextEditingController — state is owned by the parent Form.
class AuthFormField extends StatelessWidget {
  const AuthFormField({
    super.key,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    required this.colors,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
    this.initialValue,
  });

  final String label;
  final String hint;
  final IconData prefixIcon;
  final AppColorPalette colors;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelUppercase.copyWith(
            color: colors.secondaryText,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
          style: AppTextStyles.bodyLarge.copyWith(color: colors.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(prefixIcon, color: colors.secondaryText, size: 20),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}
