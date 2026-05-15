import '../entities/parent_dashboard_entity.dart';
import '../repositories/parent_dashboard_repository.dart';

class GetParentDashboardUsecase {
  final ParentDashboardRepository repository;

  GetParentDashboardUsecase(this.repository);

  Future<ParentDashboardEntity> call() {
    return repository.getDashboard();
  }
}