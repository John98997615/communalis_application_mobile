import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/register_parent_screen.dart';
import '../../features/auth/presentation/screens/role_redirect_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import 'route_names.dart';
import 'package:flutter/material.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.registerParent,
        builder: (context, state) => const RegisterParentScreen(),
      ),
      GoRoute(
        path: RouteNames.otp,
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: RouteNames.roleRedirect,
        builder: (context, state) => const RoleRedirectScreen(),
      ),
      GoRoute(
        path: RouteNames.adminDashboard,
        builder: (context, state) => const _TempScreen(
          title: 'Dashboard Admin',
          message: 'Espace Administrateur',
        ),
      ),
      GoRoute(
        path: RouteNames.parentDashboard,
        builder: (context, state) => const _TempScreen(
          title: 'Dashboard Parent',
          message: 'Espace Parent',
        ),
      ),
    ],
  );
});

class _TempScreen extends StatelessWidget {
  final String title;
  final String message;

  const _TempScreen({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}