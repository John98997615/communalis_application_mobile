class NotificationEntity {
  final int id;
  final int? parentId;
  final int? childId;
  final String type;
  final String content;
  final bool isRead;
  final String? createdAt;

  const NotificationEntity({
    required this.id,
    this.parentId,
    this.childId,
    required this.type,
    required this.content,
    required this.isRead,
    this.createdAt,
  });

  bool get isLinkedToChild => childId != null && childId! > 0;

  String get readableType {
    switch (type.toUpperCase()) {
      case 'NOUVELLE_NOTE':
        return 'Nouvelle note';
      case 'PRESENCE_AJOUTEE':
        return 'Présence';
      case 'NOUVEAU_COMMENTAIRE':
        return 'Nouveau commentaire';
      case 'LIAISON_APPROUVEE':
        return 'Liaison approuvée';
      case 'MODIFICATION_PROFIL_ENFANT':
        return 'Profil enfant';
      default:
        return 'Notification';
    }
  }

  NotificationEntity copyWith({
    int? id,
    int? parentId,
    int? childId,
    String? type,
    String? content,
    bool? isRead,
    String? createdAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      childId: childId ?? this.childId,
      type: type ?? this.type,
      content: content ?? this.content,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}