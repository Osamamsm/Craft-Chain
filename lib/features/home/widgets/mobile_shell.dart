import 'package:craft_chain/core/constants/constants.dart';
import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MobileShell extends StatelessWidget {
  const MobileShell({
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
      body: navigationShell,
      bottomNavigationBar: _CraftBottomNav(
        currentIndex: currentIndex,
        colors: colors,
        onTap: onTap,
      ),
    );
  }
}

class _CraftBottomNav extends StatelessWidget {
  const _CraftBottomNav({
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
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.inputBorder, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(Constants.navItems.length, (index) {
              final item = Constants.navItems[index];
              final isSelected = index == currentIndex;
              return Expanded(
                child: _BottomNavTile(
                  icon: isSelected ? item.selectedIcon : item.icon,
                  label: item.labelKey.tr(),
                  isSelected: isSelected,
                  colors: colors,
                  onTap: () => onTap(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomNavTile extends StatelessWidget {
  const _BottomNavTile({
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

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 48,
            height: 32,
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.primary.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 2),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AppTextStyles.labelUppercase.copyWith(
              color: color,
              fontSize: 10,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}
