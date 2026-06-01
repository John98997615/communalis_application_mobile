import '../../../child_profile/domain/entities/child_profile_entity.dart';

class AttendanceGroup {
  final String title;
  final List<ChildAttendanceEntity> items;

  const AttendanceGroup({
    required this.title,
    required this.items,
  });
}