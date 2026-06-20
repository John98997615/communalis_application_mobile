import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_action_list.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_tile.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;
      ref.read(profileProvider.notifier).loadProfile();
    });
  }

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: const Text('Déconnexion'),
          content: const Text(
            'Voulez-vous vraiment vous déconnecter de votre compte Communalis ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Se déconnecter'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await ref.read(authProvider.notifier).logout();

    if (!context.mounted) return;

    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final profile = profileState.profile;

    final fullName = profile != null
        ? '${profile['firstName'] ?? ''} ${profile['lastName'] ?? ''}'.trim()
        : 'Parent Communalis';

    final email = profile?['email']?.toString().trim().isNotEmpty == true
        ? profile!['email'].toString()
        : 'Email non renseigné';

    final phone = profile?['phone']?.toString().trim().isNotEmpty == true
        ? profile!['phone'].toString()
        : 'Téléphone non renseigné';

    final avatarUrl = profile?['photoUrl']?.toString();

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
            const Text(
              'Mon profil',
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryRed,
          onRefresh: () {
            return ref.read(profileProvider.notifier).loadProfile();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              if (profileState.isLoading && profile == null)
                const Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryRed,
                    ),
                  ),
                )
              else ...[
                ProfileHeader(
                  fullName: fullName.isEmpty ? 'Parent Communalis' : fullName,
                  roleLabel: 'Compte parent',
                  avatarUrl: avatarUrl,
                ),

                const SizedBox(height: AppSpacing.lg),

                ProfileInfoTile(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: email,
                ),

                ProfileInfoTile(
                  icon: Icons.phone_outlined,
                  label: 'Téléphone',
                  value: phone,
                ),

                const SizedBox(height: AppSpacing.lg),

                ProfileActionList(
                  onEdit: () {
                    context.go(RouteNames.editProfile);
                  },
                  onSecurity: () {
                    context.go(RouteNames.securityAccount);
                  },
                  onLogout: () => _logout(context),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
