import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/empty_state.dart';
import 'package:craft_chain/features/barter/viewmodels/barter_request_cubit/barter_request_cubit.dart';
import 'package:craft_chain/features/barter/viewmodels/barter_request_cubit/barter_request_state.dart';
import 'package:craft_chain/features/barter/views/widgets/chats_skeleton_list.dart';
import 'package:craft_chain/features/barter/views/widgets/dismissible_chat_tile.dart';
import 'package:craft_chain/features/barter/views/widgets/received_tab.dart';
import 'package:craft_chain/features/barter/views/widgets/sent_tab.dart';
import 'package:craft_chain/features/barter/views/widgets/tab_with_badge.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MobileBarterViewBody extends StatefulWidget {
  const MobileBarterViewBody({super.key});

  @override
  State<MobileBarterViewBody> createState() => _MobileBarterViewBodyState();
}

class _MobileBarterViewBodyState extends State<MobileBarterViewBody>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    // Load initial data.
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
      body: SafeArea(
        child: Column(
          children: [
            _MobileHeader(tabController: _tabController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const _MobileChatsTab(),
                  const ReceivedTab(),
                  const SentTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Mobile header + tab bar ───────────────────────────────────────────────────

class _MobileHeader extends StatelessWidget {
  const _MobileHeader({required this.tabController});
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      color: colors.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'barter.my_barters'.tr(),
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<BarterRequestCubit, BarterRequestState>(
            builder: (context, state) {
              return TabBar(
                controller: tabController,
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
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MobileChatsTab extends StatelessWidget {
  const _MobileChatsTab();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BarterRequestCubit, BarterRequestState>(
      buildWhen: (prev, curr) =>
          prev.chats != curr.chats ||
          prev.isLoadingChats != curr.isLoadingChats,
      builder: (context, state) {
        if (state.isLoadingChats) {
          return ChatsSkeletonList();
        }
        if (state.chats.isEmpty) {
          return EmptyState(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'barter.chats_empty_title'.tr(),
            subtitle: 'barter.chats_empty_subtitle'.tr(),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: state.chats.length,
          separatorBuilder: (ctx, idx) =>
              Divider(height: 1, indent: 76, color: context.colors.inputBorder),
          itemBuilder: (context, index) {
            final barter = state.chats[index];
            return DismissibleChatTile(
              barter: barter,
              onTap: () => context.push(
                '/barter-room/${barter.barterId}',
                extra: barter,
              ),
            );
          },
        );
      },
    );
  }
}
