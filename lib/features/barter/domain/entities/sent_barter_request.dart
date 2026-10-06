import 'package:craft_chain/features/barter/domain/entities/barter_status.dart';
import 'package:craft_chain/features/barter/domain/entities/barter_user.dart';
import 'package:equatable/equatable.dart';

class SentBarterRequest extends Equatable {
  const SentBarterRequest({
    required this.barterId,
    required this.status,
    required this.createdAt,
    required this.recipient,
    required this.youWillTeach,
    required this.youWillLearn,
  });

  final String barterId;
  final BarterStatus status;
  final DateTime createdAt;
  final BarterUser recipient;

  final String youWillTeach;

  final String youWillLearn;

  @override
  List<Object?> get props => [
    barterId,
    status,
    createdAt,
    recipient,
    youWillTeach,
    youWillLearn,
  ];


    SentBarterRequest copyWith({BarterStatus? status}) => SentBarterRequest(
        barterId: barterId,
        status: status ?? this.status,
        createdAt: createdAt,
        recipient: recipient,
        youWillTeach: youWillTeach,
        youWillLearn: youWillLearn,
      );
}
