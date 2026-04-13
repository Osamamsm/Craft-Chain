import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/barter/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

/// A single chat message bubble.
///
/// Sent messages (isSent == true) are aligned to the right with the primary
/// colour background. Received messages are aligned to the left with the
/// surface background. Each bubble shows a small timestamp below the text.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isSent,
  });

  final MessageModel message;
  final bool isSent;

  static final _timeFmt = DateFormat('h:mm a');

  String get _timeLabel => _timeFmt.format(message.createdAt);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final bubbleColor = isSent ? colors.primary : colors.surface;
    final textColor = isSent ? colors.onPrimary : colors.onSurface;
    final timeColor = isSent
        ? colors.onPrimary.withValues(alpha: 0.65)
        : colors.secondaryText;

    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.72,
        ),
        child: Container(
          margin: EdgeInsets.only(
            top: 2,
            bottom: 2,
            left: isSent ? 48 : 0,
            right: isSent ? 0 : 48,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(isSent ? 18 : 4),
              bottomRight: Radius.circular(isSent ? 4 : 18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.text,
                style: AppTextStyles.bodyMedium.copyWith(color: textColor),
              ),
              const SizedBox(height: 4),
              Text(
                _timeLabel,
                style: AppTextStyles.bodySmall.copyWith(
                  color: timeColor,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 200.ms)
        .slideY(
          begin: isSent ? 0.06 : -0.06,
          end: 0,
          duration: 200.ms,
          curve: Curves.easeOut,
        );
  }
}
