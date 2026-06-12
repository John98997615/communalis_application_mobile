import '../../domain/entities/parent_dashboard_entity.dart';
import 'parent_child_summary_model.dart';

class ParentDashboardModel {
  final int parentId;
  final String parentName;
  final int totalChildren;
  final int pendingAssociationCount;
  final List<ParentChildSummaryModel> children;
  final String? parentPhotoUrl;

  const ParentDashboardModel({
    required this.parentId,
    required this.parentName,
    required this.totalChildren,
    required this.children,
    required this.pendingAssociationCount,
    this.parentPhotoUrl,
  });

  factory ParentDashboardModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final childrenRaw = data['children'];

    return ParentDashboardModel(
      parentId: int.tryParse((data['parentId'] ?? 0).toString()) ?? 0,
      parentName:
          data['parentName']?.toString() ??
          data['parent']?['fullName']?.toString() ??
          'Parent',
      totalChildren: int.tryParse((data['totalChildren'] ?? 0).toString()) ?? 0,
      pendingAssociationCount: int.tryParse((data['pendingAssociationCount'] ?? 0).toString()) ?? 0,
      children: childrenRaw is List
          ? childrenRaw
                .whereType<Map<String, dynamic>>()
                .map(ParentChildSummaryModel.fromJson)
                .toList()
          : [],
      parentPhotoUrl: data['parentPhotoUrl']?.toString(),
    );
  }

  ParentDashboardEntity toEntity() {
    return ParentDashboardEntity(
      parentId: parentId,
      parentName: parentName,
      totalChildren: totalChildren,
      children: children.map((child) => child.toEntity()).toList(),
      pendingAssociationCount: pendingAssociationCount,
      parentPhotoUrl: parentPhotoUrl,
    );
  }
}
