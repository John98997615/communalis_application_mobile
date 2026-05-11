import '../../../../../shared/enums/liaison_status.dart';
import 'package:communalis_application_mobile/app/config/api_endpoints.dart';
import 'package:communalis_application_mobile/core/network/api_client.dart';

import '../models/child_gallery_item_model.dart';

class LiaisonsRemoteDatasource {
  final ApiClient apiClient;

  LiaisonsRemoteDatasource({required this.apiClient});

  Future<List<ChildGalleryItemModel>> getChildrenGallery({
    String? search,
  }) async {
    final response = await apiClient.get(
      ApiEndpoints.childrenGallery,
      queryParameters: {
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );

    final rawData = response.data;
    final List<dynamic> list = _extractList(rawData);

    return list
        .whereType<Map<String, dynamic>>()
        .map(ChildGalleryItemModel.fromJson)
        .where((child) => child.id != 0)
        .toList();
  }

  Future<String> requestLiaison({required int childId}) async {
    final response = await apiClient.post(
      ApiEndpoints.requestLiaison,
      data: {'id_enfant': childId},
    );

    final data = response.data;

    if (data is Map<String, dynamic>) {
      return (data['message'] ??
              data['data']?['message'] ??
              'Demande envoyée avec succès.')
          .toString();
    }

    return 'Demande envoyée avec succès.';
  }

  Future<LiaisonStatus> getMyLiaisonStatus() async {
    final response = await apiClient.get(ApiEndpoints.myLiaisonStatus);

    final data = response.data;

    if (data is Map<String, dynamic>) {
      final rawStatus =
          data['status'] ??
          data['statut'] ??
          data['data']?['status'] ??
          data['data']?['statut'];

      return LiaisonStatus.fromString(rawStatus?.toString());
    }

    return LiaisonStatus.unknown;
  }

  List<dynamic> _extractList(dynamic rawData) {
    if (rawData is List) {
      return rawData;
    }

    if (rawData is Map<String, dynamic>) {
      final data = rawData['data'];

      if (data is List) return data;

      if (data is Map<String, dynamic>) {
        if (data['students'] is List) return data['students'];
        if (data['children'] is List) return data['children'];
        if (data['enfants'] is List) return data['enfants'];
        if (data['items'] is List) return data['items'];
      }

      if (rawData['students'] is List) return rawData['students'];
      if (rawData['children'] is List) return rawData['children'];
      if (rawData['enfants'] is List) return rawData['enfants'];
      if (rawData['items'] is List) return rawData['items'];
    }

    return [];
  }
}
