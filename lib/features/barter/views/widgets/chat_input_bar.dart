import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Fixed bottom input bar with a rounded text field and a send button.
///
/// The send button is disabled when the text field is empty.
/// [onSend] is called with the trimmed message text when send is pressed.
class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    required this.onSend,
    this.isSending = false,
    this.disabled = false,
  });

  /// Called with the trimmed message text when the user taps send.
  final ValueChanged<String> onSend;

  /// True while a send operation is in progress (shows a spinner).
  final bool isSending;

  /// Disables the entire input (e.g. when barter is completed).
  final bool disabled;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isSending || widget.disabled) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(color: colors.inputBorder, width: 1),
        ),
      ),
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 10,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 10,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // ── Text field ────────────────────────────────────────────────
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 44, maxHeight: 120),
                decoration: BoxDecoration(
                  color: colors.surface2,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: colors.inputBorder),
                ),
                child: TextField(
                  controller: _controller,
                  enabled: !widget.disabled && !widget.isSending,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.disabled
                        ? 'barter.room_input_disabled'.tr()
                        : 'barter.room_input_hint'.tr(),
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: colors.secondaryText,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // ── Send button ───────────────────────────────────────────────
            AnimatedScale(
              scale: _hasText ? 1.0 : 0.85,
              duration: const Duration(milliseconds: 150),
              child: Material(
                color: _hasText && !widget.disabled
                    ? colors.primary
                    : colors.inputBorder,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _hasText && !widget.disabled && !widget.isSending
                      ? _handleSend
                      : null,
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Center(
                      child: widget.isSending
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.onPrimary,
                              ),
                            )
                          : Icon(
                              Icons.send_rounded,
                              size: 20,
                              color: _hasText && !widget.disabled
                                  ? colors.onPrimary
                                  : colors.secondaryText,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
