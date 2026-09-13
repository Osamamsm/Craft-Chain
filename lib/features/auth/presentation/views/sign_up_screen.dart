import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/auth/presentation/Cubits/auth_cubit/auth_cubit.dart';
import 'package:craft_chain/features/auth/presentation/Cubits/auth_cubit/auth_state.dart';
import 'package:craft_chain/features/auth/presentation/widgets/auth_footer.dart';
import 'package:craft_chain/features/auth/presentation/views/sign_in_screen.dart';
import 'package:craft_chain/features/auth/presentation/widgets/auth_email_field.dart';
import 'package:craft_chain/features/auth/presentation/widgets/auth_error_banner.dart';
import 'package:craft_chain/features/auth/presentation/widgets/auth_name_field.dart';
import 'package:craft_chain/features/auth/presentation/widgets/auth_password_field.dart';
import 'package:craft_chain/features/auth/presentation/widgets/auth_submit_button.dart';
import 'package:craft_chain/features/auth/presentation/widgets/auth_web_layout.dart';
import 'package:craft_chain/features/auth/presentation/widgets/google_button.dart';
import 'package:craft_chain/features/auth/presentation/widgets/or_divider.dart';
import 'package:craft_chain/features/auth/presentation/widgets/sign_up_info_box.dart';
import 'package:craft_chain/features/auth/presentation/widgets/terms_checkbox.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:craft_chain/core/layout/responsive_layout.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatelessWidget {
  static const String routePath = '/sign-up';

  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: const _SignUpMobileScaffold(),
      desktopLayout: AuthWebLayout(
        title: 'auth.sign_up_title'.tr(),
        subtitle: 'auth.sign_up_subtitle'.tr(),
        formContent: const _SignUpForm(),
      ),
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
          'auth.create_account'.tr(),
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
                'auth.join_skill_traders'.tr(),
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
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await context.read<AuthCubit>().signUp(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                    controller: _nameController,
                  ),
                  const SizedBox(height: 16),
                  AuthEmailField(
                    colors: colors,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 16),
                  AuthPasswordField(
                    colors: colors,
                    hint: 'auth.password_create_hint'.tr(),
                    textInputAction: TextInputAction.next,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 16),
                  AuthPasswordField(
                    colors: colors,
                    hint: 'auth.password_repeat_hint'.tr(),
                    textInputAction: TextInputAction.done,
                    controller: _confirmPasswordController,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'auth.validation_confirm_password_required'.tr();
                      }
                      if (v != _passwordController.text) {
                        return 'auth.validation_passwords_mismatch'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SignUpInfoBox(colors: colors),
                  const SizedBox(height: 16),
                  TermsCheckbox(colors: colors),
                  const SizedBox(height: 24),
                  if (authState is AuthError) ...[
                    AuthErrorBanner(message: authState.message, colors: colors),
                    const SizedBox(height: 12),
                  ],
                  AuthSubmitButton(
                    label: 'auth.create_my_account'.tr(),
                    trailingIcon: Icons.arrow_forward_rounded,
                    isLoading: authState is AuthLoading,
                    colors: colors,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 20),
                  AuthFooter(
                    prompt: 'auth.already_have_account'.tr(),
                    actionLabel: 'auth.sign_in'.tr(),
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
