import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/auth/viewmodels/auth_cubit/auth_cubit.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_footer.dart';
import 'package:craft_chain/features/auth/views/forgot_password_screen.dart';
import 'package:craft_chain/features/auth/views/sign_up_screen.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_email_field.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_error_banner.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_password_field.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_submit_button.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_web_layout.dart';
import 'package:craft_chain/features/auth/views/widgets/forgot_password_link.dart';
import 'package:craft_chain/features/auth/views/widgets/google_button.dart';
import 'package:craft_chain/features/auth/views/widgets/or_divider.dart';
import 'package:craft_chain/features/profile/wizard/views/profile_setup_wizard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends StatelessWidget {
  static const String routePath = '/sign-in';

  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => constraints.maxWidth >= 700
          ? AuthWebLayout(
              title: 'auth.welcome_back_title'.tr(),
              subtitle: 'auth.welcome_back_subtitle'.tr(),
              formContent: const _SignInForm(),
            )
          : const _SignInMobileScaffold(),
    );
  }
}

// ── Mobile scaffold ───────────────────────────────────────────────────────────

class _SignInMobileScaffold extends StatelessWidget {
  const _SignInMobileScaffold();

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
          'auth.sign_in'.tr(),
          style: AppTextStyles.titleLarge.copyWith(color: colors.onSurface),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'auth.sign_in_to_account'.tr(),
                style: AppTextStyles.bodyLarge.copyWith(
                  color: colors.secondaryText,
                ),
              ),
              const SizedBox(height: 28),
              const _SignInForm(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Form ──────────────────────────────────────────────────────────────────────

class _SignInForm extends StatefulWidget {
  const _SignInForm();

  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  final _formKey = GlobalKey<FormState>();
  late String _email, _password;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await context.read<AuthCubit>().signIn(
        email: _email,
        password: _password,
      );
      if (!mounted) return;
      context.push(ProfileSetupWizardScreen.routePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GoogleButton(colors: colors),
                  const SizedBox(height: 20),
                  OrDivider(colors: colors),
                  AuthEmailField(
                    colors: colors,
                    textInputAction: TextInputAction.next,
                    onChanged: (v) => setState(() => _email = v),
                    onSaved: (v) => _email = v?.trim() ?? '',
                  ),
                  const SizedBox(height: 16),
                  AuthPasswordField(
                    colors: colors,
                    hint: 'auth.password_your_hint'.tr(),
                    textInputAction: TextInputAction.done,
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'auth.validation_password_field_required'.tr()
                        : null,
                    onChanged: (v) => setState(() => _password = v),
                    onSaved: (v) => _password = v ?? '',
                  ),
                  const SizedBox(height: 8),
                  ForgotPasswordLink(
                    colors: colors,
                    onPressed: () =>
                        context.push(ForgotPasswordScreen.routePath),
                  ),
                  const SizedBox(height: 20),
                  if (authState.errorMessage != null) ...[
                    AuthErrorBanner(
                      message: authState.errorMessage!,
                      colors: colors,
                    ),
                    const SizedBox(height: 12),
                  ],
                  AuthSubmitButton(
                    label: 'auth.sign_in'.tr(),
                    isLoading: authState.isLoading,
                    colors: colors,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 20),
                  AuthFooter(
                    prompt: 'auth.no_account'.tr(),
                    actionLabel: 'auth.sign_up'.tr(),
                    onTap: () =>
                        context.pushReplacement(SignUpScreen.routePath),
                    colors: colors,
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
