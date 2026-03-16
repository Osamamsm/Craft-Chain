import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/features/matching/views/match_feed_screen.dart';
import 'package:craft_chain/features/profile/wizard/viewmodels/profile_setup_cubit/profile_setup_cubit.dart';
import 'package:craft_chain/features/profile/wizard/viewmodels/profile_setup_cubit/profile_setup_state.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/wizard_buttons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WizardStepFooter extends StatelessWidget {
  const WizardStepFooter({
    required this.isValid,
    required this.isLastStep,
    required this.isLoading,
    required this.isWeb,
    this.showBack = true,
    super.key,
  });

  final bool isValid;
  final bool isLastStep;
  final bool isLoading;
  final bool showBack;
  final bool isWeb;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.read<ProfileSetupCubit>();

    final nextLabel = isLastStep
        ? 'profile.btn_complete_profile'.tr()
        : 'profile.btn_continue'.tr();

    final footerPadding = isWeb
        ? const EdgeInsets.fromLTRB(36, 16, 36, 24)
        : const EdgeInsets.fromLTRB(20, 12, 20, 24);

    return BlocListener<ProfileSetupCubit, ProfileSetupState>(
      listenWhen: (previous, current) =>
          !previous.isComplete && current.isComplete,
      listener: (context, state) => context.go(MatchFeedScreen.routePath),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(top: BorderSide(color: colors.inputBorder)),
        ),
        padding: footerPadding,
        child: isWeb
            ? _WebFooterRow(
                showBack: showBack,
                nextLabel: nextLabel,
                isValid: isValid,
                isLoading: isLoading,
                isLastStep: isLastStep,
                onBack: cubit.previousStep,
                onNext: () =>
                    isLastStep ? cubit.completeProfile() : cubit.nextStep(),
              )
            : _MobileFooterRow(
                showBack: showBack,
                nextLabel: nextLabel,
                isValid: isValid,
                isLoading: isLoading,
                onBack: cubit.previousStep,
                onNext: () =>
                    isLastStep ? cubit.completeProfile() : cubit.nextStep(),
              ),
      ),
    );
  }
}


class _MobileFooterRow extends StatelessWidget {
  const _MobileFooterRow({
    required this.showBack,
    required this.nextLabel,
    required this.isValid,
    required this.isLoading,
    required this.onBack,
    required this.onNext,
  });
  final bool showBack;
  final String nextLabel;
  final bool isValid;
  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBack) ...[
          Expanded(
            flex: 1,
            child: WizardOutlineButton(
              label: 'profile.btn_back'.tr(),
              onTap: onBack,
            ),
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          flex: showBack ? 2 : 1,
          child: WizardPrimaryButton(
            label: nextLabel,
            isEnabled: isValid,
            isLoading: isLoading,
            onTap: onNext,
          ),
        ),
      ],
    );
  }
}

class _WebFooterRow extends StatelessWidget {
  const _WebFooterRow({
    required this.showBack,
    required this.nextLabel,
    required this.isValid,
    required this.isLoading,
    required this.isLastStep,
    required this.onBack,
    required this.onNext,
  });
  final bool showBack;
  final String nextLabel;
  final bool isValid;
  final bool isLoading;
  final bool isLastStep;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (showBack) ...[
          SizedBox(
            height: 44,
            child: WizardOutlineButton(
              label: 'profile.btn_back'.tr(),
              onTap: onBack,
              fixedWidth: 100,
            ),
          ),
          const SizedBox(width: 12),
        ],
        SizedBox(
          height: 44,
          child: WizardPrimaryButton(
            label: nextLabel,
            isEnabled: isValid,
            isLoading: isLoading,
            onTap: onNext,
            fixedWidth: isLastStep ? 200 : 140,
          ),
        ),
      ],
    );
  }
}
