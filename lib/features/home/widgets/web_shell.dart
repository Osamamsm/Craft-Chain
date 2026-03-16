import 'package:craft_chain/core/constants/constants.dart';
import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WebShell extends StatelessWidget {
  const WebShell({
    super.key,
    required this.navigationShell,
    required this.currentIndex,
    required this.onTap,
  });

  final StatefulNavigationShell navigationShell;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      body: Row(
        children: [
          _CraftSidebar(
            currentIndex: currentIndex,
            colors: colors,
            onTap: onTap,
          ),
          VerticalDivider(width: 1, color: colors.inputBorder),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}

class _CraftSidebar extends StatelessWidget {
  const _CraftSidebar({
    required this.currentIndex,
    required this.colors,
    required this.onTap,
  });

  final int currentIndex;
  final AppColorPalette colors;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: colors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [colors.gradientStart, colors.gradientEnd],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.link_rounded,
                      color: colors.onPrimary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'CraftChain',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: List.generate(Constants.navItems.length, (index) {
                  final item = Constants.navItems[index];
                  final isSelected = index == currentIndex;
                  return _SidebarNavTile(
                    icon: isSelected ? item.selectedIcon : item.icon,
                    label: item.labelKey.tr(),
                    isSelected: isSelected,
                    colors: colors,
                    onTap: () => onTap(index),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarNavTile extends StatelessWidget {
  const _SidebarNavTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.colors,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final AppColorPalette colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = colors.primary;
    final inactiveColor = colors.secondaryText;
    final color = isSelected ? activeColor : inactiveColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: color,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                  if (isSelected) ...[
                    const Spacer(),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: activeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
