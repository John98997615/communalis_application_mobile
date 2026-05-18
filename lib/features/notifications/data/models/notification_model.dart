import '../../domain/entities/notification_entity.dart';

class NotificationModel {
  final int id;
  final int? parentId;
  final int? childId;
  final String type;
  final String content;
  final bool isRead;
  final String? createdAt;

  const NotificationModel({
    required this.id,
    this.parentId,
    this.childId,
    required this.type,
    required this.content,
    required this.isRead,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: int.tryParse(
            (json['id'] ?? json['id_notification'] ?? 0).toString(),
          ) ??
          0,
      parentId: int.tryParse(
        (json['parentId'] ?? json['parent_id'] ?? '').toString(),
      ),
      childId: int.tryParse(
        (json['childId'] ?? json['enfant_id'] ?? '').toString(),
      ),
      type: (json['type'] ?? 'NOTIFICATION').toString(),
      content: (json['content'] ?? json['contenu'] ?? '').toString(),
      isRead: json['isRead'] == true || json['lu'] == true,
      createdAt: json['createdAt']?.toString() ??
          json['date_envoi']?.toString(),
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      parentId: parentId,
      childId: childId,
      type: type,
      content: content,
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}