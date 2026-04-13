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

class ReceivedTab extends StatelessWidget {
  const ReceivedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BarterRequestCubit, BarterRequestState>(
      buildWhen: (prev, curr) =>
          prev.received != curr.received ||
          prev.isLoadingReceived != curr.isLoadingReceived,
      builder: (context, state) {
        if (state.isLoadingReceived) {
          return RequestSkeletonList();
        }
        if (state.received.isEmpty) {
          return EmptyState(
            icon: Icons.inbox_outlined,
            title: 'barter.received_empty_title'.tr(),
            subtitle: 'barter.received_empty_subtitle'.tr(),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.received.length,
          itemBuilder: (context, index) {
            final barter = state.received[index];
            return _ReceivedRequestCard(barter: barter)
                .animate()
                .fadeIn(delay: (index * 60).ms, duration: 280.ms)
                .slideY(begin: 0.05, end: 0);
          },
        );
      },
    );
  }
}

class _ReceivedRequestCard extends StatelessWidget {
  const _ReceivedRequestCard({required this.barter});
  final BarterModel barter;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.read<BarterRequestCubit>();

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
          // ── Requester info ───────────────────────────────────────────────
          Row(
            children: [
              UserAvatar(
                initials: barter.user1Initials,
                radius: 22,
                colorSeed: barter.user1ColorSeed,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      barter.user1Name,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    Text(
                      'barter.wants_to_barter'.tr(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Skill exchange pills ─────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: SkillExchangePill(
                  label: 'barter.will_teach_you'.tr(),
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
                  label: 'barter.wants_to_learn'.tr(),
                  skill: barter.user2Teaches,
                  bgColor: colors.infoBackground,
                  textColor: colors.primary,
                  icon: Icons.auto_stories_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Action buttons ───────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => cubit.declineRequest(barter.barterId),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.error,
                    side: BorderSide(color: colors.error),
                    minimumSize: const Size(0, 44),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('barter.decline'.tr()),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => cubit.acceptRequest(barter.barterId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.greenAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 44),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('barter.accept'.tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
