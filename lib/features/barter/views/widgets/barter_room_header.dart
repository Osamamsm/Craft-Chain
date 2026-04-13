import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/user_avatar.dart';
import 'package:craft_chain/features/barter/models/barter.dart';
import 'package:craft_chain/features/barter/viewmodels/barter_room_cubit/barter_room_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The AppBar-style header for the Barter Room screen.
///
/// Shows:
/// - Back button (hidden when [showBackButton] is false, e.g. on desktop)
/// - Two overlapping avatar widgets (48 px each, ~18 px horizontal overlap)
/// - The other user's name
/// - ⋮ overflow menu with "Mark as Completed"
class BarterRoomHeader extends StatelessWidget implements PreferredSizeWidget {
  const BarterRoomHeader({
    super.key,
    required this.barter,
    required this.currentUserId,
    this.showBackButton = true,
    this.onBack,
  });

  final BarterModel barter;
  final String currentUserId;
  final bool showBackButton;
  final VoidCallback? onBack;

  // Helpers ─────────────────────────────────────────────────────────────────

  bool get _iAmUser1 => barter.user1Id == currentUserId;

  String get _otherName =>
      _iAmUser1 ? barter.user2Name : barter.user1Name;
  String get _otherInitials =>
      _iAmUser1 ? barter.user2Initials : barter.user1Initials;
  int get _otherColorSeed =>
      _iAmUser1 ? barter.user2ColorSeed : barter.user1ColorSeed;

  String get _myInitials =>
      _iAmUser1 ? barter.user1Initials : barter.user2Initials;
  int get _myColorSeed =>
      _iAmUser1 ? barter.user1ColorSeed : barter.user2ColorSeed;

  String get _myTeaches =>
      _iAmUser1 ? barter.user1Teaches : barter.user2Teaches;
  String get _theyTeach =>
      _iAmUser1 ? barter.user2Teaches : barter.user1Teaches;

  Future<void> _showCompletedDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('barter.room_complete_title'.tr()),
        content: Text('barter.room_complete_body'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('barter.room_cancel'.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('barter.room_confirm'.tr()),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<BarterRoomCubit>().markAsCompleted();
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isCompleted = barter.status == BarterStatus.completed;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          bottom: BorderSide(color: colors.inputBorder, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Top row: back · avatars + name · menu ─────────────────────
            SizedBox(
              height: kToolbarHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back button
                  if (showBackButton)
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: colors.onSurface,
                      ),
                      onPressed: onBack ??
                          () => Navigator.of(context).maybePop(),
                    )
                  else
                    const SizedBox(width: 8),

                  // Overlapping avatars (other on top, me behind)
                  SizedBox(
                    width: 76,
                    height: 48,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // My avatar (behind)
                        Positioned(
                          left: 0,
                          top: 4,
                          child: UserAvatar(
                            initials: _myInitials,
                            radius: 20,
                            colorSeed: _myColorSeed,
                          ),
                        ),
                        // Other user's avatar (in front)
                        Positioned(
                          left: 18,
                          top: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colors.surface,
                                width: 2,
                              ),
                            ),
                            child: UserAvatar(
                              initials: _otherInitials,
                              radius: 20,
                              colorSeed: _otherColorSeed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Name
                  Expanded(
                    child: Text(
                      _otherName,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: colors.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Overflow menu
                  PopupMenuButton<_MenuAction>(
                    icon: Icon(Icons.more_vert_rounded, color: colors.onSurface),
                    onSelected: (action) {
                      if (action == _MenuAction.markComplete) {
                        _showCompletedDialog(context);
                      }
                    },
                    itemBuilder: (ctx) => [
                      PopupMenuItem(
                        value: _MenuAction.markComplete,
                        enabled: !isCompleted,
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 18,
                              color: isCompleted
                                  ? colors.secondaryText
                                  : colors.greenAccent,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              isCompleted
                                  ? 'barter.room_already_completed'.tr()
                                  : 'barter.room_mark_complete'.tr(),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isCompleted
                                    ? colors.secondaryText
                                    : colors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Exchange pill ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ExchangePill(
                mySkill: _myTeaches,
                theirSkill: _theyTeach,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _MenuAction { markComplete }

// ── Exchange Pill ─────────────────────────────────────────────────────────────

class _ExchangePill extends StatelessWidget {
  const _ExchangePill({
    required this.mySkill,
    required this.theirSkill,
  });

  final String mySkill;
  final String theirSkill;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: colors.infoBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.primary.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SkillLabel(
            label: 'barter.room_you'.tr(),
            skill: mySkill,
            color: colors.teachChipText,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '↔',
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.secondaryText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _SkillLabel(
            label: 'barter.room_them'.tr(),
            skill: theirSkill,
            color: colors.primary,
          ),
        ],
      ),
    );
  }
}

class _SkillLabel extends StatelessWidget {
  const _SkillLabel({
    required this.label,
    required this.skill,
    required this.color,
  });

  final String label;
  final String skill;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label ',
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.secondaryText,
              fontSize: 10,
            ),
          ),
          TextSpan(
            text: skill,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
