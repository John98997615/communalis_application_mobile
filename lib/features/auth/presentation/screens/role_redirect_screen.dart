import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../shared/enums/user_role.dart';
import '../providers/auth_provider.dart';

class RoleRedirectScreen extends ConsumerStatefulWidget {
  const RoleRedirectScreen({super.key});

  @override
  ConsumerState<RoleRedirectScreen> createState() =>
      _RoleRedirectScreenState();
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
      context.go(RouteNames.parentDashboard);
      return;
    }

    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}