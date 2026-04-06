import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/empty_state.dart';
import 'package:craft_chain/features/barter/models/barter.dart';
import 'package:craft_chain/features/barter/viewmodels/barter_request_cubit/barter_request_cubit.dart';
import 'package:craft_chain/features/barter/viewmodels/barter_request_cubit/barter_request_state.dart';
import 'package:craft_chain/features/barter/views/widgets/barter_chat_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BarterRequestCubit, BarterRequestState>(
      buildWhen: (prev, curr) =>
          prev.chats != curr.chats || prev.isLoadingChats != curr.isLoadingChats,
      builder: (context, state) {
        if (state.isLoadingChats) {
          return _ChatsSkeletonList();
        }
        if (state.chats.isEmpty) {
          return EmptyState(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'barter.chats_empty_title'.tr(),
            subtitle: 'barter.chats_empty_subtitle'.tr(),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: state.chats.length,
          separatorBuilder: (ctx, idx) => Divider(
            height: 1,
            indent: 76,
            color: context.colors.inputBorder,
          ),
          itemBuilder: (context, index) {
            final barter = state.chats[index];
            return _DismissibleChatTile(barter: barter);
          },
        );
      },
    );
  }
}


class _DismissibleChatTile extends StatelessWidget {
  const _DismissibleChatTile({required this.barter});
  final BarterModel barter;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.read<BarterRequestCubit>();

    return Dismissible(
      key: ValueKey(barter.barterId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: colors.error.withValues(alpha: 0.12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline_rounded, color: colors.error, size: 24),
            const SizedBox(height: 2),
            Text(
              'barter.delete'.tr(),
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (_) async => true,
      onDismissed: (_) {
        cubit.hideChat(barter.barterId);
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('barter.chat_hidden'.tr()),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'barter.undo'.tr(),
                onPressed: () => cubit.restoreChat(barter.barterId),
              ),
            ),
          );
      },
      child: BarterChatTile(
        barter: barter,
        currentUserId: kFakeBarterCurrentUserId,
        onTap: () {
          // TODO(task-05b): navigate to barter room
          // context.push('/barter-room/${barter.barterId}');
        },
      )
          .animate()
          .fadeIn(duration: 250.ms)
          .slideX(begin: -0.04, end: 0, duration: 250.ms),
    );
  }
}

class _ChatsSkeletonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: 4,
        separatorBuilder: (ctx, idx) =>
            Divider(height: 1, indent: 76, color: colors.inputBorder),
        itemBuilder: (ctx, idx) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const CircleAvatar(radius: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 14, width: 120, color: colors.surface2),
                    const SizedBox(height: 6),
                    Container(
                        height: 11, width: 90, color: colors.surface2),
                    const SizedBox(height: 5),
                    Container(
                        height: 11, width: 200, color: colors.surface2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}