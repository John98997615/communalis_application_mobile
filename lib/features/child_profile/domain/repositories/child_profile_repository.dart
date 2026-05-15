import '../entities/child_profile_entity.dart';

abstract class ChildProfileRepository {
  Future<ChildProfileEntity> getChildProfile({
    required int childId,
  });
}