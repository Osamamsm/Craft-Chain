import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/empty_state.dart';
import 'package:craft_chain/core/widgets/user_avatar.dart';
import 'package:craft_chain/features/barter/domain/entities/received_barter_request.dart';
import 'package:craft_chain/features/barter/presentation/logic/cubit/received_requests_cubit.dart';
import 'package:craft_chain/features/barter/presentation/views/widgets/request_skeleton_list.dart';
import 'package:craft_chain/features/barter/presentation/views/widgets/skill_exchange_pill.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceivedTab extends StatelessWidget {
  const ReceivedTab({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocListener<ReceivedRequestsCubit, ReceivedRequestsState>(
      listenWhen: (_, current) =>
          current is ReceivedRequestsSuccess && current.feedback != null,
      listener: (context, state) {
        final feedback = (state as ReceivedRequestsSuccess).feedback!;

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: feedback.isError ? colors.error : null,
              content: Text(feedback.message),
            ),
          );

        if (!feedback.isError &&
            feedback.action == ReceivedRequestAction.accept) {
          // TODO: context.read<YourChatsCubit>().getActiveBarters();
        }
      },
      child: BlocBuilder<ReceivedRequestsCubit, ReceivedRequestsState>(
        builder: (context, state) {
          if (state is ReceivedRequestsFailure) {
            return EmptyState(
              onRefresh: () =>
                  context.read<ReceivedRequestsCubit>().getReceivedRequests(),
              icon: Icons.error_outline_rounded,
              title: 'barter.load_failed_title'.tr(),
              subtitle: state.message,
            );
          }
          if (state is! ReceivedRequestsSuccess) {
            // Initial / Loading
            return RequestSkeletonList();
          }
          if (state.requests.isEmpty) {
            return EmptyState(
              onRefresh: () =>
                  context.read<ReceivedRequestsCubit>().getReceivedRequests(),
              icon: Icons.inbox_outlined,
              title: 'barter.received_empty_title'.tr(),
              subtitle: 'barter.received_empty_subtitle'.tr(),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.requests.length,
            itemBuilder: (context, index) {
              final barter = state.requests[index];
              return _ReceivedRequestCard(barter: barter)
                  // Keyed so removing a card doesn't replay the others' animation.
                  .animate(key: ValueKey(barter.barterId))
                  .fadeIn(delay: (index * 60).ms, duration: 280.ms)
                  .slideY(begin: 0.05, end: 0);
            },
          );
        },
      ),
    );
  }
}

class _ReceivedRequestCard extends StatelessWidget {
  const _ReceivedRequestCard({required this.barter});
  final ReceivedBarterRequest barter;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.read<ReceivedRequestsCubit>();

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
                initials: barter.requester.initial,
                radius: 22,
                imageUrl: barter.requester.photoUrl,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      barter.requester.fullName,
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
                  skill: barter.willTeachYou,
                  bgColor: colors.teachChipBg,
                  textColor: colors.teachChipText,
                  icon: Icons.school_rounded,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.swap_horiz_rounded,
                  color: colors.secondaryText,
                  size: 18,
                ),
              ),
              Expanded(
                child: SkillExchangePill(
                  label: 'barter.wants_to_learn'.tr(),
                  skill: barter.wantsToLearn,
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
                  onPressed: () => cubit.rejectRequest(barter.barterId),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.error,
                    side: BorderSide(color: colors.error),
                    minimumSize: const Size(0, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                      borderRadius: BorderRadius.circular(10),
                    ),
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