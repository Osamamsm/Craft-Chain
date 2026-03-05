import 'package:craft_chain/features/auth/views/sign_up_screen.dart';
import 'package:craft_chain/features/auth/views/widgets/craft_chain_branding_panel.dart';
import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

/// On mobile: full-screen gradient with profile cards, headline, and two CTA buttons.
/// On web (≥700px): immediately renders [SignUpScreen] which already contains
/// the side-by-side branding + form split layout — no separate welcome needed.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 700) return const SignUpScreen();
        return const _WelcomeMobile();
      },
    );
  }
}

// ── Mobile welcome ────────────────────────────────────────────────────────────

class _WelcomeMobile extends StatelessWidget {
  const _WelcomeMobile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CraftChainBrandingPanel(
        showLogo: false,
        bottomChild: const _WelcomeButtons(),
      ),
    );
  }
}

class _WelcomeButtons extends StatelessWidget {
  const _WelcomeButtons();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        children: [
          _WelcomeButton(
                label: 'Get Started',
                onPressed: () => context.push('/sign-up'),
                variant: _ButtonVariant.filled,
              )
              .animate(delay: 600.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.3, end: 0, duration: 400.ms),
          const SizedBox(height: 12),
          _WelcomeButton(
                label: 'I already have an account',
                onPressed: () => context.push('/sign-in'),
                variant: _ButtonVariant.outline,
              )
              .animate(delay: 800.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.3, end: 0, duration: 400.ms),
        ],
      ),
    );
  }
}

// ── Button ────────────────────────────────────────────────────────────────────

enum _ButtonVariant { filled, outline }

class _WelcomeButton extends StatelessWidget {
  const _WelcomeButton({
    required this.label,
    required this.onPressed,
    required this.variant,
  });

  final String label;
  final VoidCallback onPressed;
  final _ButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final isFilled = variant == _ButtonVariant.filled;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: isFilled
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.light.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(label, style: AppTextStyles.buttonLarge),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(label, style: AppTextStyles.buttonLarge),
            ),
    );
  }
}
