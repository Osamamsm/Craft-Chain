import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/utils/auth_validators.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Pre-configured full-name form field with validator.
class AuthNameField extends StatelessWidget {
  const AuthNameField({
    super.key,
    required this.colors,
    this.onChanged,
    this.onSaved,
  });

  final AppColorPalette colors;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return AuthFormField(
      label: 'auth.full_name_label'.tr(),
      hint: 'auth.full_name_hint'.tr(),
      prefixIcon: Icons.person_outline_rounded,
      textInputAction: TextInputAction.next,
      colors: colors,
      validator: AuthValidators.fullName,
      onChanged: onChanged,
      onSaved: onSaved,
    );
  }
}
