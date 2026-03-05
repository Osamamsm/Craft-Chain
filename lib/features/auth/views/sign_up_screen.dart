import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/auth/viewmodels/auth_cubit/auth_cubit.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_footer.dart';
import 'package:craft_chain/features/auth/views/sign_in_screen.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_email_field.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_error_banner.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_name_field.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_password_field.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_submit_button.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_web_layout.dart';
import 'package:craft_chain/features/auth/views/widgets/google_button.dart';
import 'package:craft_chain/features/auth/views/widgets/or_divider.dart';
import 'package:craft_chain/features/auth/views/widgets/sign_up_info_box.dart';
import 'package:craft_chain/features/auth/views/widgets/terms_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatelessWidget {
  static const String routePath = '/sign-up';

  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => constraints.maxWidth >= 700
          ? const AuthWebLayout(
              title: 'Create your account',
              subtitle: 'Join thousands of skill traders worldwide',
              formContent: _SignUpForm(),
            )
          : const _SignUpMobileScaffold(),
    );
  }
}

// ── Mobile scaffold ───────────────────────────────────────────────────────────

class _SignUpMobileScaffold extends StatelessWidget {
  const _SignUpMobileScaffold();

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
          'Create Account',
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
                'Join skill traders worldwide',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: colors.secondaryText,
                ),
              ),
              const SizedBox(height: 28),
              const _SignUpForm(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Form ──────────────────────────────────────────────────────────────────────

class _SignUpForm extends StatefulWidget {
  const _SignUpForm();

  @override
  State<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _email, _password;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await context.read<AuthCubit>().signUp(
        fullName: _name,
        email: _email,
        password: _password,
      );
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
                  const SizedBox(height: 20),
                  AuthNameField(
                    colors: colors,
                    onSaved: (value) => setState(() => _name = value!),
                  ),
                  const SizedBox(height: 16),
                  AuthEmailField(
                    colors: colors,
                    onSaved: (value) => setState(() => _email = value!),
                  ),
                  const SizedBox(height: 16),
                  AuthPasswordField(
                    colors: colors,
                    hint: 'Create a strong password',
                    textInputAction: TextInputAction.next,
                    onChanged: (v) => setState(() => _password = v),
                    onSaved: (value) => setState(() => _password = value!),
                  ),
                  const SizedBox(height: 16),
                  AuthPasswordField(
                    colors: colors,
                    hint: 'Repeat your password',
                    textInputAction: TextInputAction.done,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (v != _password) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SignUpInfoBox(colors: colors),
                  const SizedBox(height: 16),
                  TermsCheckbox(colors: colors),
                  const SizedBox(height: 24),
                  if (authState.errorMessage != null) ...[
                    AuthErrorBanner(
                      message: authState.errorMessage!,
                      colors: colors,
                    ),
                    const SizedBox(height: 12),
                  ],
                  AuthSubmitButton(
                    label: 'Create My Account',
                    trailingIcon: Icons.arrow_forward_rounded,
                    isLoading: authState.isLoading,
                    colors: colors,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 20),
                  AuthFooter(
                    prompt: 'Already have an account?',
                    actionLabel: 'Sign In',
                    onTap: () =>
                        context.pushReplacement(SignInScreen.routePath),
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
