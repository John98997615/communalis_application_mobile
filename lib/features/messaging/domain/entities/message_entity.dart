class MessageEntity {
  final int id;
  final int? childId;
  final int? authorId;
  final String authorRole;
  final String message;
  final String? createdAt;

  const MessageEntity({
    required this.id,
    this.childId,
    this.authorId,
    required this.authorRole,
    required this.message,
    this.createdAt,
  });

  bool get isFromParent => authorRole.toUpperCase() == 'PARENT';

  bool get isFromAdmin => authorRole.toUpperCase() == 'ADMIN';
}