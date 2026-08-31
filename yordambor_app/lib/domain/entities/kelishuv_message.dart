class KelishuvMessage {
  const KelishuvMessage({
    required this.id,
    required this.kelishuvId,
    required this.senderId,
    required this.content,
    required this.createdAt,
    this.senderName,
  });

  final String id;
  final String kelishuvId;
  final String senderId;
  final String content;
  final DateTime createdAt;
  final String? senderName;
}
