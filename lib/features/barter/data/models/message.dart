/// Lightweight message model used for fake-data simulation.
/// (Real implementation will use freezed + Firestore once repo layer is wired.)
class MessageModel {
  const MessageModel({
    required this.messageId,
    required this.senderId,
    required this.text,
    required this.createdAt,
    this.isRead = false,
  });

  final String messageId;
  final String senderId;
  final String text;
  final DateTime createdAt;
  final bool isRead;
}
