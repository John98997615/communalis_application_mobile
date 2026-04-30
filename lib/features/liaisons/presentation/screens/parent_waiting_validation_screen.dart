import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:communalis_application_mobile/app/router/route_names.dart';
import 'package:communalis_application_mobile/core/widgets/app_button.dart';
import 'package:communalis_application_mobile/core/widgets/status_badge.dart';

class ParentWaitingValidationScreen extends StatelessWidget {
  const ParentWaitingValidationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validation en attente'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.hourglass_top_rounded,
                size: 82,
                color: Colors.orange,
              ),
              const SizedBox(height: 20),
              const Text(
                'Demande en attente',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Votre demande a été envoyée',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Un administrateur doit valider l’association avec votre enfant. Vous pourrez accéder aux notes, présences, progression et commentaires après validation.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              AppButton(
                text: 'Revenir au trombinoscope',
                outlined: true,
                onPressed: () {
                  context.go(RouteNames.childrenGallery);
                },
              ),
              const SizedBox(height: 12),
              AppButton(
                text: 'Actualiser plus tard',
                onPressed: () {
                  context.go(RouteNames.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}