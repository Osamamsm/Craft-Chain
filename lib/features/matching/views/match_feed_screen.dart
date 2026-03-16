import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MatchFeedScreen extends StatelessWidget {
  const MatchFeedScreen({super.key});

  static const String routePath = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('home.your_matches'.tr())),
      body: const SizedBox.shrink(),
    );
  }
}
