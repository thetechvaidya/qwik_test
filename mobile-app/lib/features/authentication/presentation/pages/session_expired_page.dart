import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../core/router/app_router.dart';

class SessionExpiredPage extends StatelessWidget {
  const SessionExpiredPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.access_time_filled,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: 32),
              Text(
                'Session Expired',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Your session has expired for security reasons. Please log in again to continue using the app.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              CustomButton(
                text: 'Login Again',
                onPressed: () {
                  context.go(AppRouter.login);
                },
                variant: ButtonVariant.filled,
                size: ButtonSize.large,
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}