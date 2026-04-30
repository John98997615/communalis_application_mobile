import '../../domain/entities/child_gallery_item_entity.dart';

class ChildGalleryItemModel {
  final int id;
  final String matricule;
  final String firstName;
  final String lastName;
  final String? className;
  final String? level;
  final String? photoUrl;

  const ChildGalleryItemModel({
    required this.id,
    required this.matricule,
    required this.firstName,
    required this.lastName,
    this.className,
    this.level,
    this.photoUrl,
  });

  factory ChildGalleryItemModel.fromJson(Map<String, dynamic> json) {
    return ChildGalleryItemModel(
      id: int.tryParse(
            (json['id_enfant'] ??
                    json['id'] ??
                    json['_id'] ??
                    json['childId'])
                .toString(),
          ) ??
          0,
      matricule: (json['matricule'] ?? '').toString(),
      firstName: (json['prenom'] ?? json['firstName'] ?? '').toString(),
      lastName: (json['nom'] ?? json['lastName'] ?? '').toString(),
      className: json['classe']?.toString() ?? json['className']?.toString(),
      level: json['niveau_scolaire']?.toString() ?? json['level']?.toString(),
      photoUrl: json['photo_url']?.toString() ??
          json['photoUrl']?.toString() ??
          json['avatarUrl']?.toString(),
    );
  }

  ChildGalleryItemEntity toEntity() {
    return ChildGalleryItemEntity(
      id: id,
      matricule: matricule,
      firstName: firstName,
      lastName: lastName,
      className: className,
      level: level,
      photoUrl: photoUrl,
    );
  }
}