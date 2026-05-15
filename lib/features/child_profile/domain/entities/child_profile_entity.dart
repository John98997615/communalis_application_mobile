class ChildProfileEntity {
  final int id;
  final String matricule;
  final String firstName;
  final String lastName;
  final String? sexe;
  final String? className;
  final String? level;
  final String? birthDate;
  final String? photoUrl;
  final String? subjects;
  final double? average;
  final String performanceLevel;
  final ChildProfileStatsEntity stats;
  final List<ChildGradeEntity> grades;
  final List<ChildAttendanceEntity> attendance;
  final List<ChildCommentEntity> comments;

  const ChildProfileEntity({
    required this.id,
    required this.matricule,
    required this.firstName,
    required this.lastName,
    this.sexe,
    this.className,
    this.level,
    this.birthDate,
    this.photoUrl,
    this.subjects,
    this.average,
    required this.performanceLevel,
    required this.stats,
    this.grades = const [],
    this.attendance = const [],
    this.comments = const [],
  });

  String get fullName => '$firstName $lastName'.trim();
}

class ChildProfileStatsEntity {
  final int totalGrades;
  final int totalAttendance;
  final int presentCount;
  final int absentCount;
  final int lateCount;

  const ChildProfileStatsEntity({
    required this.totalGrades,
    required this.totalAttendance,
    required this.presentCount,
    required this.absentCount,
    required this.lateCount,
  });
}

class ChildGradeEntity {
  final int id;
  final String subject;
  final double? value;
  final String? remark;
  final String? date;

  const ChildGradeEntity({
    required this.id,
    required this.subject,
    this.value,
    this.remark,
    this.date,
  });
}

class ChildAttendanceEntity {
  final int id;
  final String status;
  final String? date;

  const ChildAttendanceEntity({
    required this.id,
    required this.status,
    this.date,
  });
}

class ChildCommentEntity {
  final int id;
  final String message;
  final String? authorRole;
  final String? date;

  const ChildCommentEntity({
    required this.id,
    required this.message,
    this.authorRole,
    this.date,
  });
}