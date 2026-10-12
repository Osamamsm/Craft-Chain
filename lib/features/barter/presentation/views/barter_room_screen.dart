import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_message.dart';
import 'package:craft_chain/features/barter/presentation/logic/barter_room_cubit/barter_room_cubit.dart';
import 'package:craft_chain/features/barter/presentation/logic/barter_room_cubit/barter_room_state.dart';
import 'package:craft_chain/features/barter/presentation/views/widgets/barter_room_header.dart';
import 'package:craft_chain/features/barter/presentation/views/widgets/chat_input_bar.dart';
import 'package:craft_chain/features/barter/presentation/views/widgets/message_bubble.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BarterRoomScreen extends StatelessWidget {
  const BarterRoomScreen({
    super.key,
    required this.barterId,
    this.showBackButton = true,
    this.onClose,
  });

  static const routePath = '/barter-room/:barterId';
  static const routeName = 'barter-room';

  final String barterId;
  final bool showBackButton;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return _BarterRoomView(
      barterId: barterId,
      showBackButton: showBackButton,
      onClose: onClose,
    );
  }
}

// ── Internal view (consumes cubit) ────────────────────────────────────────────

class _BarterRoomView extends StatefulWidget {
  const _BarterRoomView({
    required this.barterId,
    required this.showBackButton,
    this.onClose,
  });

  final String barterId;
  final bool showBackButton;
  final VoidCallback? onClose;

  @override
  State<_BarterRoomView> createState() => _BarterRoomViewState();
}

class _BarterRoomViewState extends State<_BarterRoomView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animate = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final maxExtent = _scrollController.position.maxScrollExtent;
      if (animate) {
        _scrollController.animateTo(
          maxExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(maxExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Snackbar when sending a message fails
    return BlocListener<BarterRoomCubit, BarterRoomState>(
      listenWhen: (_, curr) => curr is BarterRoomLoaded && curr.feedback != null,
      listener: (context, state) {
        final feedback = (state as BarterRoomLoaded).feedback!;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: feedback.isError ? colors.error : null,
              content: Text(feedback.message),
            ),
          );
      },
      child: BlocConsumer<BarterRoomCubit, BarterRoomState>(
        // scroll down when the number of messages changes (incl. first load)
        listenWhen: (prev, curr) {
          if (curr is! BarterRoomLoaded) return false;
          final prevCount =
              prev is BarterRoomLoaded ? prev.chat.messages.length : -1;
          return prevCount != curr.chat.messages.length;
        },
        listener: (context, state) => _scrollToBottom(),
        builder: (context, state) {
          if (state is BarterRoomError) {
            return _ErrorView(
              message: state.error,
              showBackButton: widget.showBackButton,
              onRetry: () => context
                  .read<BarterRoomCubit>()
                  .getBarterChat(barterId: widget.barterId),
            );
          }
          if (state is! BarterRoomLoaded) {
            return _LoadingView(showBackButton: widget.showBackButton);
          }

          final info = state.chat.info;
          final messages = state.chat.messages;

          return Scaffold(
            backgroundColor: colors.background,
            // BarterRoomHeader takes the BarterChatInfo entity
            // (otherUser, mySkill, theirSkill).
            appBar: BarterRoomHeader(
              info: info,
              showBackButton: widget.showBackButton,
              onBack: widget.onClose,
            ),
            body: Column(
              children: [
                // ── Completed banner ───────────────────────────────────────
                if (info.isCompleted) _CompletedBanner(),

                // ── Chat messages ──────────────────────────────────────────
                Expanded(
                  child: messages.isEmpty
                      ? _EmptyChatHint()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          itemCount: messages.length,
                          itemBuilder: (ctx, index) {
                            final msg = messages[index];
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_shouldShowDate(messages, index))
                                  _DateSeparator(date: msg.createdAt),
                                // isMine is computed by the server
                                MessageBubble(
                                  message: msg,
                                  isSent: msg.isMine,
                                ),
                              ],
                            );
                          },
                        ),
                ),

                // ── Input bar ──────────────────────────────────────────────
                // Sending is optimistic, so there is no "sending" state.
                ChatInputBar(
                  isSending: false,
                  disabled: info.isCompleted,
                  onSend: (text) =>
                      context.read<BarterRoomCubit>().sendMessage(text),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _shouldShowDate(List<BarterMessage> messages, int index) {
    if (index == 0) return true;
    return !DateUtils.isSameDay(
      messages[index].createdAt,
      messages[index - 1].createdAt,
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView({required this.showBackButton});
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        automaticallyImplyLeading: showBackButton,
        elevation: 0,
      ),
      body: Center(child: CircularProgressIndicator(color: colors.primary)),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.showBackButton,
    required this.onRetry,
  });

  final String message;
  final bool showBackButton;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        automaticallyImplyLeading: showBackButton,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.secondaryText,
                ),
              ),
              const SizedBox(height: 12),
              IconButton(
                onPressed: onRetry,
                icon: Icon(Icons.refresh_rounded, color: colors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyChatHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 48,
            color: colors.secondaryText,
          ),
          const SizedBox(height: 12),
          Text(
            'barter.room_empty_title'.tr(),
            style: AppTextStyles.titleMedium.copyWith(color: colors.onSurface),
          ),
          const SizedBox(height: 6),
          Text(
            'barter.room_empty_subtitle'.tr(),
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }
}

class _CompletedBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.greenAccent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.greenAccent.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: colors.greenAccent, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'barter.room_completed_banner'.tr(),
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 350.ms)
        .slideY(begin: -0.2, end: 0, duration: 350.ms);
  }
}

class _DateSeparator extends StatelessWidget {
  const _DateSeparator({required this.date});
  final DateTime date;

  String _label() {
    final now = DateTime.now();
    if (DateUtils.isSameDay(date, now)) return 'Today';
    if (DateUtils.isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    }
    return DateFormat('MMMM d').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Divider(color: colors.inputBorder)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              _label(),
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.secondaryText,
                fontSize: 11,
              ),
            ),
          ),
          Expanded(child: Divider(color: colors.inputBorder)),
        ],
      ),
    );
  }
}