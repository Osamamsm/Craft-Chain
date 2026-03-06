import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/profile/viewmodels/profile_setup_cubit/profile_setup_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WizardStepScaffold extends StatelessWidget {
  const WizardStepScaffold({
    required this.titleKey,
    required this.subtitleKey,
    required this.body,
    required this.footer,
    required this.isWeb,
    this.showBack = true,
    super.key,
  });

  final String titleKey;
  final String subtitleKey;
  final Widget body;
  final Widget footer;
  final bool isWeb;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final headerPadding = isWeb
        ? const EdgeInsets.fromLTRB(36, 24, 36, 20)
        : EdgeInsets.fromLTRB(showBack ? 14 : 20, 0, 20, 14);

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border(bottom: BorderSide(color: colors.inputBorder)),
          ),
          padding: headerPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isWeb && showBack)
                Padding(
                  padding: const EdgeInsets.only(right: 12, top: 2),
                  child: GestureDetector(
                    onTap: () =>
                        context.read<ProfileSetupCubit>().previousStep(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colors.surface2,
                        border: Border.all(color: colors.inputBorder),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 18,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleKey.tr(),
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: colors.onSurface,
                        fontSize: isWeb ? 22 : 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitleKey.tr(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.secondaryText,
                        fontSize: isWeb ? 13 : 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              isWeb ? 36 : 20,
              isWeb ? 28 : 18,
              isWeb ? 36 : 20,
              0,
            ),
            child: body,
          ),
        ),
        footer,
      ],
    );
  }
}
