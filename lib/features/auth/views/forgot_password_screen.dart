import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/auth/viewmodels/auth_cubit/auth_cubit.dart';
import 'package:craft_chain/features/auth/views/sign_in_screen.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_email_field.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_error_banner.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_submit_button.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_web_layout.dart';
import 'package:craft_chain/features/auth/views/widgets/password_reset_success_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const String routePath = '/forgot-password';

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

  Future<void> _submit() async {
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
          return PasswordResetSuccessView(
            colors: colors,
            onBackToSignIn: () => context.go(SignInScreen.routePath),
          );
        }
        return Form(
              key: _formKey,
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
