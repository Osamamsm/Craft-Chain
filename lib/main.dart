import 'package:craft_chain/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'CraftChain',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
      home: const Scaffold(body: Center(child: Text('CraftChain'))),
    ),
  );
}
