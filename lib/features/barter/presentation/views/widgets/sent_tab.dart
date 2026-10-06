import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/empty_state.dart';
import 'package:craft_chain/core/widgets/user_avatar.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_status.dart';
import 'package:craft_chain/features/barter/domain/entities/sent_barter_request.dart';
import 'package:craft_chain/features/barter/presentation/logic/sent_requests_cubit/sent_requests_cubit.dart';
import 'package:craft_chain/features/barter/presentation/views/widgets/request_skeleton_list.dart';
import 'package:craft_chain/features/barter/presentation/views/widgets/skill_exchange_pill.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SentTab extends StatelessWidget {
  const SentTab({super.key});

  @override
  Widget build(BuildContext context) {
    // The listener shows the snackbar after a cancel (success or error);
    // the builder only ever renders the list.
    return BlocListener<GetSentRequestsCubit, GetSentRequestsState>(
      listenWhen: (_, current) =>
          current is GetSentRequestsSuccess && current.feedback != null,
      listener: (context, state) {
        final feedback = (state as GetSentRequestsSuccess).feedback!;
        final messenger = ScaffoldMessenger.of(context);
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor:
                  feedback.isError ? Theme.of(context).colorScheme.error : null,
              content: Text(feedback.message),
            ),
          );
      },
      child: BlocBuilder<GetSentRequestsCubit, GetSentRequestsState>(
        builder: (context, state) {
          if (state is GetSentRequestsSuccess && state.requests.isEmpty) {
            return EmptyState(
              onRefresh: () => Future.delayed(Duration.zero),
              icon: Icons.send_outlined,
              title: 'barter.sent_empty_title'.tr(),
              subtitle: 'barter.sent_empty_subtitle'.tr(),
            );
          }
          if (state is GetSentRequestsSuccess) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.requests.length,
              itemBuilder: (context, index) {
                final barter = state.requests[index];
                return _SentRequestCard(barter: barter)
                    .animate()
                    .fadeIn(delay: (index * 60).ms, duration: 280.ms)
                    .slideY(begin: 0.05, end: 0);
              },
            );
          }
          return RequestSkeletonList();
        },
      ),
    );
  }
}

class _SentRequestCard extends StatelessWidget {
  const _SentRequestCard({required this.barter});
  final SentBarterRequest barter;

  /// Subtitle under the recipient's name, based on the request status.
  String _subtitle() => switch (barter.status) {
        BarterStatus.rejected => 'barter.request_rejected'.tr(),
        BarterStatus.cancelled => 'barter.request_cancelled'.tr(),
        _ => 'barter.request_pending'.tr(),
      };

  /// Cancelling can't be undone, so ask first.
  Future<void> _confirmCancel(BuildContext context) async {
    final errorColor = Theme.of(context).colorScheme.error;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('barter.cancel_confirm_title'.tr()),
        content: Text(
          'barter.cancel_confirm_message'.tr(args: [barter.recipient.fullName]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('barter.keep_request'.tr()),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: errorColor),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text('barter.cancel_request'.tr()),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<GetSentRequestsCubit>().cancelRequest(barter.barterId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final errorColor = Theme.of(context).colorScheme.error;

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
                initials: barter.recipient.initial,
                radius: 22,
                imageUrl: barter.recipient.photoUrl,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      barter.recipient.fullName,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    Text(
                      _subtitle(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              // Status badge (pending / rejected / cancelled)
              _StatusBadge(status: barter.status),
            ],
          ),

          const SizedBox(height: 14),

          // ── Skill exchange summary ───────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: SkillExchangePill(
                  label: 'barter.you_will_teach'.tr(),
                  skill: barter.youWillTeach,
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
                  label: 'barter.you_will_learn'.tr(),
                  skill: barter.youWillLearn,
                  bgColor: colors.infoBackground,
                  textColor: colors.primary,
                  icon: Icons.auto_stories_rounded,
                ),
              ),
            ],
          ),

          // ── Cancel (pending only) ────────────────────────────────────────
          // Optimistic cancel flips the status right away, so the button
          // collapses smoothly instead of popping out.
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: barter.status == BarterStatus.pending
                ? Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _confirmCancel(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: errorColor,
                          side: BorderSide(color: errorColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('barter.cancel_request'.tr()),
                      ),
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final BarterStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Swap for your own error token if AppColors has one.
    final errorColor = Theme.of(context).colorScheme.error;

    final (Color color, Color background, String label) = switch (status) {
      BarterStatus.rejected => (
          errorColor,
          errorColor.withValues(alpha: 0.1),
          'barter.rejected'.tr(),
        ),
      BarterStatus.cancelled => (
          colors.secondaryText,
          colors.secondaryText.withValues(alpha: 0.12),
          'barter.cancelled'.tr(),
        ),
      // pending (the Sent tab only ever receives pending / rejected / cancelled)
      _ => (
          colors.primary,
          colors.infoBackground,
          'barter.pending'.tr(),
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}