import '../../../../../shared/enums/liaison_status.dart';
import '../entities/child_gallery_item_entity.dart';

abstract class LiaisonsRepository {
  Future<List<ChildGalleryItemEntity>> getChildrenGallery({
    String? search,
  });

  Future<String> requestLiaison({
    required int childId,
  });

  Future<LiaisonStatus> getMyLiaisonStatus();
}