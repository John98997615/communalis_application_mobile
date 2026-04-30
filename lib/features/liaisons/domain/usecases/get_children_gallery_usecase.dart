import '../entities/child_gallery_item_entity.dart';
import '../repositories/liaisons_repository.dart';

class GetChildrenGalleryUsecase {
  final LiaisonsRepository repository;

  GetChildrenGalleryUsecase(this.repository);

  Future<List<ChildGalleryItemEntity>> call({
    String? search,
  }) {
    return repository.getChildrenGallery(
      search: search,
    );
  }
}