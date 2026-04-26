import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/empty_state.dart';
import 'package:craft_chain/features/explore/view_model/explore_cubit/explore_cubit.dart';
import 'package:craft_chain/features/explore/view_model/explore_cubit/explore_state.dart';
import 'package:craft_chain/features/matching/model/models/match_suggestion.dart';
import 'package:craft_chain/features/matching/views/widgets/match_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

final _kSkeletonItems = List.generate(5, (_) => MatchSuggestion.placeholder);

class ExploreBody extends StatelessWidget {
  const ExploreBody({super.key, required this.state, required this.isWeb});

  final ExploreState state;
  final bool isWeb;

  @override
  Widget build(BuildContext context) {
    if (state is ExploreInitial) {
      return const _InitialHint();
    }

    if (state is ExploreLoading) {
      return isWeb
          ? _WebGrid(items: _kSkeletonItems, isLoading: true)
          : _MobileList(items: _kSkeletonItems, isLoading: true);
    }

    if (state is ExploreFailure) {
      return _ErrorView(
        onRetry: () {
          final query = (state as ExploreFailure).query;
          context.read<ExploreCubit>().onQueryChanged(query);
        },
      );
    }

    if (state case ExploreSuccess(results: final results)) {
      if (results.isEmpty) {
        return EmptyState(
          icon: Icons.search_off_rounded,
          title: 'explore.no_results_title'.tr(),
          subtitle: 'explore.no_results_subtitle'.tr(),
        );
      }

      return isWeb
          ? _WebGrid(items: results, isLoading: false)
          : _MobileList(items: results, isLoading: false);
    }

    return const SizedBox.shrink();
  }
}

class _InitialHint extends StatelessWidget {
  const _InitialHint();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colors.primary.withValues(alpha: 0.15),
                        colors.primary.withValues(alpha: 0.05),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.manage_search_rounded,
                    size: 36,
                    color: colors.primary,
                  ),
                )
                .animate()
                .fadeIn(duration: 400.ms)
                .scale(begin: const Offset(0.85, 0.85), duration: 400.ms),
            const SizedBox(height: 20),
            Text(
                  'explore.initial_title'.tr(),
                  style: AppTextStyles.titleMedium.copyWith(
                    color: colors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate(delay: 80.ms)
                .fadeIn(duration: 350.ms)
                .slideY(begin: 0.1, end: 0, duration: 350.ms),
            const SizedBox(height: 8),
            Text(
                  'explore.initial_subtitle'.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate(delay: 140.ms)
                .fadeIn(duration: 350.ms)
                .slideY(begin: 0.1, end: 0, duration: 350.ms),
          ],
        ),
      ),
    );
  }
}

class _MobileList extends StatelessWidget {
  const _MobileList({required this.items, required this.isLoading});

  final List<MatchSuggestion> items;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final card = MatchCard(
            key: isLoading ? null : ValueKey(items[index].userId),
            suggestion: items[index],
            showMatchScore: false,
          );

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: isLoading
                ? card
                : card
                      .animate(delay: Duration(milliseconds: (index % 10) * 60))
                      .fadeIn(duration: 300.ms)
                      .slideY(
                        begin: 0.08,
                        end: 0,
                        duration: 300.ms,
                        curve: Curves.easeOut,
                      ),
          );
        },
      ),
    );
  }
}

class _WebGrid extends StatelessWidget {
  const _WebGrid({required this.items, required this.isLoading});

  final List<MatchSuggestion> items;
  final bool isLoading;

  static const double _minCardWidth = 280;
  static const double _spacing = 16;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final available = constraints.maxWidth - 44;
          final columns = ((available + _spacing) / (_minCardWidth + _spacing))
              .floor()
              .clamp(1, 4);
          final cardWidth = (available - _spacing * (columns - 1)) / columns;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Wrap(
              spacing: _spacing,
              runSpacing: _spacing,
              children: List.generate(items.length, (index) {
                final card = SizedBox(
                  key: isLoading ? null : ValueKey(items[index].userId),
                  width: cardWidth,
                  child: MatchCard(
                    suggestion: items[index],
                    showMatchScore: false,
                  ),
                );

                return isLoading
                    ? card
                    : card
                          .animate(
                            delay: Duration(milliseconds: (index % 10) * 50),
                          )
                          .fadeIn(duration: 280.ms)
                          .slideY(
                            begin: 0.08,
                            end: 0,
                            duration: 280.ms,
                            curve: Curves.easeOut,
                          );
              }),
            ),
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 48, color: colors.secondaryText),
            const SizedBox(height: 16),
            Text(
              'explore.error_generic'.tr(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 140,
              child: ElevatedButton(
                onPressed: onRetry,
                child: Text('explore.retry'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
