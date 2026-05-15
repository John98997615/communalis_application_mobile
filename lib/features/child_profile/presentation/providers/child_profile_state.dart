import '../../domain/entities/child_profile_entity.dart';

class ChildProfileState {
  final bool isLoading;
  final ChildProfileEntity? childProfile;
  final String? errorMessage;

  const ChildProfileState({
    this.isLoading = false,
    this.childProfile,
    this.errorMessage,
  });

  ChildProfileState copyWith({
    bool? isLoading,
    ChildProfileEntity? childProfile,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChildProfileState(
      isLoading: isLoading ?? this.isLoading,
      childProfile: childProfile ?? this.childProfile,
      errorMessage: clearError ? null : errorMessage,
    );
  }
}