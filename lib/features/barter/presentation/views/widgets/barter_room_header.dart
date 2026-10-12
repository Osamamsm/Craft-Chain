import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/user_avatar.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_chat_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';

/// The AppBar-style header for the Barter Room screen.
///
/// Shows:
/// - Back button (hidden when [showBackButton] is false, e.g. on desktop)
/// - The other user's avatar and name
/// - The skill exchange pill ("You <skill> ↔ Them <skill>")
class BarterRoomHeader extends StatelessWidget implements PreferredSizeWidget {
  const BarterRoomHeader({
    super.key,
    required this.info,
    this.showBackButton = true,
    this.onBack,
  });

  final BarterChatInfo info;
  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final other = info.otherUser;

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
            // ── Top row: back · avatar + name ─────────────────────────────
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
                      onPressed:
                          onBack ?? () => Navigator.of(context).maybePop(),
                    )
                  else
                    const SizedBox(width: 16),

                  // Other user's avatar
                  UserAvatar(
                    initials: other.initial,
                    radius: 20,
                    imageUrl: other.photoUrl,
                  ),

                  const SizedBox(width: 12),

                  // Name
                  Expanded(
                    child: Text(
                      other.fullName,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: colors.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(width: 16),
                ],
              ),
            ),

            // ── Exchange pill ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ExchangePill(
                mySkill: info.mySkill,
                theirSkill: info.theirSkill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Exchange Pill ─────────────────────────────────────────────────────────────

class _ExchangePill extends StatelessWidget {
  const _ExchangePill({required this.mySkill, required this.theirSkill});

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