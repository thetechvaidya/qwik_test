import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

// Import authentication features
import '../../features/authentication/presentation/pages/splash_page.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/register_page.dart';
import '../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../../features/authentication/presentation/bloc/auth_state.dart' as states;
import '../../features/authentication/presentation/bloc/auth_event.dart' as events;
import 'route_guard.dart';
import 'go_router_refresh_stream.dart';

// Import navigation components
import '../../shared/navigation/navigation_scaffold.dart';
import '../../shared/navigation/navigation_destinations.dart';
// import '../../features/dashboard/presentation/pages/dashboard_page.dart';
// import '../../features/exam/presentation/pages/exam_list_page.dart';
// import '../../features/exam/presentation/pages/exam_detail_page.dart';
// import '../../features/exam/presentation/pages/exam_taking_page.dart';
// import '../../features/exam/presentation/pages/exam_result_page.dart';
// import '../../features/profile/presentation/pages/profile_page.dart';
// import '../../features/profile/presentation/pages/edit_profile_page.dart';
// import '../../features/settings/presentation/pages/settings_page.dart';

// Temporary placeholder pages
class PlaceholderPage extends StatelessWidget {
  final String title;
  
  const PlaceholderPage({Key? key, required this.title}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'This page is under construction',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// Shell widget that provides navigation structure for the main app
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  void _onDestinationSelected(BuildContext context, int index) {
    final route = NavigationDestinations.getRouteByIndex(index);
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    final idx = NavigationDestinations.getIndexByRoute(GoRouterState.of(context).uri.path);
    
    return NavigationScaffold(
      destinations: NavigationDestinations.mainDestinations,
      selectedIndex: idx,
      onDestinationSelected: (index) => _onDestinationSelected(context, index),
      body: child,
      useCollapsibleRail: true,
      navigationRailExtended: true,
    );
  }
}

class AppRouter {
  // Authentication routes
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  
  // Main app routes (matching NavigationDestinations)
  static const String home = '/home';
  static const String exams = '/exams';
  static const String practice = '/practice';
  static const String progress = '/progress';
  static const String profile = '/profile';
  
  // Secondary routes
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String help = '/help';
  static const String about = '/about';
  
  // Detailed routes
  static const String examDetail = '/exams/:examId';
  static const String examTaking = '/exams/:examId/take';
  static const String examResult = '/exams/:examId/result';
  static const String editProfile = '/profile/edit';
  
  // Legacy route for backward compatibility
  static const String dashboard = home;

  static GoRouter? _router;
  static GoRouterRefreshStream? _refreshStream;

  /// Get the router instance, creating it if necessary
  static GoRouter getRouter(BuildContext context) {
    if (_router == null) {
      final authBloc = context.read<AuthBloc>();
      _refreshStream = GoRouterRefreshStream(authBloc.stream);
      
      _router = GoRouter(
        initialLocation: splash,
        debugLogDiagnostics: true,
        refreshListenable: _refreshStream,
    routes: [
      // Splash route
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Authentication routes
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: forgotPassword,
        name: 'forgot-password',
        builder: (context, state) => const PlaceholderPage(title: 'Forgot Password'),
      ),

      // Shell route for main app navigation
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          // Main navigation routes
          GoRoute(
            path: home,
            name: 'home',
            builder: (context, state) => const PlaceholderPage(title: 'Home'),
          ),
          GoRoute(
            path: exams,
            name: 'exams',
            builder: (context, state) => const PlaceholderPage(title: 'Exams'),
            routes: [
              // Nested exam routes
              GoRoute(
                path: ':examId',
                name: 'exam-detail',
                builder: (context, state) {
                  final examId = state.pathParameters['examId']!;
                  return PlaceholderPage(title: 'Exam Detail - $examId');
                },
                routes: [
                  GoRoute(
                    path: 'take',
                    name: 'exam-taking',
                    builder: (context, state) {
                      final examId = state.pathParameters['examId']!;
                      return PlaceholderPage(title: 'Taking Exam - $examId');
                    },
                  ),
                  GoRoute(
                    path: 'result',
                    name: 'exam-result',
                    builder: (context, state) {
                      final examId = state.pathParameters['examId']!;
                      return PlaceholderPage(title: 'Exam Result - $examId');
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: practice,
            name: 'practice',
            builder: (context, state) => const PlaceholderPage(title: 'Practice'),
          ),
          GoRoute(
            path: progress,
            name: 'progress',
            builder: (context, state) => const PlaceholderPage(title: 'Progress'),
          ),
          GoRoute(
            path: profile,
            name: 'profile',
            builder: (context, state) => const PlaceholderPage(title: 'Profile'),
            routes: [
              GoRoute(
                path: 'edit',
                name: 'edit-profile',
                builder: (context, state) => const PlaceholderPage(title: 'Edit Profile'),
              ),
            ],
          ),
          GoRoute(
            path: settings,
            name: 'settings',
            builder: (context, state) => const PlaceholderPage(title: 'Settings'),
          ),
          GoRoute(
            path: notifications,
            name: 'notifications',
            builder: (context, state) => const PlaceholderPage(title: 'Notifications'),
          ),
          GoRoute(
            path: help,
            name: 'help',
            builder: (context, state) => const PlaceholderPage(title: 'Help'),
          ),
          GoRoute(
            path: about,
            name: 'about',
            builder: (context, state) => const PlaceholderPage(title: 'About'),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(home),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
    // Enhanced authentication redirect logic with comprehensive guards
    redirect: (context, state) {
      return _handleRouteRedirect(context, state);
    },
  );
    }
    return _router!;
  }

  static GoRouter router(BuildContext context) => getRouter(context);

  /// Enhanced route redirect handler with comprehensive authentication checks
  static String? _handleRouteRedirect(BuildContext context, GoRouterState state) {
    try {
      final authBloc = context.read<AuthBloc>();
      final authState = authBloc.state;
      final currentPath = state.uri.path;
      
      if (kDebugMode) {
        debugPrint('Route Guard: Checking access to ${RouteGuard.getRouteName(currentPath)} ($currentPath)');
        debugPrint('Auth State: ${authState.runtimeType}');
      }
      
      // Validate route parameters for security
      if (!RouteGuard.validateRouteParams(currentPath, state.pathParameters)) {
        if (kDebugMode) {
          debugPrint('Route Guard: Invalid route parameters for $currentPath');
        }
        return home;
      }
      
      // Handle different authentication states
      final redirectPath = _handleAuthenticationState(authState, currentPath, authBloc);
      
      if (redirectPath != null && kDebugMode) {
        debugPrint('Route Guard: Redirecting from $currentPath to $redirectPath');
      }
      
      return redirectPath;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Route Guard Error: $e');
      }
      // Fallback to login on any error
      return login;
    }
  }
  
  /// Handle authentication state and determine redirect path
  static String? _handleAuthenticationState(states.AuthState authState, String currentPath, AuthBloc authBloc) {
    // Handle session expiration
    if (authState is states.AuthSessionExpired) {
      return _handleSessionExpired(currentPath);
    }
    
    // Handle token refresh states
    if (authState is states.AuthTokenRefreshLoading || authState is states.AuthTokenRefreshFailed) {
      return _handleTokenRefreshState(authState, currentPath);
    }
    
    // Handle biometric authentication requirements
    if (authState is states.AuthBiometricAuthRequired) {
      return _handleBiometricAuthRequired(currentPath);
    }
    
    // Handle loading states - don't redirect during initial load
    if (authState is states.AuthInitial || authState is states.AuthLoading) {
      return null;
    }
    
    // Use RouteGuard for standard authentication checks
    return RouteGuard.getRedirectPath(currentPath, authState);
  }
  
  /// Handle session expiration scenarios
  static String? _handleSessionExpired(String currentPath) {
    if (kDebugMode) {
      debugPrint('Route Guard: Session expired, redirecting to login');
    }
    
    // Always redirect to login on session expiration
    return login;
  }
  
  /// Handle token refresh states
  static String? _handleTokenRefreshState(states.AuthState authState, String currentPath) {
    if (authState is states.AuthTokenRefreshFailed) {
      if (kDebugMode) {
        debugPrint('Route Guard: Token refresh failed, redirecting to login');
      }
      return login;
    }
    
    // Don't redirect during token refresh loading
    return null;
  }
  
  /// Handle biometric authentication requirements
  static String? _handleBiometricAuthRequired(String currentPath) {
    // Allow staying on current route during biometric auth
    // The UI should handle showing biometric prompt
    return null;
  }
  
  /// Check if route requires authentication
  static bool _isRouteProtected(String path) {
    return RouteGuard.requiresAuthentication(path);
  }
  
  /// Handle unauthorized access attempts
  static void _handleUnauthorizedAccess(BuildContext context, String attemptedPath) {
    RouteGuard.handleUnauthorizedAccess(context, attemptedPath);
  }

  // Helper methods for navigation
  static void goToLogin(BuildContext context) => context.go(login);
  static void goToRegister(BuildContext context) => context.go(register);
  static void goToHome(BuildContext context) => context.go(home);
  static void goToExams(BuildContext context) => context.go(exams);
  static void goToExamDetail(BuildContext context, String examId) => 
      context.go(examDetail.replaceAll(':examId', examId));
  static void goToExamTaking(BuildContext context, String examId) => 
      context.go(examTaking.replaceAll(':examId', examId));
  static void goToExamResult(BuildContext context, String examId) => 
      context.go(examResult.replaceAll(':examId', examId));
  static void goToProfile(BuildContext context) => context.go(profile);
  static void goToSettings(BuildContext context) => context.go(settings);

  // Push methods
  static void pushExamDetail(BuildContext context, String examId) => 
      context.push(examDetail.replaceAll(':examId', examId));
  static void pushExamTaking(BuildContext context, String examId) => 
      context.push(examTaking.replaceAll(':examId', examId));
  static void pushEditProfile(BuildContext context) => context.push(editProfile);
}