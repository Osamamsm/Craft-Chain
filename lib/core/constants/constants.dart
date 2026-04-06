import 'package:flutter/material.dart';

class Constants {
  static const List<NavItem> navItems = [
    NavItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      labelKey: 'nav.home',
    ),
    NavItem(
      icon: Icons.search_outlined,
      selectedIcon: Icons.search_rounded,
      labelKey: 'nav.explore',
    ),
    NavItem(
      icon: Icons.swap_horiz_outlined,
      selectedIcon: Icons.swap_horiz_rounded,
      labelKey: 'nav.barters',
    ),
    NavItem(
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      labelKey: 'nav.profile',
    ),
  ];

static String kFakeCurrentUserId = 'u1';

}

class NavItem {
  const NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.labelKey,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String labelKey;
}
