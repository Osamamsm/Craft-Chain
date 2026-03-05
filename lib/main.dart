import 'package:craft_chain/app.dart';
import 'package:craft_chain/core/di/injection.dart';
import 'package:craft_chain/features/auth/viewmodels/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthCubit>()),
      ],
      child: const CraftChainApp(),
    ),
  );
}