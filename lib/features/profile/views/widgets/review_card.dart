import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/user_avatar.dart';
import 'package:craft_chain/features/profile/model/review.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Reviewer row ──────────────────────────────────────────────────
          Row(
            children: [
              UserAvatar(
                initials: review.reviewerInitials,
                imageUrl: review.reviewerPhotoUrl,
                radius: 18,
                colorSeed: review.reviewerId.hashCode,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.reviewerName,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: colors.onSurface,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'profile.learned_skill'.tr(
                        namedArgs: {'skill': review.skillExchanged},
                      ),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              _StarRating(rating: review.rating, colors: colors),
            ],
          ),
          const SizedBox(height: 10),
          // ── Comment ───────────────────────────────────────────────────────
          Text(
            review.comment,
            style: AppTextStyles.bodyMedium.copyWith(color: colors.onSurface),
          ),
        ],
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  const _StarRating({required this.rating, required this.colors});

  final double rating;
  final AppColorPalette colors;

  @override
  Widget build(BuildContext context) {
    const starColor = Color(0xFFF59E0B); // amber — matches Figma
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.floor();
        return Icon(
          filled ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 14,
          color: filled ? starColor : colors.inputBorder,
        );
      }),
    );
  }
}
