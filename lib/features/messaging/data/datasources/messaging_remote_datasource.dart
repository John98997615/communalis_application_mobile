import '../../../../../app/config/api_endpoints.dart';
import '../../../../../core/network/api_client.dart';
import '../models/message_model.dart';

class MessagingRemoteDatasource {
  final ApiClient apiClient;

  MessagingRemoteDatasource({
    required this.apiClient,
  });

  Future<List<MessageModel>> getChildMessages({
    required int childId,
  }) async {
    final response = await apiClient.get(
      ApiEndpoints.childMessages(childId),
    );

    final data = response.data;
    List<dynamic> rawMessages = [];

    if (data is Map<String, dynamic>) {
      final responseData = data['data'];

      if (responseData is Map<String, dynamic> &&
          responseData['comments'] is List) {
        rawMessages = responseData['comments'] as List;
      } else if (data['comments'] is List) {
        rawMessages = data['comments'] as List;
      }
    }

    return rawMessages
        .whereType<Map<String, dynamic>>()
        .map(MessageModel.fromJson)
        .toList();
  }

  Future<MessageModel> sendChildMessage({
    required int childId,
    required String message,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.sendChildMessage(childId),
      data: {
        'message': message.trim(),
      },
    );

    final data = response.data;

    if (data is Map<String, dynamic>) {
      final responseData = data['data'];

      if (responseData is Map<String, dynamic> &&
          responseData['comment'] is Map<String, dynamic>) {
        return MessageModel.fromJson(
          Map<String, dynamic>.from(responseData['comment']),
        );
      }
    }

    throw Exception('Réponse invalide lors de l’envoi du message.');
  }
}