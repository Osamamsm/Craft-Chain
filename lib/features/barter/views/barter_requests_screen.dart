import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BarterRequestsScreen extends StatelessWidget {
  const BarterRequestsScreen({super.key});

  static const String routePath = '/barters';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('barter.my_barters'.tr())),
      body: const SizedBox.shrink(),
    );
  }
}
