import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/user_avatar.dart';
import 'package:craft_chain/features/barter/models/barter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A single row in the Chats tab list.
///
/// Displays the other user's avatar, name, skill exchange summary, last
/// message preview, relative timestamp, status badge, and unread count.
class BarterChatTile extends StatelessWidget {
  const BarterChatTile({
    super.key,
    required this.barter,
    required this.currentUserId,
    required this.onTap,
  });

  final BarterModel barter;
  final String currentUserId;
  final VoidCallback onTap;

  // Returns the *other* user's display data relative to [currentUserId].
  _OtherUser _otherUser() {
    final iAmUser1 = barter.user1Id == currentUserId;
    return _OtherUser(
      name: iAmUser1 ? barter.user2Name : barter.user1Name,
      initials: iAmUser1 ? barter.user2Initials : barter.user1Initials,
      colorSeed: iAmUser1 ? barter.user2ColorSeed : barter.user1ColorSeed,
    );
  }

  String _exchangeSummary() =>
      '${barter.user1Teaches} ↔ ${barter.user2Teaches}';

  String _relativeTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays == 1) return 'Yesterday';
    return DateFormat('MMM d').format(time);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final other = _otherUser();
    final isCompleted = barter.status == BarterStatus.completed;
    final hasUnread = barter.unreadCount > 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // ── Avatar + status dot ──────────────────────────────────────────
            Stack(
              clipBehavior: Clip.none,
              children: [
                UserAvatar(
                  initials: other.initials,
                  radius: 24,
                  colorSeed: other.colorSeed,
                ),
                Positioned(
                  bottom: 0,
                  right: -1,
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? colors.secondaryText
                          : colors.greenAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.surface, width: 2),
                    ),
                    child: isCompleted
                        ? Icon(Icons.check,
                            size: 7, color: colors.onPrimary)
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),

            // ── Name + exchange + last message ───────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          other.name,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: colors.onSurface,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Timestamp
                      if (barter.lastMessageTime != null)
                        Text(
                          _relativeTime(barter.lastMessageTime!),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: hasUnread
                                ? colors.primary
                                : colors.secondaryText,
                            fontWeight: hasUnread
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Skill exchange summary
                  Text(
                    _exchangeSummary(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  // Last message + unread badge row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          barter.lastMessageText ?? '',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: hasUnread
                                ? colors.onSurface
                                : colors.secondaryText,
                            fontWeight: hasUnread
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Unread badge
                      if (hasUnread)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colors.error,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            barter.unreadCount > 99
                                ? '99+'
                                : '${barter.unreadCount}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OtherUser {
  const _OtherUser({
    required this.name,
    required this.initials,
    required this.colorSeed,
  });
  final String name;
  final String initials;
  final int colorSeed;
}
