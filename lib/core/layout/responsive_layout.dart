import 'package:flutter/material.dart';

/// Switches between [mobileLayout] and [desktopLayout] at a 700-px breakpoint.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobileLayout,
    required this.desktopLayout,
  });

  final Widget mobileLayout;
  final Widget desktopLayout;

  static const double breakpoint = 700;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= breakpoint) {
          return desktopLayout;
        }
        return mobileLayout;
      },
    );
  }
}
