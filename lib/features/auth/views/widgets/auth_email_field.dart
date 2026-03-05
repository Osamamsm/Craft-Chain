import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/utils/auth_validators.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_form_field.dart';
import 'package:flutter/material.dart';

/// Pre-configured email form field with validator and keyboard type.
class AuthEmailField extends StatelessWidget {
  const AuthEmailField({
    super.key,
    required this.colors,
    this.onChanged,
    this.onSaved,
    this.textInputAction = TextInputAction.next,
  });

  final AppColorPalette colors;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return AuthFormField(
      label: 'EMAIL',
      hint: 'your@email.com',
      prefixIcon: Icons.mail_outline_rounded,
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction,
      colors: colors,
      validator: AuthValidators.email,
      onChanged: onChanged,
      onSaved: onSaved,
    );
  }
}
