import 'package:craft_chain/core/di/injection.dart';
import 'package:craft_chain/core/layout/responsive_layout.dart';
import 'package:craft_chain/features/barter/viewmodels/barter_request_cubit/barter_request_cubit.dart';
import 'package:craft_chain/features/barter/views/widgets/desktop_barter_view_body.dart';
import 'package:craft_chain/features/barter/views/widgets/mobile_barter_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BarterRequestsView extends StatelessWidget {
  const BarterRequestsView({super.key});

  static const String routePath = '/barters';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BarterRequestCubit>(),
      child: const _BarterRequestsViewBody(),
    );
  }
}

class _BarterRequestsViewBody extends StatelessWidget {
  const _BarterRequestsViewBody();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: const MobileBarterViewBody(),
      desktopLayout: const DesktopBarterViewBody(),
    );
  }
}
