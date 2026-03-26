import 'package:craft_chain/core/layout/responsive_layout.dart';
import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/matching/view_model/match_feed_cubit/match_feed_cubit.dart';
import 'package:craft_chain/features/matching/view_model/match_feed_cubit/match_feed_state.dart';
import 'package:craft_chain/features/matching/views/widgets/feed_body.dart';
import 'package:craft_chain/features/matching/views/widgets/filter_chips_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchFeedScreen extends StatelessWidget {
  const MatchFeedScreen({super.key});

  static const String routePath = '/match-feed';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MatchFeedCubit()..loadMatches(),
      child: const ResponsiveLayout(
        mobileLayout: _MobileView(),
        desktopLayout: _WebView(),
      ),
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'home.your_matches'.tr(),
              style: AppTextStyles.titleLarge.copyWith(color: colors.onSurface),
            ),
            BlocBuilder<MatchFeedCubit, MatchFeedState>(
              buildWhen: (prev, curr) =>
                  curr is MatchFeedSuccess &&
                  (prev is! MatchFeedSuccess ||
                      prev.matches.length != curr.matches.length),
              builder: (context, state) {
                final count = state is MatchFeedSuccess
                    ? state.matches.length
                    : 0;
                return Text(
                  count == 0
                      ? 'match.discover_people'.tr()
                      : 'match.new_today'.tr(namedArgs: {'count': '$count'}),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.secondaryText,
                  ),
                );
              },
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            height: 48,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(bottom: BorderSide(color: colors.inputBorder)),
            ),
            child: BlocBuilder<MatchFeedCubit, MatchFeedState>(
              buildWhen: (prev, curr) =>
                  curr is MatchFeedSuccess &&
                  (prev is! MatchFeedSuccess ||
                      prev.selectedFilter != curr.selectedFilter),
              builder: (context, state) {
                final filter = state is MatchFeedSuccess
                    ? state.selectedFilter
                    : MatchFeedFilter.all;
                return FilterChipsBar(
                  selectedFilter: filter,
                  onFilterSelected: context.read<MatchFeedCubit>().setFilter,
                );
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<MatchFeedCubit, MatchFeedState>(
        builder: (context, state) => FeedBody(state: state, isWeb: false),
      ),
    );
  }
}

class _WebView extends StatelessWidget {
  const _WebView();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            color: colors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'home.your_matches'.tr(),
                      style: AppTextStyles.titleLarge.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    BlocBuilder<MatchFeedCubit, MatchFeedState>(
                      buildWhen: (prev, curr) =>
                          curr is MatchFeedSuccess &&
                          (prev is! MatchFeedSuccess ||
                              prev.matches.length != curr.matches.length),
                      builder: (context, state) {
                        final count = state is MatchFeedSuccess
                            ? state.matches.length
                            : 0;
                        return Text(
                          count == 0
                              ? 'match.discover_people'.tr()
                              : 'match.new_today'.tr(
                                  namedArgs: {'count': '$count'},
                                ),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colors.secondaryText,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const Spacer(),
                BlocBuilder<MatchFeedCubit, MatchFeedState>(
                  buildWhen: (prev, curr) =>
                      curr is MatchFeedSuccess &&
                      (prev is! MatchFeedSuccess ||
                          prev.selectedFilter != curr.selectedFilter),
                  builder: (context, state) {
                    final filter = state is MatchFeedSuccess
                        ? state.selectedFilter
                        : MatchFeedFilter.all;
                    return FilterChipsBar(
                      selectedFilter: filter,
                      onFilterSelected: context
                          .read<MatchFeedCubit>()
                          .setFilter,
                      padding: EdgeInsets.zero,
                    );
                  },
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.inputBorder),
          Expanded(
            child: BlocBuilder<MatchFeedCubit, MatchFeedState>(
              builder: (context, state) => FeedBody(state: state, isWeb: true),
            ),
          ),
        ],
      ),
    );
  }
}
