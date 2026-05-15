import '../../domain/entities/parent_dashboard_entity.dart';

class ParentDashboardState {
  final bool isLoading;
  final ParentDashboardEntity? dashboard;
  final String? errorMessage;

  const ParentDashboardState({
    this.isLoading = false,
    this.dashboard,
    this.errorMessage,
  });

  ParentDashboardState copyWith({
    bool? isLoading,
    ParentDashboardEntity? dashboard,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ParentDashboardState(
      isLoading: isLoading ?? this.isLoading,
      dashboard: dashboard ?? this.dashboard,
      errorMessage: clearError ? null : errorMessage,
    );
  }
}