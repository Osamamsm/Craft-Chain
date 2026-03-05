import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Single source of truth for the CraftChain gradient branding area.
///
/// Used in two contexts:
///  • Mobile [WelcomeScreen] — `showLogo: false`, pass buttons via [bottomChild]
///  • Web split-screen (Sign Up / Sign In / Forgot Password) — `showLogo: true`
class CraftChainBrandingPanel extends StatelessWidget {
  const CraftChainBrandingPanel({
    super.key,
    this.showLogo = true,
    this.bottomChild,
  });

  final bool showLogo;

  /// Optional widget placed at the very bottom of the panel (e.g. CTA buttons
  /// on the mobile welcome screen). The panel provides vertical spacing above it.
  final Widget? bottomChild;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _BrandingLogo(),
            const SizedBox(height: 48),
            const _DemoProfileCards(),
            const SizedBox(height: 28),
            _BrandingHeadline(centered: !showLogo),
            const SizedBox(height: 12),
            _BrandingSubtitle(centered: !showLogo),
            if (bottomChild != null) ...[
              const Spacer(),
              bottomChild!,
            ] else
              const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

// ── Logo ─────────────────────────────────────────────────────────────────────

class _BrandingLogo extends StatelessWidget {
  const _BrandingLogo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 32, 40, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.link_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'CraftChain',
            style: AppTextStyles.titleLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Demo profile cards ────────────────────────────────────────────────────────

class _DemoProfileCards extends StatelessWidget {
  const _DemoProfileCards();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        height: 185,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              top: 20,
              child:
                  _ProfileCard(
                        initials: 'SA',
                        avatarColor: AppColors.avatarPurple,
                        name: 'Sara A.',
                        city: 'Cairo',
                        chips: const ['Calligraphy'],
                        chipTextColor: AppColors.avatarTeal,
                      )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: -0.1, end: 0, duration: 600.ms),
            ),
            Positioned(
              right: 0,
              top: 0,
              child:
                  _ProfileCard(
                        initials: 'KA',
                        avatarColor: AppColors.avatarGreen,
                        name: 'Khalid A.',
                        city: 'Dubai',
                        chips: const ['Flutter', 'Firebase'],
                        chipTextColor: AppColors.skillBlueText,
                      )
                      .animate(delay: 150.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: -0.1, end: 0, duration: 600.ms),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: const Center(child: _MatchBadge())
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 400.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    duration: 400.ms,
                    curve: Curves.easeOutBack,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.initials,
    required this.avatarColor,
    required this.name,
    required this.city,
    required this.chips,
    required this.chipTextColor,
  });

  final String initials;
  final Color avatarColor;
  final String name;
  final String city;
  final List<String> chips;
  final Color chipTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: avatarColor,
                child: Text(
                  initials,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      city,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: chips
                .map(
                  (chip) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: chipTextColor.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      chip,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _MatchBadge extends StatelessWidget {
  const _MatchBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.avatarGreen,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.avatarGreen.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            '94% Match!',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Headline & Subtitle ───────────────────────────────────────────────────────

class _BrandingHeadline extends StatelessWidget {
  const _BrandingHeadline({required this.centered});
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child:
          Text(
                'Trade Skills,\nGrow Together',
                textAlign: centered ? TextAlign.center : TextAlign.left,
                style: AppTextStyles.headlineLarge.copyWith(
                  color: Colors.white,
                ),
              )
              .animate(delay: 200.ms)
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.2, end: 0, duration: 500.ms),
    );
  }
}

class _BrandingSubtitle extends StatelessWidget {
  const _BrandingSubtitle({required this.centered});
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child:
          Text(
                'Exchange what you know for what you want\nto learn. No money — just knowledge.',
                textAlign: centered ? TextAlign.center : TextAlign.left,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              )
              .animate(delay: 400.ms)
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.2, end: 0, duration: 500.ms),
    );
  }
}
