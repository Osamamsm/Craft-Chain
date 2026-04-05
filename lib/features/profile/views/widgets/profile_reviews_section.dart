import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/empty_state.dart';
import 'package:craft_chain/core/widgets/section_label.dart';
import 'package:craft_chain/features/profile/model/review.dart';
import 'package:craft_chain/features/profile/views/widgets/review_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays the reviews header (label + count badge) followed by a list of
/// [ReviewCard]s, or an empty state if there are none.
///
/// Used in both the mobile layout and the web right column.
class ProfileReviewsSection extends StatelessWidget {
  const ProfileReviewsSection({super.key, required this.reviews});

  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ReviewsHeader(count: reviews.length),
        const SizedBox(height: 12),
        if (reviews.isEmpty)
          EmptyState(
            icon: Icons.rate_review_outlined,
            title: 'profile.no_reviews_title'.tr(),
            subtitle: 'profile.no_reviews_subtitle'.tr(),
          )
        else
          ...reviews.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ReviewCard(review: r),
            ),
          ),
      ],
    );
  }
}

// ── Reviews header ────────────────────────────────────────────────────────────

class _ReviewsHeader extends StatelessWidget {
  const _ReviewsHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        SectionLabel('profile.reviews'.tr()),
        if (count > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: colors.infoBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
