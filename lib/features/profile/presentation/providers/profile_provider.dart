import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../../core/network/api_client.dart';
import '../../data/datasources/profile_remote_datasource.dart';

final profileRemoteDatasourceProvider = Provider<ProfileRemoteDatasource>((
  ref,
) {
  return ProfileRemoteDatasource(apiClient: ApiClient.instance);
});

class ProfileEditState {
  final bool isLoading;
  final bool isSaving;
  final Map<String, dynamic>? profile;
  final String? errorMessage;
  final String? successMessage;

  const ProfileEditState({
    this.isLoading = false,
    this.isSaving = false,
    this.profile,
    this.errorMessage,
    this.successMessage,
  });

  ProfileEditState copyWith({
    bool? isLoading,
    bool? isSaving,
    Map<String, dynamic>? profile,
    String? errorMessage,
    String? successMessage,
  }) {
    return ProfileEditState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileEditState> {
  final ProfileRemoteDatasource datasource;

  ProfileNotifier({required this.datasource}) : super(const ProfileEditState());

  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    String? photoUrl,
  }) async {
    state = state.copyWith(
      isSaving: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final response = await datasource.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        photoUrl: photoUrl,
      );

      final data = response['data'];

      state = state.copyWith(
        isSaving: false,
        profile: data is Map<String, dynamic> ? data : state.profile,
        successMessage: 'Profil mis à jour avec succès.',
      );

      return true;
    } catch (error) {
      state = state.copyWith(isSaving: false, errorMessage: error.toString());

      return false;
    }
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await datasource.getProfile();

      final data = response['data'];

      state = state.copyWith(
        isLoading: false,
        profile: data is Map<String, dynamic> ? data : null,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = state.copyWith(
      isSaving: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      await datasource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      state = state.copyWith(
        isSaving: false,
        successMessage: 'Mot de passe modifié avec succès.',
      );

      return true;
    } catch (error) {
      state = state.copyWith(isSaving: false, errorMessage: error.toString());

      return false;
    }
  }
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileEditState>((ref) {
      return ProfileNotifier(
        datasource: ref.read(profileRemoteDatasourceProvider),
      );
    });
