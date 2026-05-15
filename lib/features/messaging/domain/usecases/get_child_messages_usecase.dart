import '../entities/message_entity.dart';
import '../repositories/messaging_repository.dart';

class GetChildMessagesUsecase {
  final MessagingRepository repository;

  GetChildMessagesUsecase(this.repository);

  Future<List<MessageEntity>> call({
    required int childId,
  }) {
    return repository.getChildMessages(
      childId: childId,
    );
  }
}