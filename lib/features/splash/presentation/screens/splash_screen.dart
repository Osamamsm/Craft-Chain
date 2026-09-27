import 'package:material_ui/material_ui.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const routePath = '/splash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(children: [Text('CraftChain')])),
    );
  }
}
