import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/barter/models/barter.dart';
import 'package:craft_chain/features/barter/viewmodels/barter_request_cubit/barter_request_cubit.dart';
import 'package:craft_chain/features/barter/views/widgets/barter_chat_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DismissibleChatTile extends StatelessWidget {
  const DismissibleChatTile({
    super.key,
    required this.barter,
    this.isSelected = false,
    required this.onTap,
  });
  final BarterModel barter;
  final bool isSelected;
  final VoidCallback onTap;

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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: isSelected
            ? context.colors.primary.withValues(alpha: 0.07)
            : Colors.transparent,
        child:
            BarterChatTile(
                  barter: barter,
                  currentUserId: kFakeBarterCurrentUserId,
                  onTap: onTap,
                )
                .animate()
                .fadeIn(duration: 250.ms)
                .slideX(begin: -0.04, end: 0, duration: 250.ms),
      ),
    );
  }
}
