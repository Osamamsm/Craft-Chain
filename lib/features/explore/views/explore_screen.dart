import 'package:craft_chain/core/layout/responsive_layout.dart';
import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/explore/view_model/explore_cubit/explore_cubit.dart';
import 'package:craft_chain/features/explore/view_model/explore_cubit/explore_state.dart';
import 'package:craft_chain/features/explore/views/widgets/explore_body.dart';
import 'package:craft_chain/features/explore/views/widgets/search_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  static const String routePath = '/explore';

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileLayout: _MobileView(),
      desktopLayout: _DesktopView(),
    );
  }
}

class _MobileView extends StatelessWidget {
  const _MobileView();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        titleSpacing: 16,
        title: Text(
          'explore.title'.tr(),
          style: AppTextStyles.titleLarge.copyWith(color: colors.onSurface),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SearchBar(colors: colors),
          ),
        ),
      ),
      body: BlocBuilder<ExploreCubit, ExploreState>(
        builder: (context, state) => ExploreBody(state: state, isWeb: false),
      ),
    );
  }
}

class _DesktopView extends StatelessWidget {
  const _DesktopView();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: colors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Text(
                  'explore.title'.tr(),
                  style: AppTextStyles.titleLarge.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: SearchBar(colors: colors),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.inputBorder),
          Expanded(
            child: BlocBuilder<ExploreCubit, ExploreState>(
              builder: (context, state) =>
                  ExploreBody(state: state, isWeb: true),
            ),
          ),
        ],
      ),
    );
  }
}
