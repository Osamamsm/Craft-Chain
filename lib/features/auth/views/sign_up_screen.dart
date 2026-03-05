import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/utils/auth_validators.dart';
import 'package:craft_chain/features/auth/viewmodels/auth_cubit/auth_cubit.dart';
import 'package:craft_chain/features/auth/views/auth_footer.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_email_field.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_error_banner.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_name_field.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_password_field.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_submit_button.dart';
import 'package:craft_chain/features/auth/views/widgets/auth_web_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatelessWidget {
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
  String _name = '', _email = '', _password = '';
  bool _agreedToTerms = false;
  bool _autoValidate = false;

  bool get _isValid =>
      AuthValidators.fullName(_name) == null &&
      AuthValidators.email(_email) == null &&
      AuthValidators.password(_password) == null &&
      _agreedToTerms;

  Future<void> _submit() async {
    setState(() => _autoValidate = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState!.save();
    await context.read<AuthCubit>().signUp(
      fullName: _name,
      email: _email,
      password: _password,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        return Form(
              key: _formKey,
              autovalidateMode: _autoValidate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GoogleButton(colors: colors),
                  const SizedBox(height: 20),
                  _OrDivider(colors: colors),
                  const SizedBox(height: 20),
                  AuthNameField(
                    colors: colors,
                    onChanged: (v) => setState(() => _name = v),
                    onSaved: (v) => _name = v?.trim() ?? '',
                  ),
                  const SizedBox(height: 16),
                  AuthEmailField(
                    colors: colors,
                    onChanged: (v) => setState(() => _email = v),
                    onSaved: (v) => _email = v?.trim() ?? '',
                  ),
                  const SizedBox(height: 16),
                  AuthPasswordField(
                    colors: colors,
                    onChanged: (v) => setState(() => _password = v),
                    onSaved: (v) => _password = v ?? '',
                  ),
                  const SizedBox(height: 20),
                  _InfoBox(colors: colors),
                  const SizedBox(height: 16),
                  _TermsCheckbox(
                    value: _agreedToTerms,
                    colors: colors,
                    onChanged: (v) =>
                        setState(() => _agreedToTerms = v ?? false),
                  ),
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
                    enabled: _isValid && !authState.isLoading,
                    isLoading: authState.isLoading,
                    colors: colors,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 20),
                  AuthFooter(
                    prompt: 'Already have an account?',
                    actionLabel: 'Sign In',
                    onTap: () => context.go('/sign-in'),
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

// ── Sign-up-specific sub-widgets ──────────────────────────────────────────────

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({required this.colors});
  final AppColorPalette colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: colors.surface,
          foregroundColor: colors.onSurface,
          side: BorderSide(color: colors.inputBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'G',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.googleBrand,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Continue with Google',
              style: AppTextStyles.bodyLarge.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.colors});
  final AppColorPalette colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: colors.inputBorder)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or with email',
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.secondaryText,
            ),
          ),
        ),
        Expanded(child: Divider(color: colors.inputBorder)),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.colors});
  final AppColorPalette colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.infoBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: colors.primary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.onBackground,
                ),
                children: [
                  TextSpan(
                    text: 'Next step  ',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(
                    text:
                        "After signing up, you'll pick the skills you teach and want to learn.",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({
    required this.value,
    required this.onChanged,
    required this.colors,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final AppColorPalette colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.secondaryText,
                ),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
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
    );
  }
}
