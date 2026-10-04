import 'package:craft_chain/features/barter/domain/entities/barter_user.dart';
import 'package:equatable/equatable.dart';

class ReceivedBarterRequest extends Equatable {
  const ReceivedBarterRequest({
    required this.barterId,
    required this.createdAt,
    required this.requester,
    required this.willTeachYou,
    required this.wantsToLearn,
  });

  final String barterId;
  final DateTime createdAt;
  final BarterUser requester;

  final String willTeachYou;

  final String wantsToLearn;

  @override
  List<Object?> get props => [
    barterId,
    createdAt,
    requester,
    willTeachYou,
    wantsToLearn,
  ];
}
