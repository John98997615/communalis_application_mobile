import '../../domain/entities/conversation_entity.dart';

class ConversationModel {
  final int id;
  final String title;
  final String? lastMessage;
  final String? lastMessageAt;

  const ConversationModel({
    required this.id,
    required this.title,
    this.lastMessage,
    this.lastMessageAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: int.tryParse((json['id'] ?? 0).toString()) ?? 0,
      title: (json['title'] ?? json['nom'] ?? 'Conversation').toString(),
      lastMessage: json['lastMessage']?.toString(),
      lastMessageAt: json['lastMessageAt']?.toString(),
    );
  }

  ConversationEntity toEntity() {
    return ConversationEntity(
      id: id,
      title: title,
      lastMessage: lastMessage,
      lastMessageAt: lastMessageAt,
    );
  }
}