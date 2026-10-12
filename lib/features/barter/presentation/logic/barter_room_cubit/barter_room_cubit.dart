import 'package:craft_chain/features/barter/domain/entities/barter_chat.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_message.dart';
import 'package:craft_chain/features/barter/domain/repo/barters_repo.dart';
import 'package:craft_chain/features/barter/presentation/logic/barter_room_cubit/barter_room_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BarterRoomCubit extends Cubit<BarterRoomState> {
  final BartersRepo _bartersRepo;
  BarterRoomCubit(this._bartersRepo) : super(BarterRoomInitial());

  Future<void> getBarterChat({required String barterId}) async {
    emit(BarterRoomLoading());
    final response = await _bartersRepo.getBarterChat(barterId: barterId);
    if (isClosed) return;
    response.fold(
      (failure) => emit(BarterRoomError(error: failure.message)),
      (chat) => emit(BarterRoomLoaded(chat: chat)),
    );
  }

  Future<void> sendMessage(String text) async {
    final current = state;
    if (current is! BarterRoomLoaded) return;

    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final now = DateTime.now();
    final temp = BarterMessage(
      id: 'pending-${now.microsecondsSinceEpoch}',
      senderId: '', // not needed for display: the bubble uses isMine
      text: trimmed,
      isRead: false,
      createdAt: now,
      isMine: true,
    );

    emit(
      BarterRoomLoaded(
        chat: BarterChat(
          info: current.chat.info,
          messages: [...current.chat.messages, temp],
        ),
      ),
    );

    final result = await _bartersRepo.sendMessage(
      barterId: current.chat.info.barterId,
      text: trimmed,
    );
    if (isClosed) return;

    final errorMessage = result.fold<String?>(
      (failure) => failure.message,
      (actionResult) => actionResult.success ? null : actionResult.message,
    );
    if (errorMessage == null) return; // keep the optimistic message

    final latest = state;
    if (latest is! BarterRoomLoaded) return;
    emit(
      BarterRoomLoaded(
        chat: BarterChat(
          info: latest.chat.info,
          messages: [
            for (final m in latest.chat.messages)
              if (m.id != temp.id) m,
          ],
        ),
        feedback: BarterChatFeedback(message: errorMessage, isError: true),
      ),
    );
  }
}
