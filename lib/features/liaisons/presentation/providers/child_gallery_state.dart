import '../../domain/entities/child_gallery_item_entity.dart';

class ChildGalleryState {
  final bool isLoading;
  final bool isSubmitting;
  final List<ChildGalleryItemEntity> children;
  final Set<int> selectedChildIds;
  final String? errorMessage;
  final String? successMessage;

  const ChildGalleryState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.children = const [],
    this.selectedChildIds = const {},
    this.errorMessage,
    this.successMessage,
  });

  bool get hasSelectedChildren => selectedChildIds.isNotEmpty;

  ChildGalleryState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<ChildGalleryItemEntity>? children,
    Set<int>? selectedChildIds,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return ChildGalleryState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      children: children ?? this.children,
      selectedChildIds: selectedChildIds ?? this.selectedChildIds,
      errorMessage: clearMessages ? null : errorMessage,
      successMessage: clearMessages ? null : successMessage,
    );
  }
}