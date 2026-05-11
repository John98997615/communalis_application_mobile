import '../../../../../shared/enums/liaison_status.dart';
import '../repositories/liaisons_repository.dart';

class GetMyLiaisonStatusUsecase {
  final LiaisonsRepository repository;

  GetMyLiaisonStatusUsecase(this.repository);

  Future<LiaisonStatus> call() {
    return repository.getMyLiaisonStatus();
  }
}