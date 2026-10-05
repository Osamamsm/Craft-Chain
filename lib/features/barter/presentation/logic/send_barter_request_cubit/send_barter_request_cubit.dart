import 'package:craft_chain/features/barter/domain/entities/barter_action_result.dart';
import 'package:craft_chain/features/barter/domain/repo/barters_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'send_barter_request_state.dart';

class SendBarterRequestCubit extends Cubit<SendBarterRequestState> {
  final BartersRepo _repo;
  SendBarterRequestCubit(this._repo) : super(SendBarterRequestInitial());

  Future<void> sendBarterRequest({
    required String recipientId,
    required int requesterSkillId,
    required int recipientSkillId,
  }) async {
    emit(SendBarterRequestLoading());
    final result = await _repo.sendBarterRequest(
      recipientId: recipientId,
      requesterSkillId: requesterSkillId,
      recipientSkillId: recipientSkillId,
    );
    result.fold(
      (failure) => emit(SendBarterRequestError(failure.message)),
      (result) {
        if (result.success) {
          emit(SendBarterRequestSuccess(result));
        } else {
          emit(SendBarterRequestError(result.message));
        }
      },
    );
  }
}
