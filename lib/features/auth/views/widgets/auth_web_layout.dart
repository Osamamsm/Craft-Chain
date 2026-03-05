import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/auth/views/widgets/craft_chain_branding_panel.dart';
import 'package:flutter/material.dart';

/// Shared 50/50 split scaffold for all web auth screens.
/// Left: [CraftChainBrandingPanel]. Right: title + subtitle + [formContent].
class AuthWebLayout extends StatelessWidget {
  const AuthWebLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.formContent,
  });

  final String title;
  final String subtitle;
  final Widget formContent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      body: Row(
        children: [
          const Expanded(child: CraftChainBrandingPanel()),
          Expanded(
            child: Container(
              color: colors.background,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 64,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: colors.onBackground,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: colors.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 32),
                        formContent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
