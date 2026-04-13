import 'package:craft_chain/core/constants/constants.dart';
import 'package:craft_chain/features/barter/models/barter.dart';
import 'package:craft_chain/features/barter/models/message.dart';
import 'package:craft_chain/features/barter/viewmodels/barter_room_cubit/barter_room_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

final _now = DateTime.now();

final _fakeMessages = <String, List<MessageModel>>{
  'barter_001': [
    MessageModel(
      messageId: 'm1',
      senderId: 'user_sara',
      text: 'Hey! Excited to start our skill exchange 🎉',
      createdAt: _now.subtract(const Duration(hours: 2, minutes: 30)),
    ),
    MessageModel(
      messageId: 'm2',
      senderId: Constants.kFakeCurrentUserId,
      text: 'Me too! When would be a good time for first session?',
      createdAt: _now.subtract(const Duration(hours: 2, minutes: 10)),
    ),
    MessageModel(
      messageId: 'm3',
      senderId: 'user_sara',
      text: 'How about Thursday at 8 PM on Zoom?',
      createdAt: _now.subtract(const Duration(hours: 1, minutes: 45)),
    ),
    MessageModel(
      messageId: 'm4',
      senderId: Constants.kFakeCurrentUserId,
      text: 'Thursday works perfectly for me 👍',
      createdAt: _now.subtract(const Duration(hours: 1, minutes: 30)),
    ),
    MessageModel(
      messageId: 'm5',
      senderId: 'user_sara',
      text: 'Great! I\'ll send the Zoom link before the session.',
      createdAt: _now.subtract(const Duration(minutes: 30)),
    ),
    MessageModel(
      messageId: 'm6',
      senderId: Constants.kFakeCurrentUserId,
      text: 'Sure, let\'s schedule for Saturday!',
      createdAt: _now.subtract(const Duration(minutes: 2)),
    ),
  ],
  'barter_002': [
    MessageModel(
      messageId: 'm1',
      senderId: 'user_nour',
      text: 'Hi! Ready to start our design sessions?',
      createdAt: _now.subtract(const Duration(hours: 3)),
    ),
    MessageModel(
      messageId: 'm2',
      senderId: Constants.kFakeCurrentUserId,
      text: 'Absolutely! I\'ll start with the Python basics.',
      createdAt: _now.subtract(const Duration(hours: 2, minutes: 45)),
    ),
    MessageModel(
      messageId: 'm3',
      senderId: 'user_nour',
      text: 'Can you send the Figma file?',
      createdAt: _now.subtract(const Duration(hours: 1)),
    ),
  ],
  'barter_003': [
    MessageModel(
      messageId: 'm1',
      senderId: Constants.kFakeCurrentUserId,
      text: 'That was an amazing session! Learned so much.',
      createdAt: _now.subtract(const Duration(days: 2)),
    ),
    MessageModel(
      messageId: 'm2',
      senderId: 'user_layla',
      text: 'Same here! Your video editing tips were gold ✨',
      createdAt: _now.subtract(const Duration(days: 1, hours: 23)),
    ),
    MessageModel(
      messageId: 'm3',
      senderId: Constants.kFakeCurrentUserId,
      text: 'Great session! Thanks so much 🎉',
      createdAt: _now.subtract(const Duration(days: 1)),
    ),
  ],
  'barter_004': [
    MessageModel(
      messageId: 'm1',
      senderId: 'user_reem',
      text: 'Hi! Excited about our skill exchange.',
      createdAt: _now.subtract(const Duration(days: 4)),
    ),
    MessageModel(
      messageId: 'm2',
      senderId: Constants.kFakeCurrentUserId,
      text: 'Me too! When should we have our first session?',
      createdAt: _now.subtract(const Duration(days: 3, hours: 22)),
    ),
    MessageModel(
      messageId: 'm3',
      senderId: 'user_reem',
      text: 'Looking forward to our next session!',
      createdAt: _now.subtract(const Duration(days: 3)),
    ),
  ],
};

@injectable
class BarterRoomCubit extends Cubit<BarterRoomState> {
  BarterRoomCubit() : super(const BarterRoomState());

  Future<void> loadRoom(BarterModel barter) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final messages = List<MessageModel>.from(
      _fakeMessages[barter.barterId] ?? [],
    );
    emit(
      state.copyWith(
        barter: barter,
        messages: messages,
        isLoading: false,
        isCompleted: barter.status == BarterStatus.completed,
      ),
    );
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    emit(state.copyWith(isSending: true));

    // Optimistic insert.
    final newMessage = MessageModel(
      messageId: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: Constants.kFakeCurrentUserId,
      text: trimmed,

      createdAt: DateTime.now(),
    );

    final updated = [...state.messages, newMessage];

    if (state.barter != null) {
      _fakeMessages.putIfAbsent(state.barter!.barterId, () => []);
      _fakeMessages[state.barter!.barterId]!.add(newMessage);
    }

    await Future<void>.delayed(const Duration(milliseconds: 300));
    emit(state.copyWith(messages: updated, isSending: false));
  }

  Future<void> markAsCompleted() async {
    if (state.barter == null) return;
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final updated = state.barter!.copyWith(status: BarterStatus.completed);
    emit(state.copyWith(barter: updated, isCompleted: true));
  }
}
