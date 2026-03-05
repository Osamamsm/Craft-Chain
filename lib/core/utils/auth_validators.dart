import 'package:easy_localization/easy_localization.dart';

/// Centralised form validation logic for all auth screens.
/// All methods return null on valid input or an error string to display.
class AuthValidators {
  AuthValidators._();

  static String? fullName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'auth.validation_name_required'.tr();
    if (v.length < 2) return 'auth.validation_name_short'.tr();
    return null;
  }

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'auth.validation_email_required'.tr();
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!regex.hasMatch(v)) return 'auth.validation_email_invalid'.tr();
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'auth.validation_password_required'.tr();
    }
    if (value.length < 8) return 'auth.validation_password_short'.tr();
    return null;
  }

  static String? required(String? value, {String fieldName = ''}) {
    if (value == null || value.trim().isEmpty) {
      return 'auth.validation_field_required'.tr(
        namedArgs: {'field': fieldName},
      );
    }
    return null;
  }
}
