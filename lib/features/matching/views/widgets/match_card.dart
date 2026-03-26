import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/skill_chip.dart';
import 'package:craft_chain/core/widgets/user_avatar.dart';
import 'package:craft_chain/features/matching/model/models/match_suggestion.dart';
import 'package:craft_chain/features/profile/views/profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Card widget that displays a single [MatchSuggestion] in the feed.
///
/// Tapping anywhere on the card navigates to `/profile/{userId}` via
/// `context.push()`. The card is entirely presentational — no business logic.
///
/// Layout (top → bottom):
///   1. Header row  — avatar · name · city · star rating · match %
///   2. Match bar   — thin progress bar coloured by score
///   3. Teaches     — skill chips row (green)
///   4. Wants       — skill chips row (blue)
///   5. CTA button  — "View Profile →"
class MatchCard extends StatelessWidget {
  const MatchCard({
    super.key,
    required this.suggestion,
    this.isTopMatch = false,
  });

  final MatchSuggestion suggestion;

  /// When `true`, shows a "TOP" badge over the avatar (highest score in feed).
  final bool isTopMatch;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scoreColor = _scoreColor(colors, suggestion.matchScore);

    return Card(
      margin: EdgeInsets.zero,
      color: colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.inputBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardHeader(
              suggestion: suggestion,
              isTopMatch: isTopMatch,
              scoreColor: scoreColor,
            ),
            const SizedBox(height: 10),
            _MatchBar(
              score: suggestion.matchScore,
              scoreColor: scoreColor,
              borderColor: colors.inputBorder,
            ),
            const SizedBox(height: 10),
            _SkillSection(
              labelKey: 'match.teaches',
              skills: suggestion.canTeach.take(3).toList(),
              isTeach: true,
            ),
            const SizedBox(height: 8),
            _SkillSection(
              labelKey: 'match.wants_to_learn',
              skills: suggestion.wantsToLearn.take(3).toList(),
              isTeach: false,
            ),
            const SizedBox(height: 12),
            _ViewProfileButton(colors: colors),
          ],
        ),
      ),
    );
  }

  /// Returns [AppColors.greenAccent] for top matches (≥ 90 %), primary blue
  /// otherwise. Uses a static constant so it's theme-independent.
  static Color _scoreColor(AppColorPalette colors, double score) =>
      score >= 90 ? colors.greenAccent : colors.primary;
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.suggestion,
    required this.isTopMatch,
    required this.scoreColor,
  });

  final MatchSuggestion suggestion;
  final bool isTopMatch;
  final Color scoreColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            UserAvatar(
              imageUrl: suggestion.avatarUrl,
              initials: suggestion.initials,
              colorSeed: suggestion.userId.hashCode.abs() % 4,
              radius: 23,
            ),
            if (isTopMatch)
              Positioned(bottom: -4, right: -6, child: _TopBadge()),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion.name,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: colors.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '📍 ${suggestion.city}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.secondaryText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    _StarRating(
                      rating: suggestion.rating,
                      barterCount: suggestion.barterCount,
                      colors: colors,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _ScoreBadge(score: suggestion.matchScore, color: scoreColor),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: colors.greenAccent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colors.surface, width: 1.5),
      ),
      child: Text(
        'match.top_badge'.tr(),
        style: AppTextStyles.labelUppercase.copyWith(
          color: Colors.white,
          fontSize: 8,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.score, required this.color});

  final double score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'match.match_percent'.tr(
            namedArgs: {'score': score.round().toString()},
          ),
          style: AppTextStyles.titleMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
        Text(
          'match.match_label'.tr(),
          style: AppTextStyles.bodySmall.copyWith(
            color: colors.secondaryText,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}

class _StarRating extends StatelessWidget {
  const _StarRating({
    required this.rating,
    required this.barterCount,
    required this.colors,
  });

  final double rating;
  final int barterCount;
  final AppColorPalette colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 14),
        const SizedBox(width: 3),
        Text(
          'match.rating_sessions'.tr(
            namedArgs: {
              'rating': rating.toStringAsFixed(1),
              'count': barterCount.toString(),
            },
          ),
          style: AppTextStyles.bodySmall.copyWith(
            color: colors.secondaryText,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _SkillSection extends StatelessWidget {
  const _SkillSection({
    required this.labelKey,
    required this.skills,
    required this.isTeach,
  });

  final String labelKey;
  final List<String> skills;
  final bool isTeach;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelKey.tr().toUpperCase(),
          style: AppTextStyles.labelUppercase.copyWith(
            color: colors.secondaryText,
            fontSize: 9,
          ),
        ),
        const SizedBox(height: 5),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: skills
              .map(
                (skill) => SkillChip(
                  label: skill,
                  type: isTeach ? SkillChipType.teach : SkillChipType.learn,
                  isSelected: true,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _MatchBar extends StatelessWidget {
  const _MatchBar({
    required this.score,
    required this.scoreColor,
    required this.borderColor,
  });

  final double score;
  final Color scoreColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: LinearProgressIndicator(
        value: score / 100,
        backgroundColor: borderColor,
        valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
        minHeight: 3,
      ),
    );
  }
}

class _ViewProfileButton extends StatelessWidget {
  const _ViewProfileButton({required this.colors});

  final AppColorPalette colors;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(ProfileScreen.routePath),
      child: Container(
        width: double.infinity,
        height: 36,
        decoration: BoxDecoration(
          color: colors.infoBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          'match.view_profile'.tr(),
          style: AppTextStyles.bodySmall.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
