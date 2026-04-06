import 'package:craft_chain/features/barter/models/barter.dart';
import 'package:craft_chain/features/barter/viewmodels/barter_request_cubit/barter_request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// ── Fake current-user ID (matches the profile feature constant) ──────────────
const kFakeBarterCurrentUserId = 'user_me';

// ── Fake data ────────────────────────────────────────────────────────────────

final _fakeChats = <BarterModel>[
  BarterModel(
    barterId: 'barter_001',
    user1Id: kFakeBarterCurrentUserId,
    user2Id: 'user_sara',
    user1Name: 'Me',
    user2Name: 'Sara Ahmed',
    user1Initials: 'M',
    user2Initials: 'SA',
    user1ColorSeed: 0,
    user2ColorSeed: 1,
    user1Teaches: 'Flutter',
    user2Teaches: 'Calligraphy',
    status: BarterStatus.active,
    lastMessageText: 'Sure, let\'s schedule for Saturday!',
    lastMessageTime: DateTime.now().subtract(const Duration(minutes: 2)),
    unreadCount: 3,
  ),
  BarterModel(
    barterId: 'barter_002',
    user1Id: 'user_nour',
    user2Id: kFakeBarterCurrentUserId,
    user1Name: 'Nour Hassan',
    user2Name: 'Me',
    user1Initials: 'NH',
    user2Initials: 'M',
    user1ColorSeed: 2,
    user2ColorSeed: 0,
    user1Teaches: 'Graphic Design',
    user2Teaches: 'Python',
    status: BarterStatus.active,
    lastMessageText: 'Can you send the Figma file?',
    lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
    unreadCount: 0,
  ),
  BarterModel(
    barterId: 'barter_003',
    user1Id: kFakeBarterCurrentUserId,
    user2Id: 'user_layla',
    user1Name: 'Me',
    user2Name: 'Layla Mostafa',
    user1Initials: 'M',
    user2Initials: 'LM',
    user1ColorSeed: 0,
    user2ColorSeed: 3,
    user1Teaches: 'Video Editing',
    user2Teaches: 'Arabic Grammar',
    status: BarterStatus.completed,
    lastMessageText: 'Great session! Thanks so much 🎉',
    lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
    unreadCount: 0,
  ),
  BarterModel(
    barterId: 'barter_004',
    user1Id: 'user_reem',
    user2Id: kFakeBarterCurrentUserId,
    user1Name: 'Reem Khalid',
    user2Name: 'Me',
    user1Initials: 'RK',
    user2Initials: 'M',
    user1ColorSeed: 1,
    user2ColorSeed: 0,
    user1Teaches: 'Public Speaking',
    user2Teaches: 'Excel & Data',
    status: BarterStatus.active,
    lastMessageText: 'Looking forward to our next session!',
    lastMessageTime: DateTime.now().subtract(const Duration(days: 3)),
    unreadCount: 1,
  ),
];

final _fakeReceived = <BarterModel>[
  BarterModel(
    barterId: 'barter_005',
    user1Id: 'user_omar',
    user2Id: kFakeBarterCurrentUserId,
    user1Name: 'Omar Ziad',
    user2Name: 'Me',
    user1Initials: 'OZ',
    user2Initials: 'M',
    user1ColorSeed: 2,
    user2ColorSeed: 0,
    user1Teaches: 'Photography',
    user2Teaches: 'Flutter',
    status: BarterStatus.pending,
  ),
  BarterModel(
    barterId: 'barter_006',
    user1Id: 'user_dina',
    user2Id: kFakeBarterCurrentUserId,
    user1Name: 'Dina Farouk',
    user2Name: 'Me',
    user1Initials: 'DF',
    user2Initials: 'M',
    user1ColorSeed: 3,
    user2ColorSeed: 0,
    user1Teaches: 'UI/UX Design',
    user2Teaches: 'Python',
    status: BarterStatus.pending,
  ),
];

final _fakeSent = <BarterModel>[
  BarterModel(
    barterId: 'barter_007',
    user1Id: kFakeBarterCurrentUserId,
    user2Id: 'user_ali',
    user1Name: 'Me',
    user2Name: 'Ali Hassan',
    user1Initials: 'M',
    user2Initials: 'AH',
    user1ColorSeed: 0,
    user2ColorSeed: 1,
    user1Teaches: 'Flutter',
    user2Teaches: 'Branding',
    status: BarterStatus.pending,
  ),
];

// ── Cubit ─────────────────────────────────────────────────────────────────────

@injectable
class BarterRequestCubit extends Cubit<BarterRequestState> {
  BarterRequestCubit() : super(const BarterRequestState());

  // ── Load methods ────────────────────────────────────────────────────────────

  Future<void> loadChats() async {
    emit(state.copyWith(isLoadingChats: true, clearError: true));
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final chats = _fakeChats
        .where((b) => !b.hiddenBy.contains(kFakeBarterCurrentUserId))
        .toList()
      ..sort((a, b) {
        final ta = a.lastMessageTime ?? DateTime(2000);
        final tb = b.lastMessageTime ?? DateTime(2000);
        return tb.compareTo(ta);
      });
    emit(state.copyWith(chats: chats, isLoadingChats: false));
  }

  Future<void> loadReceived() async {
    emit(state.copyWith(isLoadingReceived: true, clearError: true));
    await Future<void>.delayed(const Duration(milliseconds: 700));
    emit(state.copyWith(
      received: List.of(_fakeReceived),
      isLoadingReceived: false,
    ));
  }

  Future<void> loadSent() async {
    emit(state.copyWith(isLoadingSent: true, clearError: true));
    await Future<void>.delayed(const Duration(milliseconds: 700));
    emit(state.copyWith(sent: List.of(_fakeSent), isLoadingSent: false));
  }

  // ── Chat actions ─────────────────────────────────────────────────────────────

  /// Soft-deletes a chat by adding the current user to its [hiddenBy] list.
  void hideChat(String barterId) {
    // Update the fake in-memory store so it stays hidden across reloads.
    final idx = _fakeChats.indexWhere((b) => b.barterId == barterId);
    if (idx != -1) {
      final updated = _fakeChats[idx]
          .copyWith(hiddenBy: [..._fakeChats[idx].hiddenBy, kFakeBarterCurrentUserId]);
      _fakeChats[idx] = updated;
    }
    final updatedChats = state.chats
        .where((b) => b.barterId != barterId)
        .toList();
    emit(state.copyWith(chats: updatedChats));
  }

  /// Restores a soft-deleted chat (Undo action).
  void restoreChat(String barterId) {
    final idx = _fakeChats.indexWhere((b) => b.barterId == barterId);
    if (idx != -1) {
      final updated = _fakeChats[idx].copyWith(
        hiddenBy: _fakeChats[idx].hiddenBy
            .where((id) => id != kFakeBarterCurrentUserId)
            .toList(),
      );
      _fakeChats[idx] = updated;
    }
    // Re-load to reflect the restored item.
    loadChats();
  }

  // ── Received-tab actions ────────────────────────────────────────────────────

  Future<void> acceptRequest(String barterId) async {
    final updatedReceived =
        state.received.where((b) => b.barterId != barterId).toList();
    emit(state.copyWith(received: updatedReceived));
    await Future<void>.delayed(const Duration(milliseconds: 600));
    // Simulate moving to the chats list.
    final accepted = _fakeReceived.firstWhere((b) => b.barterId == barterId);
    final asActive = accepted.copyWith(status: BarterStatus.active);
    _fakeChats.insert(0, asActive);
    _fakeReceived.removeWhere((b) => b.barterId == barterId);
    loadChats();
  }

  Future<void> declineRequest(String barterId) async {
    final updatedReceived =
        state.received.where((b) => b.barterId != barterId).toList();
    emit(state.copyWith(received: updatedReceived));
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _fakeReceived.removeWhere((b) => b.barterId == barterId);
  }

}
