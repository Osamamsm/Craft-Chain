import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/empty_state.dart';
import 'package:craft_chain/features/matching/model/models/match_suggestion.dart';
import 'package:craft_chain/features/matching/view_model/match_feed_cubit/match_feed_cubit.dart';
import 'package:craft_chain/features/matching/view_model/match_feed_cubit/match_feed_state.dart';
import 'package:craft_chain/features/matching/views/widgets/match_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

final _kSkeletonItems = List.generate(
  5,
  (_) => const MatchSuggestion(
    userId: 'skeleton',
    name: 'Loading Name Here',
    city: 'Some City',
    canTeach: ['Skill One', 'Skill Two', 'Three'],
    wantsToLearn: ['Learn A', 'Learn B'],
    matchScore: 82,
    rating: 4.5,
    barterCount: 8,
  ),
);

class FeedBody extends StatelessWidget {
  const FeedBody({super.key, required this.state, required this.isWeb});

  final MatchFeedState state;
  final bool isWeb;

  @override
  Widget build(BuildContext context) {
    if (state is MatchFeedInitial || state is MatchFeedLoading) {
      return isWeb
          ? _WebGrid(items: _kSkeletonItems, isLoading: true)
          : _MobileList(items: _kSkeletonItems, isLoading: true);
    }

    if (state is MatchFeedFailure) {
      return _ErrorView(
        onRetry: () => context.read<MatchFeedCubit>().loadMatches(),
      );
    }

    if (state case MatchFeedSuccess(:final matches)) {
      if (matches.isEmpty) {
        return EmptyState(
          icon: Icons.people_outline_rounded,
          title: 'match.no_matches_title'.tr(),
          subtitle: 'match.no_matches_subtitle'.tr(),
        );
      }

      return isWeb
          ? _WebGrid(items: matches, isLoading: false)
          : _MobileList(items: matches, isLoading: false);
    }

    return const SizedBox.shrink();
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
          final isTop = index == 0 && !isLoading;
          final card = MatchCard(
            key: isLoading ? null : ValueKey(items[index].userId),
            suggestion: items[index],
            isTopMatch: isTop,
          );

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: isLoading
                ? card
                : card
                      .animate(delay: Duration(milliseconds: (index % 10) * 60))
                      .fadeIn(duration: 320.ms)
                      .slideY(
                        begin: 0.1,
                        end: 0,
                        duration: 320.ms,
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
                final isTop = index == 0 && !isLoading;
                final card = SizedBox(
                  key: isLoading ? null : ValueKey(items[index].userId),
                  width: cardWidth,
                  child: MatchCard(suggestion: items[index], isTopMatch: isTop),
                );

                return isLoading
                    ? card
                    : card
                          .animate(
                            delay: Duration(milliseconds: (index % 10) * 50),
                          )
                          .fadeIn(duration: 300.ms)
                          .slideY(
                            begin: 0.08,
                            end: 0,
                            duration: 300.ms,
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
              'match.error_generic'.tr(),
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
                child: Text('match.retry'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
