import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/empty_state.dart';
import 'package:craft_chain/core/widgets/user_avatar.dart';
import 'package:craft_chain/features/barter/models/barter.dart';
import 'package:craft_chain/features/barter/viewmodels/barter_request_cubit/barter_request_cubit.dart';
import 'package:craft_chain/features/barter/viewmodels/barter_request_cubit/barter_request_state.dart';
import 'package:craft_chain/features/barter/views/widgets/request_skeleton_list.dart';
import 'package:craft_chain/features/barter/views/widgets/skill_exchange_pill.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SentTab extends StatelessWidget {
  const SentTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BarterRequestCubit, BarterRequestState>(
      buildWhen: (prev, curr) =>
          prev.sent != curr.sent || prev.isLoadingSent != curr.isLoadingSent,
      builder: (context, state) {
        if (state.isLoadingSent) {
          return RequestSkeletonList();
        }
        if (state.sent.isEmpty) {
          return EmptyState(
            icon: Icons.send_outlined,
            title: 'barter.sent_empty_title'.tr(),
            subtitle: 'barter.sent_empty_subtitle'.tr(),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.sent.length,
          itemBuilder: (context, index) {
            final barter = state.sent[index];
            return _SentRequestCard(barter: barter)
                .animate()
                .fadeIn(delay: (index * 60).ms, duration: 280.ms)
                .slideY(begin: 0.05, end: 0);
          },
        );
      },
    );
  }
}

class _SentRequestCard extends StatelessWidget {
  const _SentRequestCard({required this.barter});
  final BarterModel barter;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.inputBorder),
      ),
      child: Column(
        children: [
          // ── Recipient info ───────────────────────────────────────────────
          Row(
            children: [
              UserAvatar(
                initials: barter.user2Initials,
                radius: 22,
                colorSeed: barter.user2ColorSeed,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      barter.user2Name,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    Text(
                      'barter.request_pending'.tr(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              // Pending badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.infoBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'barter.pending'.tr(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Skill exchange summary ───────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: SkillExchangePill(
                  label: 'barter.you_will_teach'.tr(),
                  skill: barter.user1Teaches,
                  bgColor: colors.teachChipBg,
                  textColor: colors.teachChipText,
                  icon: Icons.school_rounded,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.swap_horiz_rounded,
                    color: colors.secondaryText, size: 18),
              ),
              Expanded(
                child: SkillExchangePill(
                  label: 'barter.you_will_learn'.tr(),
                  skill: barter.user2Teaches,
                  bgColor: colors.infoBackground,
                  textColor: colors.primary,
                  icon: Icons.auto_stories_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
