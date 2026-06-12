import 'package:communalis_application_mobile/features/child_profile/domain/entities/child_profile_entity.dart';
import 'package:communalis_application_mobile/features/child_profile/presentation/providers/child_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/router/route_names.dart';
import '../../../../../shared/utils/child_display_formatter.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_text_styles.dart';

class StudentGradesScreen extends ConsumerStatefulWidget {
  final int childId;

  const StudentGradesScreen({super.key, required this.childId});

  @override
  ConsumerState<StudentGradesScreen> createState() =>
      _StudentGradesScreenState();
}

class _StudentGradesScreenState extends ConsumerState<StudentGradesScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedLevel = 'ALL';
  bool _newestFirst = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(_loadGrades);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadGrades() {
    return ref
        .read(childProfileProvider.notifier)
        .loadChildProfile(childId: widget.childId);
  }

  List<ChildGradeEntity> _filteredGrades(List<ChildGradeEntity> grades) {
    final query = _searchQuery.trim().toLowerCase();

    final filtered = grades.where((grade) {
      final subject = grade.subject.toLowerCase();
      final remark = (grade.remark ?? '').toLowerCase();
      final value = grade.value;

      final matchesSearch =
          query.isEmpty || subject.contains(query) || remark.contains(query);

      final matchesLevel = switch (_selectedLevel) {
        'EXCELLENT' => value != null && value >= 14,
        'AVERAGE' => value != null && value >= 10 && value < 14,
        'LOW' => value != null && value < 10,
        _ => true,
      };

      return matchesSearch && matchesLevel;
    }).toList();

    filtered.sort((a, b) {
      final dateA = DateTime.tryParse(a.date ?? '');
      final dateB = DateTime.tryParse(b.date ?? '');

      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;

      return _newestFirst ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
    });

    return filtered;
  }

  double? _average(List<ChildGradeEntity> grades) {
    final validGrades = grades.where((grade) => grade.value != null).toList();

    if (validGrades.isEmpty) return null;

    final total = validGrades.fold<double>(
      0,
      (sum, grade) => sum + (grade.value ?? 0),
    );

    return total / validGrades.length;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(childProfileProvider);
    final child = state.childProfile;

    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryYellow,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(RouteNames.parentDashboard);
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.black,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              'Notes de l’enfant',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryRed,
          onRefresh: _loadGrades,
          child: Builder(
            builder: (context) {
              if (state.isLoading && child == null) {
                return const _GradesSkeleton();
              }

              if (state.errorMessage != null && child == null) {
                return _GradesStateCard(
                  icon: Icons.wifi_off_rounded,
                  title: 'Impossible de charger les notes',
                  message: 'Veuillez vérifier votre connexion puis réessayer.',
                  actionLabel: 'Réessayer',
                  onAction: _loadGrades,
                );
              }

              if (child == null) {
                return const _GradesStateCard(
                  icon: Icons.school_outlined,
                  title: 'Données indisponibles',
                  message:
                      'Nous n’avons pas pu récupérer les notes pour le moment.',
                );
              }

              final grades = child.grades;
              final average = _average(grades);
              final filteredGrades = _filteredGrades(grades);

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                children: [
                  _GradesHeader(child: child),

                  const SizedBox(height: AppSpacing.lg),

                  _GradesSummary(grades: grades, average: average),

                  const SizedBox(height: AppSpacing.lg),

                  _AverageCard(average: average),

                  const SizedBox(height: AppSpacing.lg),

                  _GradesSearchBar(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    onClear: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  _GradesFilters(
                    selectedLevel: _selectedLevel,
                    newestFirst: _newestFirst,
                    onLevelChanged: (value) {
                      setState(() {
                        _selectedLevel = value;
                      });
                    },
                    onSortChanged: () {
                      setState(() {
                        _newestFirst = !_newestFirst;
                      });
                    },
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Center(
                    child: Text(
                      '${filteredGrades.length} note(s) trouvée(s)',
                      style: AppTextStyles.bodyBold.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  if (grades.isEmpty)
                    const _GradesStateCard(
                      icon: Icons.note_alt_outlined,
                      title: 'Aucune note enregistrée',
                      message:
                          'Les notes apparaîtront ici dès qu’elles seront ajoutées.',
                    )
                  else if (filteredGrades.isEmpty)
                    const _GradesStateCard(
                      icon: Icons.search_off_rounded,
                      title: 'Aucun résultat',
                      message:
                          'Aucune note ne correspond à votre recherche ou filtre.',
                    )
                  else
                    ...filteredGrades.map((grade) => _GradeCard(grade: grade)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _GradesHeader extends StatelessWidget {
  final ChildProfileEntity child;

  const _GradesHeader({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.black, width: 1.2),
      ),
      child: Row(
        children: [
          _ChildAvatar(photoUrl: child.photoUrl),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.fullName.isEmpty ? 'Enfant' : child.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.black,
                    fontSize: 21,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  ChildDisplayFormatter.formatClass(child.className),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  ChildDisplayFormatter.formatMatricule(child.matricule),
                  style: AppTextStyles.caption.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GradesSummary extends StatelessWidget {
  final List<ChildGradeEntity> grades;
  final double? average;

  const _GradesSummary({required this.grades, required this.average});

  int get excellentCount =>
      grades.where((grade) => (grade.value ?? -1) >= 14).length;

  int get averageCount => grades.where((grade) {
    final value = grade.value;
    return value != null && value >= 10 && value < 14;
  }).length;

  int get lowCount => grades.where((grade) {
    final value = grade.value;
    return value != null && value < 10;
  }).length;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryBox(
            label: 'Excellent',
            value: '$excellentCount',
            helper: '≥14/20',
            color: AppColors.success,
            icon: Icons.workspace_premium_outlined,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _SummaryBox(
            label: 'À améliorer',
            value: '$lowCount',
            helper: '<10/20',
            color: AppColors.primaryRed,
            icon: Icons.error_outline_rounded,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _SummaryBox(
            label: 'Moyen',
            value: '$averageCount',
            helper: '10-13/20',
            color: AppColors.warning,
            icon: Icons.remove_circle_outline,
          ),
        ),
      ],
    );
  }
}

class _AverageCard extends StatelessWidget {
  final double? average;

  const _AverageCard({required this.average});

  @override
  Widget build(BuildContext context) {
    final value = average == null ? '--' : average!.toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.bar_chart_rounded,
            color: AppColors.primaryRed,
            size: 30,
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Moyenne générale',
                style: AppTextStyles.bodyBold.copyWith(color: AppColors.black),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '$value/20',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.primaryRed,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GradesSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _GradesSearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Rechercher une matière ou une remarque',
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.primaryRed,
        ),
        suffixIcon: controller.text.trim().isEmpty
            ? null
            : IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.close_rounded),
              ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.black, width: 1.1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.black, width: 1.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 1.4),
        ),
      ),
    );
  }
}

class _GradesFilters extends StatelessWidget {
  final String selectedLevel;
  final bool newestFirst;
  final ValueChanged<String> onLevelChanged;
  final VoidCallback onSortChanged;

  const _GradesFilters({
    required this.selectedLevel,
    required this.newestFirst,
    required this.onLevelChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.black, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtres de recherche',
            style: AppTextStyles.bodyBold.copyWith(color: AppColors.black),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _FilterChipButton(
                label: 'Toutes',
                value: 'ALL',
                selectedValue: selectedLevel,
                color: AppColors.black,
                onTap: onLevelChanged,
              ),
              _FilterChipButton(
                label: 'Excellent',
                value: 'EXCELLENT',
                selectedValue: selectedLevel,
                color: AppColors.success,
                onTap: onLevelChanged,
              ),
              _FilterChipButton(
                label: 'Moyen',
                value: 'AVERAGE',
                selectedValue: selectedLevel,
                color: AppColors.warning,
                onTap: onLevelChanged,
              ),
              _FilterChipButton(
                label: 'À améliorer',
                value: 'LOW',
                selectedValue: selectedLevel,
                color: AppColors.primaryRed,
                onTap: onLevelChanged,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          InkWell(
            onTap: onSortChanged,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryYellow.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: AppColors.black),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.swap_vert_rounded,
                    color: AppColors.black,
                    size: 18,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    newestFirst ? 'Notes récentes' : 'Notes anciennes',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradeCard extends StatelessWidget {
  final ChildGradeEntity grade;

  const _GradeCard({required this.grade});

  Color get _color {
    final value = grade.value;

    if (value == null) return AppColors.grey;
    if (value >= 14) return AppColors.success;
    if (value >= 10) return AppColors.warning;

    return AppColors.primaryRed;
  }

  String get _dateText {
    final raw = grade.date?.trim();

    if (raw == null || raw.isEmpty) return 'Date indisponible';

    final parsed = DateTime.tryParse(raw);

    if (parsed == null) return raw;

    return '${parsed.day.toString().padLeft(2, '0')}/${parsed.month.toString().padLeft(2, '0')}/${parsed.year}';
  }

  String get _valueText {
    if (grade.value == null) return '--';
    return grade.value!.toStringAsFixed(grade.value! % 1 == 0 ? 0 : 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: _color.withValues(alpha: 0.75), width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Text(
              _valueText,
              style: AppTextStyles.bodyBold.copyWith(
                color: _color,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  grade.subject.trim().isEmpty
                      ? 'Matière non renseignée'
                      : grade.subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyBold.copyWith(
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  grade.remark?.trim().isNotEmpty == true
                      ? grade.remark!
                      : 'Aucune appréciation renseignée.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.darkGrey,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _dateText,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final String label;
  final String value;
  final String helper;
  final Color color;
  final IconData icon;

  const _SummaryBox({
    required this.label,
    required this.value,
    required this.helper,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color, width: 1.1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: AppTextStyles.bodyBold.copyWith(color: color)),
          Text(
            helper,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.darkGrey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final String value;
  final String selectedValue;
  final Color color;
  final ValueChanged<String> onTap;

  const _FilterChipButton({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == selectedValue;

    return InkWell(
      onTap: () => onTap(value),
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? color : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: selected ? color : AppColors.black),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: selected ? AppColors.white : AppColors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _GradesStateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _GradesStateCard({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        const SizedBox(height: AppSpacing.xl),
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.black, width: 1.2),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primaryRed, size: 52),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.darkGrey,
                  height: 1.35,
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: onAction,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(
                      actionLabel!,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        side: const BorderSide(
                          color: AppColors.black,
                          width: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _GradesSkeleton extends StatelessWidget {
  const _GradesSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: const [
        _SkeletonBox(height: 120),
        SizedBox(height: AppSpacing.lg),
        _SkeletonBox(height: 78),
        SizedBox(height: AppSpacing.md),
        _SkeletonBox(height: 94),
        SizedBox(height: AppSpacing.md),
        _SkeletonBox(height: 180),
        SizedBox(height: AppSpacing.md),
        _SkeletonBox(height: 78),
        SizedBox(height: AppSpacing.md),
        _SkeletonBox(height: 78),
      ],
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double height;

  const _SkeletonBox({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.black.withValues(alpha: 0.22)),
      ),
    );
  }
}

class _ChildAvatar extends StatelessWidget {
  final String? photoUrl;

  const _ChildAvatar({required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.trim().isNotEmpty;

    return Container(
      width: 62,
      height: 62,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        border: Border.all(color: AppColors.black, width: 1.3),
      ),
      child: ClipOval(
        child: hasPhoto
            ? Image.network(
                photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const _AvatarFallback();
                },
              )
            : const _AvatarFallback(),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.primaryYellow,
      child: Icon(Icons.person_rounded, color: AppColors.black, size: 32),
    );
  }
}
