import '../../domain/entities/parent_dashboard_entity.dart';
import '../../domain/repositories/parent_dashboard_repository.dart';
import '../datasources/parent_dashboard_remote_datasource.dart';

class ParentDashboardRepositoryImpl implements ParentDashboardRepository {
  final ParentDashboardRemoteDatasource remoteDatasource;

  ParentDashboardRepositoryImpl({
    required this.remoteDatasource,
  });

  @override
  Future<ParentDashboardEntity> getDashboard() async {
    final model = await remoteDatasource.getDashboard();
    return model.toEntity();
  }
}