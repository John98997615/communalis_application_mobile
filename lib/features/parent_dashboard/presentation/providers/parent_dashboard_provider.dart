import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../../core/network/api_client.dart';
import '../../data/datasources/parent_dashboard_remote_datasource.dart';
import '../../data/repositories/parent_dashboard_repository_impl.dart';
import '../../domain/repositories/parent_dashboard_repository.dart';
import '../../domain/usecases/get_parent_dashboard_usecase.dart';
import 'parent_dashboard_state.dart';

final parentDashboardRemoteDatasourceProvider =
    Provider<ParentDashboardRemoteDatasource>((ref) {
  return ParentDashboardRemoteDatasource(
    apiClient: ApiClient.instance,
  );
});

final parentDashboardRepositoryProvider =
    Provider<ParentDashboardRepository>((ref) {
  return ParentDashboardRepositoryImpl(
    remoteDatasource: ref.watch(parentDashboardRemoteDatasourceProvider),
  );
});

final getParentDashboardUsecaseProvider =
    Provider<GetParentDashboardUsecase>((ref) {
  return GetParentDashboardUsecase(
    ref.watch(parentDashboardRepositoryProvider),
  );
});

final parentDashboardProvider =
    StateNotifierProvider<ParentDashboardNotifier, ParentDashboardState>((ref) {
  return ParentDashboardNotifier(
    getParentDashboardUsecase: ref.watch(getParentDashboardUsecaseProvider),
  );
});

class ParentDashboardNotifier extends StateNotifier<ParentDashboardState> {
  final GetParentDashboardUsecase getParentDashboardUsecase;

  ParentDashboardNotifier({
    required this.getParentDashboardUsecase,
  }) : super(const ParentDashboardState());

  Future<void> loadDashboard() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final dashboard = await getParentDashboardUsecase();

      state = state.copyWith(
        isLoading: false,
        dashboard: dashboard,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }
}