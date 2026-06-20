import '../../../../../core/network/api_client.dart';

class ProfileRemoteDatasource {
  final ApiClient apiClient;

  const ProfileRemoteDatasource({
    required this.apiClient,
  });

  Future<Map<String, dynamic>> getProfile() async {
    final response = await apiClient.get('/parent/profile');

    final data = response.data;

    if (data is Map<String, dynamic>) {
      return data;
    }

    throw Exception('Réponse profil invalide.');
  }

  Future<Map<String, dynamic>> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    String? photoUrl,
  }) async {
    final response = await apiClient.put(
      '/parent/profile',
      data: {
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'phone': phone.trim(),
        'photoUrl': photoUrl?.trim(),
      },
    );

    final data = response.data;

    if (data is Map<String, dynamic>) {
      return data;
    }

    throw Exception('Réponse mise à jour profil invalide.');
  }

  Future<Map<String, dynamic>> changePassword({
  required String currentPassword,
  required String newPassword,
  required String confirmPassword,
}) async {
  final response = await apiClient.post(
    '/parent/change-password',
    data: {
      'currentPassword': currentPassword.trim(),
      'newPassword': newPassword.trim(),
      'confirmPassword': confirmPassword.trim(),
    },
  );

  final data = response.data;

  if (data is Map<String, dynamic>) {
    return data;
  }

  throw Exception('Réponse changement mot de passe invalide.');
}
}