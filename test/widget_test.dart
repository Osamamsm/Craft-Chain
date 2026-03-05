import 'package:craft_chain/app.dart';
import 'package:craft_chain/core/di/injection.dart';
import 'package:craft_chain/features/auth/viewmodels/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    configureDependencies();
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => getIt<AuthCubit>(),
        child: const CraftChainApp(),
      ),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
