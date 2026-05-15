class ConversationEntity {
  final int id;
  final String title;
  final String? lastMessage;
  final String? lastMessageAt;

  const ConversationEntity({
    required this.id,
    required this.title,
    this.lastMessage,
    this.lastMessageAt,
  });
}