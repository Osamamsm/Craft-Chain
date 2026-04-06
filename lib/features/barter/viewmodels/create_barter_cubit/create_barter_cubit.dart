import 'package:craft_chain/features/barter/viewmodels/create_barter_cubit/create_barter_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateBarterCubit extends Cubit<CreateBarterState> {
  CreateBarterCubit() : super(CreateBarterState());

  // ── Bottom-sheet skill selection ─────────────────────────────────────────────

  void selectTeachSkill(String skill) {
    emit(state.copyWith(selectedTeachSkill: skill));
  }

  void selectLearnSkill(String skill) {
    emit(state.copyWith(selectedLearnSkill: skill));
  }

  void resetSheetSelection() {
    emit(state.copyWith(clearTeachSkill: true, clearLearnSkill: true));
  }

  // ── Send request ─────────────────────────────────────────────────────────────

  Future<bool> sendBarterRequest({
    required String targetUserId,
    required String targetUserName,
  }) async {
    if (!state.canSubmitRequest) return false;
    emit(state.copyWith(isSendingRequest: true));
    await Future<void>.delayed(const Duration(seconds: 1));

    //TODO : replace with the repo integration later
    emit(
      state.copyWith(
        isSendingRequest: false,
        requestSentSuccessfully: true,
        clearTeachSkill: true,
        clearLearnSkill: true,
      ),
    );
    return true;
  }
}
