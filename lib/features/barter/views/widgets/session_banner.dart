import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays the scheduled session info when [scheduledAt] is set,
/// or a subtle empty-state hint when no session has been agreed yet.
class SessionBanner extends StatelessWidget {
  const SessionBanner({
    super.key,
    this.scheduledAt,
    this.platform,
  });

  /// Null means no session is scheduled yet.
  final DateTime? scheduledAt;

  /// e.g. 'Zoom', 'Google Meet'. Shown alongside the date.
  final String? platform;

  static final _dateFmt = DateFormat('EEE, MMM d · h:mm a');

  bool get _isSoon {
    if (scheduledAt == null) return false;
    final diff = scheduledAt!.difference(DateTime.now());
    return diff.isNegative == false && diff.inHours < 24;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (scheduledAt == null) {
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: colors.surface2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 15,
              color: colors.secondaryText,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'barter.room_no_session'.tr(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.secondaryText,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Session is scheduled.
    final platformLabel =
        (platform != null && platform!.isNotEmpty) ? platform! : 'Online';
    final dateLabel = _dateFmt.format(scheduledAt!);
    final soon = _isSoon;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.teachChipBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colors.teachChipText.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            '📅',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platformLabel,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.teachChipText,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dateLabel,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.teachChipText,
                  ),
                ),
              ],
            ),
          ),
          if (soon)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: colors.teachChipText,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'barter.room_soon'.tr(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.onPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
