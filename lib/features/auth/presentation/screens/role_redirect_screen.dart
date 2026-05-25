import 'package:communalis_application_mobile/features/liaisons/presentation/providers/child_gallery_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../shared/enums/liaison_status.dart';
import '../../../../../shared/enums/user_role.dart';
import '../providers/auth_provider.dart';

class RoleRedirectScreen extends ConsumerStatefulWidget {
  const RoleRedirectScreen({super.key});

  @override
  ConsumerState<RoleRedirectScreen> createState() => _RoleRedirectScreenState();
}

class _RoleRedirectScreenState extends ConsumerState<RoleRedirectScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    final authState = ref.read(authProvider);

    if (!authState.isAuthenticated) {
      context.go(RouteNames.login);
      return;
    }

    if (authState.role == UserRole.admin) {
      context.go(RouteNames.adminDashboard);
      return;
    }

    if (authState.role == UserRole.parent) {
      await _redirectParent();
      return;
    }

    context.go(RouteNames.login);
  }

  Future<void> _redirectParent() async {
    try {
      final status = await ref.read(getMyLiaisonStatusUsecaseProvider)();

      if (!mounted) return;

      switch (status) {
        case LiaisonStatus.approved:
          context.go(RouteNames.homeChoice);
          break;

        case LiaisonStatus.pending:
          context.go(RouteNames.parentWaitingValidation);
          break;

        case LiaisonStatus.none:
        case LiaisonStatus.rejected:
        case LiaisonStatus.unknown:
          context.go(RouteNames.childrenGallery);
          break;
      }
    } catch (_) {
      if (!mounted) return;

      // Sécurité : si le statut est impossible à récupérer,
      // on envoie le parent vers le trombinoscope.
      context.go(RouteNames.childrenGallery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
