import '../repositories/liaisons_repository.dart';

class RequestLiaisonUsecase {
  final LiaisonsRepository repository;

  RequestLiaisonUsecase(this.repository);

  Future<String> call({
    required int childId,
  }) {
    return repository.requestLiaison(
      childId: childId,
    );
  }
}