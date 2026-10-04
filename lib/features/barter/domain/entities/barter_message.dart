import 'package:equatable/equatable.dart';

class BarterMessage extends Equatable {
  const BarterMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.isRead,
    required this.createdAt,
    required this.isMine,
  });

  final String id;
  final String senderId;
  final String text;
  final bool isRead;
  final DateTime createdAt;

  final bool isMine;

  @override
  List<Object?> get props => [id, senderId, text, isRead, createdAt, isMine];
}
