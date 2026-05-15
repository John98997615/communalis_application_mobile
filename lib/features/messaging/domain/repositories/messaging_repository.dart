import '../entities/message_entity.dart';

abstract class MessagingRepository {
  Future<List<MessageEntity>> getChildMessages({
    required int childId,
  });

  Future<MessageEntity> sendChildMessage({
    required int childId,
    required String message,
  });
}