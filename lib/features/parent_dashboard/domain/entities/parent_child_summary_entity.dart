class ParentChildSummaryEntity {
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

  const ParentChildSummaryEntity({
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

  String get fullName => '$firstName $lastName'.trim();
}