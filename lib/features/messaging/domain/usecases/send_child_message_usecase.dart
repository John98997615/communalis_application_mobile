import '../entities/message_entity.dart';
import '../repositories/messaging_repository.dart';

class SendChildMessageUsecase {
  final MessagingRepository repository;

  SendChildMessageUsecase(this.repository);

  Future<MessageEntity> call({
    required int childId,
    required String message,
  }) {
    return repository.sendChildMessage(
      childId: childId,
      message: message,
    );
  }
}