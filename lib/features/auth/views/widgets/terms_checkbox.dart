import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Terms & Privacy Policy checkbox that participates in standard [Form]
/// validation. Shows an inline error message if the user tries to submit
/// without checking the box.
class TermsCheckbox extends StatelessWidget {
  const TermsCheckbox({super.key, required this.colors});

  final AppColorPalette colors;

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: false,
      validator: (v) =>
          (v == null || !v) ? 'auth.validation_terms_required'.tr() : null,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: state.value ?? false,
                    onChanged: (v) => state.didChange(v),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => state.didChange(!(state.value ?? false)),
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.secondaryText,
                        ),
                        children: [
                          TextSpan(text: 'auth.terms_agree'.tr()),
                          TextSpan(
                            text: 'auth.terms_of_service'.tr(),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: 'auth.terms_and'.tr()),
                          TextSpan(
                            text: 'auth.privacy_policy'.tr(),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  state.errorText!,
                  style: AppTextStyles.bodySmall.copyWith(color: colors.error),
                ),
              ),
          ],
        );
      },
    );
  }
}
