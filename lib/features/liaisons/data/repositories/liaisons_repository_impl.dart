import '../../domain/entities/child_gallery_item_entity.dart';
import '../../domain/repositories/liaisons_repository.dart';
import '../datasources/liaisons_remote_datasource.dart';
import '../../../../../shared/enums/liaison_status.dart';

class LiaisonsRepositoryImpl implements LiaisonsRepository {
  final LiaisonsRemoteDatasource remoteDatasource;

  LiaisonsRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<ChildGalleryItemEntity>> getChildrenGallery({
    String? search,
  }) async {
    final models = await remoteDatasource.getChildrenGallery(search: search);

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<String> requestLiaison({required int childId}) {
    return remoteDatasource.requestLiaison(childId: childId);
  }

  @override
  Future<LiaisonStatus> getMyLiaisonStatus() {
    return remoteDatasource.getMyLiaisonStatus();
  }
}
