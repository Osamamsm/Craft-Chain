import 'package:craft_chain/features/barter/domain/entities/barter_chat_preview.dart';
import 'package:craft_chain/features/barter/domain/repo/barters_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'active_barters_state.dart';

class ActiveBartersCubit extends Cubit<ActiveBartersState> {
  final BartersRepo _bartersRepo;
  ActiveBartersCubit(this._bartersRepo) : super(ActiveBartersInitial());

  Future<void> getActiveBarters() async {
    emit(ActiveBartersLoading());
    final result = await _bartersRepo.getActiveBarters();
    result.fold(
      (failure) => emit(ActiveBartersFailure(failure.message)),
      (chats) => emit(ActiveBartersSuccess(chats)),
    );
  }
}
