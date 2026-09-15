import 'package:craft_chain/core/di/injection.dart';
import 'package:craft_chain/core/navigation/app_router.dart';
import 'package:craft_chain/core/theme/app_theme.dart';
import 'package:craft_chain/features/auth/presentation/Cubits/session_cubit/session_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class CraftChainApp extends StatelessWidget {
  const CraftChainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SessionCubit>()..checkAuthStatus(),
      child: MaterialApp.router(
        title: 'CraftChain',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.light,
        routerConfig: appRouter,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: [
          ...context.localizationDelegates,
          ...GlobalMaterialLocalizations.delegates,
        ],
      ),
    );
  }
}
