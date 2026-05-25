import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/register_parent_screen.dart';
import '../../features/auth/presentation/screens/role_redirect_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/liaisons/presentation/screens/children_gallery_screen.dart';
import '../../features/liaisons/presentation/screens/parent_waiting_validation_screen.dart';
import '../../features/parent_dashboard/presentation/screens/parent_dashboard_screen.dart';
import '../../features/child_profile/presentation/screens/child_profile_screen.dart';
import '../../features/messaging/presentation/screens/child_chat_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/home/presentation/screens/home_choice_screen.dart';
import 'route_names.dart';

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
        path: RouteNames.homeChoice,
        builder: (context, state) => const HomeChoiceScreen(),
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
        builder: (context, state) => const ParentDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.parentWaitingValidation,
        builder: (context, state) => const ParentWaitingValidationScreen(),
      ),
      GoRoute(
        path: RouteNames.childrenGallery,
        builder: (context, state) => const ChildrenGalleryScreen(),
      ),
      GoRoute(
        path: RouteNames.childProfile,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;

          return ChildProfileScreen(childId: id);
        },
      ),
      GoRoute(
        path: RouteNames.childChat,
        builder: (context, state) {
          final childId = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          final childName = state.uri.queryParameters['name'] ?? 'Enfant';

          return ChildChatScreen(childId: childId, childName: childName);
        },
      ),
      GoRoute(
        path: RouteNames.notifications,
        builder: (context, state) {
          return const NotificationsScreen();
        },
      ),
    ],
  );
});

class _TempScreen extends StatelessWidget {
  final String title;
  final String message;

  const _TempScreen({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(message, style: const TextStyle(fontSize: 22))),
    );
  }
}
