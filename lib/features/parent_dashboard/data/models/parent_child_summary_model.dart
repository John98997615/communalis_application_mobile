import '../../domain/entities/parent_child_summary_entity.dart';

class ParentChildSummaryModel {
  final int id;
  final String matricule;
  final String firstName;
  final String lastName;
  final String? sexe;
  final String? className;
  final String? level;
  final String? birthDate;
  final String? photoUrl;
  final double? average;
  final String performanceLevel;
  final List<dynamic> latestGrades;
  final List<dynamic> latestAttendance;
  final List<dynamic> latestComments;

  const ParentChildSummaryModel({
    required this.id,
    required this.matricule,
    required this.firstName,
    required this.lastName,
    this.sexe,
    this.className,
    this.level,
    this.birthDate,
    this.photoUrl,
    this.average,
    required this.performanceLevel,
    this.latestGrades = const [],
    this.latestAttendance = const [],
    this.latestComments = const [],
  });

  factory ParentChildSummaryModel.fromJson(Map<String, dynamic> json) {
    return ParentChildSummaryModel(
      id: int.tryParse((json['id'] ?? json['id_enfant'] ?? 0).toString()) ?? 0,
      matricule: (json['matricule'] ?? '').toString(),
      firstName: (json['firstName'] ?? json['prenom'] ?? '').toString(),
      lastName: (json['lastName'] ?? json['nom'] ?? '').toString(),
      sexe: json['sexe']?.toString(),
      className: json['className']?.toString() ?? json['classe']?.toString(),
      level: json['level']?.toString() ?? json['niveau_scolaire']?.toString(),
      birthDate: json['date_naissance']?.toString(),
      photoUrl: json['photoUrl']?.toString() ?? json['photo_url']?.toString(),
      average: json['average'] == null
          ? null
          : double.tryParse(json['average'].toString()),
      performanceLevel: (json['performanceLevel'] ?? 'NONE').toString(),
      latestGrades: json['latestGrades'] is List ? json['latestGrades'] : [],
      latestAttendance:
          json['latestAttendance'] is List ? json['latestAttendance'] : [],
      latestComments:
          json['latestComments'] is List ? json['latestComments'] : [],
    );
  }

  ParentChildSummaryEntity toEntity() {
    return ParentChildSummaryEntity(
      id: id,
      matricule: matricule,
      firstName: firstName,
      lastName: lastName,
      sexe: sexe,
      className: className,
      level: level,
      birthDate: birthDate,
      photoUrl: photoUrl,
      average: average,
      performanceLevel: performanceLevel,
      latestGrades: latestGrades,
      latestAttendance: latestAttendance,
      latestComments: latestComments,
    );
  }
}