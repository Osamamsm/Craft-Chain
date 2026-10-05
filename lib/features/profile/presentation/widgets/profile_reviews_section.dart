import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/section_label.dart';
import 'package:craft_chain/features/profile/data/models/review.dart';
import 'package:craft_chain/features/profile/presentation/widgets/review_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';

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
          _EmptyReviews()
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

// ── Inline empty placeholder ───────────────────────────────────────────────────

class _EmptyReviews extends StatelessWidget {
  const _EmptyReviews();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colors.surface2,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.rate_review_outlined,
                size: 26,
                color: colors.secondaryText,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'profile.no_reviews_title'.tr(),
              style: AppTextStyles.titleMedium.copyWith(
                color: colors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'profile.no_reviews_subtitle'.tr(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
