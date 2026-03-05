import 'package:craft_chain/core/navigation/app_router.dart';
import 'package:craft_chain/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CraftChainApp extends StatelessWidget {
  const CraftChainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CraftChain',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
