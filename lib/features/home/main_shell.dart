import 'package:craft_chain/core/layout/responsive_layout.dart';
import 'package:craft_chain/features/home/widgets/mobile_shell.dart';
import 'package:craft_chain/features/home/widgets/web_shell.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: MobileShell(
        navigationShell: navigationShell,
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
      ),
      desktopLayout: WebShell(
        navigationShell: navigationShell,
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
