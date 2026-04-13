import 'package:craft_chain/core/constants/constants.dart';
import 'package:craft_chain/core/di/injection.dart';
import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/barter/models/barter.dart';
import 'package:craft_chain/features/barter/viewmodels/barter_room_cubit/barter_room_cubit.dart';
import 'package:craft_chain/features/barter/viewmodels/barter_room_cubit/barter_room_state.dart';
import 'package:craft_chain/features/barter/views/widgets/barter_room_header.dart';
import 'package:craft_chain/features/barter/views/widgets/chat_input_bar.dart';
import 'package:craft_chain/features/barter/views/widgets/message_bubble.dart';
import 'package:craft_chain/features/barter/views/widgets/session_banner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The dedicated chat screen for an active barter.
///
/// Can be used in two ways:
/// - **Full-screen / mobile**: pushed via `context.push('/barter-room/...')`.
///   [showBackButton] defaults to true.
/// - **Embedded panel / desktop**: placed inside the right panel of
///   [DesktopBarterViewBody]. Pass [showBackButton] = false and provide
///   [onClose] to dismiss the panel.
class BarterRoomScreen extends StatelessWidget {
  const BarterRoomScreen({
    super.key,
    required this.barter,
    this.showBackButton = true,
    this.onClose,
  });

  static const routePath = '/barter-room/:barterId';
  static const routeName = 'barter-room';

  final BarterModel barter;
  final bool showBackButton;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BarterRoomCubit>(
      create: (_) => getIt<BarterRoomCubit>()..loadRoom(barter),
      child: _BarterRoomView(
        showBackButton: showBackButton,
        onClose: onClose,
      ),
    );
  }
}

// ── Internal view (consumes cubit) ────────────────────────────────────────────

class _BarterRoomView extends StatefulWidget {
  const _BarterRoomView({
    required this.showBackButton,
    this.onClose,
  });

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
    return BlocConsumer<BarterRoomCubit, BarterRoomState>(
      listenWhen: (prev, curr) => prev.messages.length != curr.messages.length,
      listener: (context, state) => _scrollToBottom(),
      builder: (context, state) {
        if (state.isLoading || state.barter == null) {
          return _LoadingView(showBackButton: widget.showBackButton);
        }

        final barter = state.barter!;
        final isCompleted = state.isCompleted;

        return Scaffold(
          backgroundColor: context.colors.background,
          appBar: BarterRoomHeader(
            barter: barter,
            currentUserId: Constants.kFakeCurrentUserId,
            showBackButton: widget.showBackButton,
            onBack: widget.onClose,
          ),
          body: Column(
            children: [
              // ── Session banner ─────────────────────────────────────────
              SessionBanner(
                scheduledAt: null, // TODO: wire from barter when Firestore ready
                platform: null,
              ),

              // ── Completed banner ───────────────────────────────────────
              if (isCompleted) _CompletedBanner(),

              // ── Chat messages ──────────────────────────────────────────
              Expanded(
                child: state.messages.isEmpty
                    ? _EmptyChatHint()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        itemCount: state.messages.length,
                        itemBuilder: (ctx, index) {
                          final msg = state.messages[index];
                          final isSent =
                              msg.senderId == Constants.kFakeCurrentUserId;
                          final showDateSeparator = _shouldShowDate(
                            state.messages,
                            index,
                          );

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (showDateSeparator)
                                _DateSeparator(date: msg.createdAt),
                              MessageBubble(
                                message: msg,
                                isSent: isSent,
                              ),
                            ],
                          );
                        },
                      ),
              ),

              // ── Input bar ──────────────────────────────────────────────
              ChatInputBar(
                isSending: state.isSending,
                disabled: isCompleted,
                onSend: (text) =>
                    context.read<BarterRoomCubit>().sendMessage(text),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _shouldShowDate(List messages, int index) {
    if (index == 0) return true;
    final curr = messages[index].createdAt as DateTime;
    final prev = messages[index - 1].createdAt as DateTime;
    return !DateUtils.isSameDay(curr, prev);
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
      body: Center(
        child: CircularProgressIndicator(color: colors.primary),
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
            style: AppTextStyles.titleMedium.copyWith(
              color: colors.onSurface,
            ),
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
        border: Border.all(
          color: colors.greenAccent.withValues(alpha: 0.4),
        ),
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
    if (DateUtils.isSameDay(
        date, now.subtract(const Duration(days: 1)))) {
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
