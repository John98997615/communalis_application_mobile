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
import '../models/attendance_group.dart';

class StudentAttendanceScreen extends ConsumerStatefulWidget {
  final int childId;

  const StudentAttendanceScreen({super.key, required this.childId});

  @override
  ConsumerState<StudentAttendanceScreen> createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState
    extends ConsumerState<StudentAttendanceScreen> {
  String _selectedFilter = 'ALL';
  bool _newestFirst = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(_loadAttendance);
  }

  Future<void> _loadAttendance() {
    return ref
        .read(childProfileProvider.notifier)
        .loadChildProfile(childId: widget.childId);
  }

  List<AttendanceGroup> _groupAttendance(List<ChildAttendanceEntity> items) {
    final Map<String, List<ChildAttendanceEntity>> grouped = {};

    for (final item in items) {
      final rawDate = item.date;

      DateTime? parsed;

      if (rawDate != null) {
        parsed = DateTime.tryParse(rawDate);
      }

      final title = _groupTitle(parsed);

      grouped.putIfAbsent(title, () => []);
      grouped[title]!.add(item);
    }

    return grouped.entries.map((entry) {
      return AttendanceGroup(title: entry.key, items: entry.value);
    }).toList();
  }

  List<ChildAttendanceEntity> _filteredAttendance(
    List<ChildAttendanceEntity> items,
  ) {
    final filtered = items.where((item) {
      final status = _normalizeStatus(item.status);

      if (_selectedFilter == 'ALL') return true;

      return status == _selectedFilter;
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

  String _groupTitle(DateTime? date) {
    if (date == null) {
      return 'Autres';
    }

    final now = DateTime.now();

    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Aujourd’hui';
    }

    if (difference <= 7) {
      return 'Cette semaine';
    }

    if (difference <= 30) {
      return 'Ce mois';
    }

    return '${date.month}/${date.year}';
  }

  String _normalizeStatus(String value) {
    final status = value.trim().toUpperCase();

    if (status == 'PRESENT' || status == 'PRÉSENT') return 'PRESENT';
    if (status == 'ABSENT') return 'ABSENT';
    if (status == 'RETARD' || status == 'LATE') return 'RETARD';

    return 'UNKNOWN';
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
              'Présences',
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
          onRefresh: _loadAttendance,
          child: Builder(
            builder: (context) {
              if (state.isLoading && child == null) {
                return const _AttendanceSkeleton();
              }

              if (state.errorMessage != null && child == null) {
                return _AttendanceStateCard(
                  icon: Icons.wifi_off_rounded,
                  title: 'Impossible de charger les présences',
                  message: 'Veuillez vérifier votre connexion puis réessayer.',
                  actionLabel: 'Réessayer',
                  onAction: _loadAttendance,
                );
              }

              if (child == null) {
                return const _AttendanceStateCard(
                  icon: Icons.event_busy_outlined,
                  title: 'Données indisponibles',
                  message:
                      'Nous n’avons pas pu récupérer les présences pour le moment.',
                );
              }

              final filteredAttendance = _filteredAttendance(child.attendance);
              final groupedAttendance = _groupAttendance(filteredAttendance);

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                children: [
                  _AttendanceHeader(child: child),

                  const SizedBox(height: AppSpacing.lg),

                  _AttendanceSummary(attendance: child.attendance),

                  const SizedBox(height: AppSpacing.lg),

                  _AttendanceFilters(
                    selectedFilter: _selectedFilter,
                    newestFirst: _newestFirst,
                    onFilterChanged: (value) {
                      setState(() {
                        _selectedFilter = value;
                      });
                    },
                    onSortChanged: () {
                      setState(() {
                        _newestFirst = !_newestFirst;
                      });
                    },
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Text(
                    'Historique des présences',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.black,
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  Text(
                    'Filtrez les présences par statut pour retrouver rapidement une information.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.darkGrey,
                      height: 1.35,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  if (child.attendance.isEmpty)
                    const _AttendanceStateCard(
                      icon: Icons.event_available_outlined,
                      title: 'Aucune présence enregistrée',
                      message:
                          'Les présences apparaîtront ici dès qu’elles seront ajoutées.',
                    )
                  else if (filteredAttendance.isEmpty)
                    const _AttendanceStateCard(
                      icon: Icons.search_off_rounded,
                      title: 'Aucun résultat',
                      message:
                          'Aucune présence ne correspond au filtre sélectionné.',
                    )
                  else
                    ...groupedAttendance.map(
                      (group) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                              top: AppSpacing.sm,
                            ),
                            child: Text(
                              group.title,
                              style: AppTextStyles.titleSmall.copyWith(
                                color: AppColors.primaryRed,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),

                          ...group.items.map(
                            (attendance) =>
                                _AttendanceCard(attendance: attendance),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AttendanceHeader extends StatelessWidget {
  final ChildProfileEntity child;

  const _AttendanceHeader({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.black, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  ChildDisplayFormatter.formatMatricule(child.matricule),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

class _AttendanceSummary extends StatelessWidget {
  final List<ChildAttendanceEntity> attendance;

  const _AttendanceSummary({required this.attendance});

  int get presentCount => attendance
      .where((item) => _normalizeStatus(item.status) == 'PRESENT')
      .length;

  int get absentCount => attendance
      .where((item) => _normalizeStatus(item.status) == 'ABSENT')
      .length;

  int get lateCount => attendance
      .where((item) => _normalizeStatus(item.status) == 'RETARD')
      .length;

  double get presenceRate {
    if (attendance.isEmpty) return 0;
    return (presentCount / attendance.length) * 100;
  }

  static String _normalizeStatus(String value) {
    final status = value.trim().toUpperCase();

    if (status == 'PRESENT' || status == 'PRÉSENT') return 'PRESENT';
    if (status == 'ABSENT') return 'ABSENT';
    if (status == 'RETARD' || status == 'LATE') return 'RETARD';

    return 'UNKNOWN';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.black, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Résumé présence',
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.black,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _SummaryBox(
                  label: 'Taux',
                  value: '${presenceRate.toStringAsFixed(0)}%',
                  color: AppColors.success,
                  icon: Icons.verified_user_outlined,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _SummaryBox(
                  label: 'Présent',
                  value: '$presentCount',
                  color: AppColors.success,
                  icon: Icons.check_circle_outline_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _SummaryBox(
                  label: 'Absent',
                  value: '$absentCount',
                  color: AppColors.primaryRed,
                  icon: Icons.cancel_outlined,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _SummaryBox(
                  label: 'Retard',
                  value: '$lateCount',
                  color: AppColors.warning,
                  icon: Icons.schedule_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AttendanceFilters extends StatelessWidget {
  final String selectedFilter;
  final bool newestFirst;
  final ValueChanged<String> onFilterChanged;
  final VoidCallback onSortChanged;

  const _AttendanceFilters({
    required this.selectedFilter,
    required this.newestFirst,
    required this.onFilterChanged,
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
            'Filtrer rapidement',
            style: AppTextStyles.bodyBold.copyWith(color: AppColors.black),
          ),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChipButton(
                  label: 'Toutes',
                  value: 'ALL',
                  selectedValue: selectedFilter,
                  color: AppColors.black,
                  onTap: onFilterChanged,
                ),
                _FilterChipButton(
                  label: 'Présents',
                  value: 'PRESENT',
                  selectedValue: selectedFilter,
                  color: AppColors.success,
                  onTap: onFilterChanged,
                ),
                _FilterChipButton(
                  label: 'Absents',
                  value: 'ABSENT',
                  selectedValue: selectedFilter,
                  color: AppColors.primaryRed,
                  onTap: onFilterChanged,
                ),
                _FilterChipButton(
                  label: 'Retards',
                  value: 'RETARD',
                  selectedValue: selectedFilter,
                  color: AppColors.warning,
                  onTap: onFilterChanged,
                ),
              ],
            ),
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
                    newestFirst ? 'Plus récent d’abord' : 'Plus ancien d’abord',
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

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: InkWell(
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
      ),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final ChildAttendanceEntity attendance;

  const _AttendanceCard({required this.attendance});

  String get _statusLabel {
    switch (_normalizedStatus) {
      case 'PRESENT':
        return 'Présent';
      case 'ABSENT':
        return 'Absent';
      case 'RETARD':
        return 'Retard';
      default:
        return 'Statut non renseigné';
    }
  }

  String get _normalizedStatus {
    final status = attendance.status.trim().toUpperCase();

    if (status == 'PRESENT' || status == 'PRÉSENT') return 'PRESENT';
    if (status == 'ABSENT') return 'ABSENT';
    if (status == 'RETARD' || status == 'LATE') return 'RETARD';

    return 'UNKNOWN';
  }

  Color get _statusColor {
    switch (_normalizedStatus) {
      case 'PRESENT':
        return AppColors.success;
      case 'ABSENT':
        return AppColors.primaryRed;
      case 'RETARD':
        return AppColors.warning;
      default:
        return AppColors.grey;
    }
  }

  IconData get _statusIcon {
    switch (_normalizedStatus) {
      case 'PRESENT':
        return Icons.check_circle_outline_rounded;
      case 'ABSENT':
        return Icons.cancel_outlined;
      case 'RETARD':
        return Icons.schedule_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String get _dateText {
    final raw = attendance.date?.trim();

    if (raw == null || raw.isEmpty) {
      return 'Date indisponible';
    }

    final parsed = DateTime.tryParse(raw);

    if (parsed == null) {
      return raw;
    }

    final day = parsed.day.toString().padLeft(2, '0');
    final month = parsed.month.toString().padLeft(2, '0');
    final year = parsed.year.toString();

    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.black.withValues(alpha: 0.75),
          width: 1.1,
        ),
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
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: _statusColor, width: 1.1),
            ),
            child: Icon(_statusIcon, color: _statusColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _dateText,
                  style: AppTextStyles.bodyBold.copyWith(
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Présence enregistrée',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              _statusLabel,
              style: AppTextStyles.caption.copyWith(
                color: _statusColor,
                fontWeight: FontWeight.w900,
              ),
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
  final Color color;
  final IconData icon;

  const _SummaryBox({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withValues(alpha: 0.65)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTextStyles.bodyBold.copyWith(
              color: AppColors.black,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.darkGrey,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceStateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _AttendanceStateCard({
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

class _AttendanceSkeleton extends StatelessWidget {
  const _AttendanceSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: const [
        _SkeletonBox(height: 120),
        SizedBox(height: AppSpacing.lg),
        _SkeletonBox(height: 190),
        SizedBox(height: AppSpacing.lg),
        _SkeletonBox(height: 76),
        SizedBox(height: AppSpacing.md),
        _SkeletonBox(height: 76),
        SizedBox(height: AppSpacing.md),
        _SkeletonBox(height: 76),
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
