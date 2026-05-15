import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/messaging_repository.dart';
import '../datasources/messaging_remote_datasource.dart';

class MessagingRepositoryImpl implements MessagingRepository {
  final MessagingRemoteDatasource remoteDatasource;

  MessagingRepositoryImpl({
    required this.remoteDatasource,
  });

  @override
  Future<List<MessageEntity>> getChildMessages({
    required int childId,
  }) async {
    final models = await remoteDatasource.getChildMessages(
      childId: childId,
    );

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<MessageEntity> sendChildMessage({
    required int childId,
    required String message,
  }) async {
    final model = await remoteDatasource.sendChildMessage(
      childId: childId,
      message: message,
    );

    return model.toEntity();
  }
}