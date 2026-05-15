import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../../core/network/api_client.dart';
import '../../data/datasources/child_profile_remote_datasource.dart';
import '../../data/repositories/child_profile_repository_impl.dart';
import '../../domain/repositories/child_profile_repository.dart';
import '../../domain/usecases/get_child_profile_usecase.dart';
import 'child_profile_state.dart';

final childProfileRemoteDatasourceProvider =
    Provider<ChildProfileRemoteDatasource>((ref) {
  return ChildProfileRemoteDatasource(
    apiClient: ApiClient.instance,
  );
});

final childProfileRepositoryProvider =
    Provider<ChildProfileRepository>((ref) {
  return ChildProfileRepositoryImpl(
    remoteDatasource: ref.watch(childProfileRemoteDatasourceProvider),
  );
});

final getChildProfileUsecaseProvider =
    Provider<GetChildProfileUsecase>((ref) {
  return GetChildProfileUsecase(
    ref.watch(childProfileRepositoryProvider),
  );
});

final childProfileProvider =
    StateNotifierProvider<ChildProfileNotifier, ChildProfileState>((ref) {
  return ChildProfileNotifier(
    getChildProfileUsecase: ref.watch(getChildProfileUsecaseProvider),
  );
});

class ChildProfileNotifier extends StateNotifier<ChildProfileState> {
  final GetChildProfileUsecase getChildProfileUsecase;

  ChildProfileNotifier({
    required this.getChildProfileUsecase,
  }) : super(const ChildProfileState());

  Future<void> loadChildProfile({
    required int childId,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final childProfile = await getChildProfileUsecase(
        childId: childId,
      );

      state = state.copyWith(
        isLoading: false,
        childProfile: childProfile,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }
}