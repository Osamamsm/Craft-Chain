import 'package:craft_chain/features/barter/domain/entities/sent_barter_request.dart';
import 'package:craft_chain/features/barter/domain/repo/barters_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_sent_requests_state.dart';

class GetSentRequestsCubit extends Cubit<GetSentRequestsState> {
  final BartersRepo _bartersRepo;

  GetSentRequestsCubit(this._bartersRepo) : super(GetSentRequestsInitial());

  Future<void> getSentRequests() async {
    emit(GetSentRequestsLoading());
    final result = await _bartersRepo.getSentRequests();
    result.fold(
      (failure) => emit(GetSentRequestsFailure(message: failure.message)),
      (requests) => emit(GetSentRequestsSuccess(requests: requests)),
    );
  }
}
