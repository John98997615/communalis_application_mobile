import 'parent_child_summary_entity.dart';

class ParentDashboardEntity {
  final int parentId;
  final int totalChildren;
  final String parentName;
  final int pendingAssociationCount;
  final List<ParentChildSummaryEntity> children;

  const ParentDashboardEntity({
    required this.parentId,
    required this.totalChildren,
    required this.parentName,
    required this.pendingAssociationCount,
    required this.children,
  });

  bool get hasChildren => children.isNotEmpty;
}