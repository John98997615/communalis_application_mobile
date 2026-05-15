import '../../domain/entities/child_profile_entity.dart';
import '../../domain/repositories/child_profile_repository.dart';
import '../datasources/child_profile_remote_datasource.dart';

class ChildProfileRepositoryImpl implements ChildProfileRepository {
  final ChildProfileRemoteDatasource remoteDatasource;

  ChildProfileRepositoryImpl({
    required this.remoteDatasource,
  });

  @override
  Future<ChildProfileEntity> getChildProfile({
    required int childId,
  }) async {
    final model = await remoteDatasource.getChildProfile(
      childId: childId,
    );

    return model.toEntity();
  }
}