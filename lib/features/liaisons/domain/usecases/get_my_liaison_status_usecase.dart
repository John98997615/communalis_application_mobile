import '../repositories/liaisons_repository.dart';

class GetMyLiaisonStatusUsecase {
  final LiaisonsRepository repository;

  GetMyLiaisonStatusUsecase(this.repository);

  Future<String?> call() {
    return repository.getMyLiaisonStatus();
  }
}