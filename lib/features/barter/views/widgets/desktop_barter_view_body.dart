import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/barter/models/barter.dart';
import 'package:craft_chain/features/barter/viewmodels/barter_request_cubit/barter_request_cubit.dart';
import 'package:craft_chain/features/barter/viewmodels/barter_request_cubit/barter_request_state.dart';
import 'package:craft_chain/features/barter/views/barter_room_screen.dart';
import 'package:craft_chain/features/barter/views/widgets/chats_skeleton_list.dart';
import 'package:craft_chain/features/barter/views/widgets/dismissible_chat_tile.dart';
import 'package:craft_chain/features/barter/views/widgets/received_tab.dart';
import 'package:craft_chain/features/barter/views/widgets/sent_tab.dart';
import 'package:craft_chain/features/barter/views/widgets/tab_with_badge.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DesktopBarterViewBody extends StatefulWidget {
  const DesktopBarterViewBody({super.key});

  @override
  State<DesktopBarterViewBody> createState() => _DesktopBarterViewBodyState();
}

class _DesktopBarterViewBodyState extends State<DesktopBarterViewBody>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  /// The currently selected barter (shown in the right panel).
  BarterModel? _selectedBarter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTab(0));
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;
    _loadTab(_tabController.index);
  }

  void _loadTab(int index) {
    final cubit = context.read<BarterRequestCubit>();
    switch (index) {
      case 0:
        cubit.loadChats();
      case 1:
        cubit.loadReceived();
      case 2:
        cubit.loadSent();
    }
  }

  void _openRoom(BarterModel barter) {
    setState(() => _selectedBarter = barter);
  }

  void _closeRoom() {
    setState(() => _selectedBarter = null);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Row(
        children: [
          // ── Left panel: conversation list ──────────────────────────────
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              color: colors.surface,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'barter.my_barters'.tr(),
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<BarterRequestCubit, BarterRequestState>(
                    builder: (context, state) => TabBar(
                      controller: _tabController,
                      labelColor: colors.primary,
                      unselectedLabelColor: colors.secondaryText,
                      labelStyle: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: AppTextStyles.bodyMedium,
                      indicatorColor: colors.primary,
                      indicatorWeight: 2.5,
                      indicatorSize: TabBarIndicatorSize.label,
                      dividerColor: colors.inputBorder,
                      tabs: [
                        Tab(text: 'barter.tab_chats'.tr()),
                        Tab(
                          child: TabWithBadge(
                            label: 'barter.tab_received'.tr(),
                            count: state.received.length,
                            badgeColor: colors.error,
                          ),
                        ),
                        Tab(
                          child: TabWithBadge(
                            label: 'barter.tab_sent'.tr(),
                            count: state.sent.length,
                            badgeColor: colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Tab views — chats tab uses desktop-specific tile tap
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _DesktopChatsTab(
                          onTileTap: _openRoom,
                          selectedBarterId: _selectedBarter?.barterId,
                        ),
                        const ReceivedTab(),
                        const SentTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Vertical divider ─────────────────────────────────────────────
          VerticalDivider(width: 1, color: colors.inputBorder),

          // ── Right panel: barter room or empty hint ────────────────────────
          Expanded(
            child: _selectedBarter != null
                ? BarterRoomScreen(
                    key: ValueKey(_selectedBarter!.barterId),
                    barter: _selectedBarter!,
                    showBackButton: false,
                    onClose: _closeRoom,
                  )
                : const _DesktopEmptyPanel(),
          ),
        ],
      ),
    );
  }
}

// ── Desktop-specific chats list (highlights selected, calls onTileTap) ────────

class _DesktopChatsTab extends StatelessWidget {
  const _DesktopChatsTab({required this.onTileTap, this.selectedBarterId});

  final ValueChanged<BarterModel> onTileTap;
  final String? selectedBarterId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BarterRequestCubit, BarterRequestState>(
      buildWhen: (prev, curr) =>
          prev.chats != curr.chats ||
          prev.isLoadingChats != curr.isLoadingChats,
      builder: (context, state) {
        if (state.isLoadingChats) {
          return const ChatsSkeletonList();
        }
        if (state.chats.isEmpty) {
          return Center(
            child: Text(
              'barter.chats_empty_title'.tr(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colors.secondaryText,
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: state.chats.length,
          separatorBuilder: (ctx, idx) =>
              Divider(height: 1, indent: 76, color: context.colors.inputBorder),
          itemBuilder: (ctx, index) {
            final barter = state.chats[index];
            final isSelected = barter.barterId == selectedBarterId;
            return DismissibleChatTile(
              barter: barter,
              isSelected: isSelected,
              onTap: () => onTileTap(barter),
            );
          },
        );
      },
    );
  }
}

// ── Empty right panel ─────────────────────────────────────────────────────────

class _DesktopEmptyPanel extends StatelessWidget {
  const _DesktopEmptyPanel();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colors.surface2,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.swap_horiz_rounded,
              size: 36,
              color: colors.secondaryText,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'barter.select_chat'.tr(),
            style: AppTextStyles.titleMedium.copyWith(color: colors.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            'barter.select_chat_subtitle'.tr(),
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
