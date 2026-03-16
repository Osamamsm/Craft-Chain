import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  static const String routePath = '/explore';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('explore.title'.tr())),
      body: const SizedBox.shrink(),
    );
  }
}
