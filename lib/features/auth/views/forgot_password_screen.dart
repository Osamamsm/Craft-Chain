import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/utils/auth_validators.dart';
import 'package:craft_chain/features/auth/viewmodels/auth_cubit/auth_cubit.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_email_field.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_error_banner.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_submit_button.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_web_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => constraints.maxWidth >= 700
          ? const AuthWebLayout(
              title: 'Reset your password',
              subtitle: "Enter your email and we'll send you a reset link",
              formContent: _ForgotPasswordForm(),
            )
          : const _ForgotPasswordMobileScaffold(),
    );
  }
}

// ── Mobile scaffold ───────────────────────────────────────────────────────────

class _ForgotPasswordMobileScaffold extends StatelessWidget {
  const _ForgotPasswordMobileScaffold();

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
          'Reset Password',
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
                "Enter your email and we'll send you a reset link",
                style: AppTextStyles.bodyLarge.copyWith(
                  color: colors.secondaryText,
                ),
              ),
              const SizedBox(height: 28),
              const _ForgotPasswordForm(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Form ──────────────────────────────────────────────────────────────────────

class _ForgotPasswordForm extends StatefulWidget {
  const _ForgotPasswordForm();

  @override
  State<_ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<_ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  bool _autoValidate = false;

  bool get _isValid => AuthValidators.email(_email) == null;

  Future<void> _submit() async {
    setState(() => _autoValidate = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState!.save();
    await context.read<AuthCubit>().resetPassword(email: _email);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState.isPasswordResetSent) {
          return _SuccessView(
            colors: colors,
            onBackToSignIn: () => context.go('/sign-in'),
          );
        }
        return Form(
              key: _formKey,
              autovalidateMode: _autoValidate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthEmailField(
                    colors: colors,
                    textInputAction: TextInputAction.done,
                    onChanged: (v) => setState(() => _email = v),
                    onSaved: (v) => _email = v?.trim() ?? '',
                  ),
                  if (authState.errorMessage != null) ...[
                    const SizedBox(height: 12),
                    AuthErrorBanner(
                      message: authState.errorMessage!,
                      colors: colors,
                    ),
                  ],
                  const SizedBox(height: 24),
                  AuthSubmitButton(
                    label: 'Send Reset Link',
                    enabled: _isValid && !authState.isLoading,
                    isLoading: authState.isLoading,
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

// ── Success state ─────────────────────────────────────────────────────────────

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.colors, required this.onBackToSignIn});
  final AppColorPalette colors;
  final VoidCallback onBackToSignIn;

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
                Icons.mark_email_read_outlined,
                color: colors.greenAccent,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Check your email!',
              style: AppTextStyles.headlineMedium.copyWith(
                color: colors.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "We've sent a password reset link to your email.\nCheck your inbox and follow the instructions.",
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
                onPressed: onBackToSignIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Back to Sign In',
                  style: AppTextStyles.buttonLarge,
                ),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          duration: 500.ms,
          curve: Curves.easeOutBack,
        );
  }
}
