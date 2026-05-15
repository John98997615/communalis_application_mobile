import '../../domain/entities/message_entity.dart';

class MessageModel {
  final int id;
  final int? childId;
  final int? authorId;
  final String authorRole;
  final String message;
  final String? createdAt;

  const MessageModel({
    required this.id,
    this.childId,
    this.authorId,
    required this.authorRole,
    required this.message,
    this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: int.tryParse(
            (json['id'] ?? json['id_commentaire'] ?? 0).toString(),
          ) ??
          0,
      childId: int.tryParse(
        (json['enfant_id'] ?? json['childId'] ?? '').toString(),
      ),
      authorId: int.tryParse(
        (json['auteur_id'] ?? json['authorId'] ?? '').toString(),
      ),
      authorRole: (json['auteur_role'] ??
              json['authorRole'] ??
              json['role'] ??
              'PARENT')
          .toString(),
      message: (json['message'] ?? json['contenu'] ?? '').toString(),
      createdAt: json['envoye_le']?.toString() ??
          json['createdAt']?.toString() ??
          json['date']?.toString(),
    );
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      childId: childId,
      authorId: authorId,
      authorRole: authorRole,
      message: message,
      createdAt: createdAt,
    );
  }
}