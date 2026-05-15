import '../../domain/entities/child_profile_entity.dart';

class ChildProfileModel {
  final ChildProfileEntity entity;

  const ChildProfileModel({
    required this.entity,
  });

  factory ChildProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final child = data['child'] is Map<String, dynamic>
        ? data['child'] as Map<String, dynamic>
        : <String, dynamic>{};

    final stats = data['stats'] is Map<String, dynamic>
        ? data['stats'] as Map<String, dynamic>
        : <String, dynamic>{};

    return ChildProfileModel(
      entity: ChildProfileEntity(
        id: _toInt(child['id'] ?? child['id_enfant']),
        matricule: (child['matricule'] ?? '').toString(),
        firstName: (child['firstName'] ?? child['prenom'] ?? '').toString(),
        lastName: (child['lastName'] ?? child['nom'] ?? '').toString(),
        sexe: child['sexe']?.toString(),
        className: child['className']?.toString() ?? child['classe']?.toString(),
        level: child['level']?.toString() ?? child['niveau_scolaire']?.toString(),
        birthDate: child['birthDate']?.toString() ?? child['date_naissance']?.toString(),
        photoUrl: child['photoUrl']?.toString() ?? child['photo_url']?.toString(),
        subjects: child['matieres']?.toString(),
        average: _toDouble(child['average']),
        performanceLevel: (child['performanceLevel'] ?? 'NONE').toString(),
        stats: ChildProfileStatsEntity(
          totalGrades: _toInt(stats['totalGrades']),
          totalAttendance: _toInt(stats['totalAttendance']),
          presentCount: _toInt(stats['presentCount']),
          absentCount: _toInt(stats['absentCount']),
          lateCount: _toInt(stats['lateCount']),
        ),
        grades: _parseGrades(data['grades']),
        attendance: _parseAttendance(data['attendance']),
        comments: _parseComments(data['comments']),
      ),
    );
  }

  ChildProfileEntity toEntity() => entity;

  static List<ChildGradeEntity> _parseGrades(dynamic raw) {
    if (raw is! List) return [];

    return raw.whereType<Map<String, dynamic>>().map((item) {
      return ChildGradeEntity(
        id: _toInt(item['id_note'] ?? item['id']),
        subject: (item['matiere'] ?? item['subject'] ?? 'Matière').toString(),
        value: _toDouble(item['valeur'] ?? item['note']),
        remark: item['remarque']?.toString() ?? item['remark']?.toString(),
        date: item['date_note']?.toString() ?? item['date']?.toString(),
      );
    }).toList();
  }

  static List<ChildAttendanceEntity> _parseAttendance(dynamic raw) {
    if (raw is! List) return [];

    return raw.whereType<Map<String, dynamic>>().map((item) {
      return ChildAttendanceEntity(
        id: _toInt(item['id_presence'] ?? item['id']),
        status: (item['statut'] ?? item['status'] ?? 'NON_RENSEIGNE').toString(),
        date: item['date_seance']?.toString() ??
            item['date_presence']?.toString() ??
            item['date']?.toString(),
      );
    }).toList();
  }

  static List<ChildCommentEntity> _parseComments(dynamic raw) {
    if (raw is! List) return [];

    return raw.whereType<Map<String, dynamic>>().map((item) {
      return ChildCommentEntity(
        id: _toInt(item['id_commentaire'] ?? item['id']),
        message: (item['message'] ?? item['contenu'] ?? '').toString(),
        authorRole: item['auteur_role']?.toString() ??
            item['authorRole']?.toString() ??
            item['role']?.toString(),
        date: item['envoye_le']?.toString() ??
            item['cree_le']?.toString() ??
            item['createdAt']?.toString(),
      );
    }).toList();
  }

  static int _toInt(dynamic value) {
    return int.tryParse((value ?? 0).toString()) ?? 0;
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    return double.tryParse(value.toString());
  }
}