import 'package:craft_chain/core/layout/responsive_layout.dart';
import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/utils/auth_validators.dart';
import 'package:craft_chain/features/auth/presentation/Cubits/auth_cubit/auth_cubit.dart';
import 'package:craft_chain/features/auth/presentation/Cubits/auth_cubit/auth_state.dart';
import 'package:craft_chain/features/auth/presentation/Cubits/session_cubit/session_cubit.dart';
import 'package:craft_chain/features/auth/presentation/views/sign_in_screen.dart';
import 'package:craft_chain/features/auth/presentation/widgets/auth_error_banner.dart';
import 'package:craft_chain/features/auth/presentation/widgets/auth_password_field.dart';
import 'package:craft_chain/features/auth/presentation/widgets/auth_submit_button.dart';
import 'package:craft_chain/features/auth/presentation/widgets/auth_web_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class ResetPasswordScreen extends StatelessWidget {
  static const String routePath = '/reset-password';

  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: const _ResetPasswordMobileScaffold(),
      desktopLayout: AuthWebLayout(
        title: 'auth.new_password_title'.tr(),
        subtitle: 'auth.new_password_subtitle'.tr(),
        formContent: const _ResetPasswordForm(),
      ),
    );
  }
}

// ── Mobile scaffold ───────────────────────────────────────────────────────────

class _ResetPasswordMobileScaffold extends StatelessWidget {
  const _ResetPasswordMobileScaffold();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'auth.new_password_title'.tr(),
          style: AppTextStyles.titleLarge.copyWith(color: colors.onSurface),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'auth.new_password_subtitle'.tr(),
                style: AppTextStyles.bodyLarge.copyWith(
                  color: colors.secondaryText,
                ),
              ),
              const SizedBox(height: 28),
              const _ResetPasswordForm(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Form ──────────────────────────────────────────────────────────────────────

class _ResetPasswordForm extends StatefulWidget {
  const _ResetPasswordForm();

  @override
  State<_ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<_ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState!.save();
    await context.read<AuthCubit>().updatePassword(
          password: _newPasswordController.text.trim(),
        );
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is PasswordUpdated) {
          context.read<SessionCubit>().signOut();
          return _PasswordUpdatedView(colors: colors)
              .animate()
              .fadeIn(duration: 500.ms)
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1, 1),
                duration: 500.ms,
                curve: Curves.easeOutBack,
              );
        }

        return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthPasswordField(
                    colors: colors,
                    hint: 'auth.new_password_hint'.tr(),
                    textInputAction: TextInputAction.next,
                    controller: _newPasswordController,
                    validator: AuthValidators.password,
                  ),
                  const SizedBox(height: 16),
                  AuthPasswordField(
                    colors: colors,
                    hint: 'auth.confirm_new_password_hint'.tr(),
                    textInputAction: TextInputAction.done,
                    controller: _confirmPasswordController,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'auth.validation_confirm_password_required'.tr();
                      }
                      if (v != _newPasswordController.text) {
                        return 'auth.validation_passwords_mismatch'.tr();
                      }
                      return null;
                    },
                  ),
                  if (authState is AuthError) ...[
                    const SizedBox(height: 12),
                    AuthErrorBanner(message: authState.message, colors: colors),
                  ],
                  const SizedBox(height: 24),
                  AuthSubmitButton(
                    label: 'auth.save_new_password'.tr(),
                    isLoading: authState is AuthLoading,
                    colors: colors,
                    onPressed: _submit,
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.05, end: 0, duration: 400.ms);
      },
    );
  }
}

// ── Success view ──────────────────────────────────────────────────────────────

class _PasswordUpdatedView extends StatelessWidget {
  const _PasswordUpdatedView({required this.colors});

  final AppColorPalette colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: colors.greenAccent.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.lock_open_rounded,
            color: colors.greenAccent,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'auth.password_updated_title'.tr(),
          style: AppTextStyles.headlineMedium.copyWith(
            color: colors.onBackground,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'auth.password_updated_body'.tr(),
          style: AppTextStyles.bodyLarge.copyWith(
            color: colors.secondaryText,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => context.go(SignInScreen.routePath),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'auth.back_to_sign_in'.tr(),
              style: AppTextStyles.buttonLarge,
            ),
          ),
        ),
      ],
    );
  }
}
