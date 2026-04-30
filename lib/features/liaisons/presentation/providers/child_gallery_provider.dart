import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:communalis_application_mobile/core/network/api_client.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/datasources/liaisons_remote_datasource.dart';
import '../../data/repositories/liaisons_repository_impl.dart';
import '../../domain/repositories/liaisons_repository.dart';
import '../../domain/usecases/get_children_gallery_usecase.dart';
import '../../domain/usecases/request_liaison_usecase.dart';
import 'child_gallery_state.dart';

final liaisonsRemoteDatasourceProvider =
    Provider<LiaisonsRemoteDatasource>((ref) {
  return LiaisonsRemoteDatasource(
    apiClient: ApiClient.instance,
  );
});

final liaisonsRepositoryProvider = Provider<LiaisonsRepository>((ref) {
  return LiaisonsRepositoryImpl(
    remoteDatasource: ref.watch(liaisonsRemoteDatasourceProvider),
  );
});

final getChildrenGalleryUsecaseProvider =
    Provider<GetChildrenGalleryUsecase>((ref) {
  return GetChildrenGalleryUsecase(
    ref.watch(liaisonsRepositoryProvider),
  );
});

final requestLiaisonUsecaseProvider =
    Provider<RequestLiaisonUsecase>((ref) {
  return RequestLiaisonUsecase(
    ref.watch(liaisonsRepositoryProvider),
  );
});

final childGalleryProvider =
    StateNotifierProvider<ChildGalleryNotifier, ChildGalleryState>((ref) {
  return ChildGalleryNotifier(
    getChildrenGalleryUsecase: ref.watch(getChildrenGalleryUsecaseProvider),
    requestLiaisonUsecase: ref.watch(requestLiaisonUsecaseProvider),
  );
});

class ChildGalleryNotifier extends StateNotifier<ChildGalleryState> {
  final GetChildrenGalleryUsecase getChildrenGalleryUsecase;
  final RequestLiaisonUsecase requestLiaisonUsecase;

  ChildGalleryNotifier({
    required this.getChildrenGalleryUsecase,
    required this.requestLiaisonUsecase,
  }) : super(const ChildGalleryState());

  Future<void> loadChildren({
    String? search,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearMessages: true,
    );

    try {
      final children = await getChildrenGalleryUsecase(
        search: search,
      );

      state = state.copyWith(
        isLoading: false,
        children: children,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }

  void toggleChildSelection(int childId) {
    final updated = Set<int>.from(state.selectedChildIds);

    if (updated.contains(childId)) {
      updated.remove(childId);
    } else {
      updated.add(childId);
    }

    state = state.copyWith(
      selectedChildIds: updated,
      clearMessages: true,
    );
  }

  Future<void> sendRequests() async {
    if (state.selectedChildIds.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Veuillez sélectionner au moins un enfant.',
      );
      return;
    }

    state = state.copyWith(
      isSubmitting: true,
      clearMessages: true,
    );

    try {
      for (final childId in state.selectedChildIds) {
        await requestLiaisonUsecase(
          childId: childId,
        );
      }

      state = state.copyWith(
        isSubmitting: false,
        selectedChildIds: {},
        successMessage:
            'Demande envoyée. Veuillez attendre la validation de l’administrateur.',
      );
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.toString(),
      );
    }
  }

  void clearMessages() {
    state = state.copyWith(clearMessages: true);
  }
}