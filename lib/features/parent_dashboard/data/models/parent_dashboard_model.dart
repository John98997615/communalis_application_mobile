import '../../domain/entities/parent_dashboard_entity.dart';
import 'parent_child_summary_model.dart';

class ParentDashboardModel {
  final int parentId;
  final int totalChildren;
  final List<ParentChildSummaryModel> children;

  const ParentDashboardModel({
    required this.parentId,
    required this.totalChildren,
    required this.children,
  });

  factory ParentDashboardModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final childrenRaw = data['children'];

    return ParentDashboardModel(
      parentId: int.tryParse((data['parentId'] ?? 0).toString()) ?? 0,
      totalChildren: int.tryParse((data['totalChildren'] ?? 0).toString()) ?? 0,
      children: childrenRaw is List
          ? childrenRaw
              .whereType<Map<String, dynamic>>()
              .map(ParentChildSummaryModel.fromJson)
              .toList()
          : [],
    );
  }

  ParentDashboardEntity toEntity() {
    return ParentDashboardEntity(
      parentId: parentId,
      totalChildren: totalChildren,
      children: children.map((child) => child.toEntity()).toList(),
    );
  }
}