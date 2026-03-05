import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/utils/auth_validators.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_form_field.dart';
import 'package:flutter/material.dart';

/// Pre-configured password field with built-in show/hide visibility toggle.
/// Manages its own obscure state — no need for the parent to track it.
class AuthPasswordField extends StatefulWidget {
  const AuthPasswordField({
    super.key,
    required this.colors,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.hint = 'Create a strong password',
    this.textInputAction = TextInputAction.done,
  });

  final AppColorPalette colors;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;

  /// Defaults to [AuthValidators.password] (≥6 chars).
  /// Pass null or a lighter check for sign-in.
  final String? Function(String?)? validator;

  final String hint;
  final TextInputAction textInputAction;

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AuthFormField(
      label: 'PASSWORD',
      hint: widget.hint,
      prefixIcon: Icons.lock_outline_rounded,
      obscureText: _obscure,
      textInputAction: widget.textInputAction,
      colors: widget.colors,
      suffix: IconButton(
        icon: Icon(
          _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: widget.colors.secondaryText,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      validator: widget.validator ?? AuthValidators.password,
    );
  }
}
