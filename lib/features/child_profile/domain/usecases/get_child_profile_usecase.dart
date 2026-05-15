import '../entities/child_profile_entity.dart';
import '../repositories/child_profile_repository.dart';

class GetChildProfileUsecase {
  final ChildProfileRepository repository;

  GetChildProfileUsecase(this.repository);

  Future<ChildProfileEntity> call({
    required int childId,
  }) {
    return repository.getChildProfile(
      childId: childId,
    );
  }
}