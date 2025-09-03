import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../../features/authentication/presentation/bloc/auth_state.dart' as states;
import '../../features/authentication/presentation/bloc/auth_event.dart' as events;
import 'app_router.dart';

/// Service for handling route protection and authentication checks
class RouteGuard {
  /// List of routes that don't require authentication
  static const List<String> _publicRoutes = [
    '/splash',
    '/login',
    '/register',
    '/forgot-password',
  ];

  /// List of routes that require authentication
  static const List<String> _protectedRoutes = [
    AppRouter.exams,
    AppRouter.profile,
    AppRouter.settings,
  ];

  /// Check if a route requires authentication
  static bool requiresAuthentication(String path) {
    // Check if it's explicitly a public route
    if (_publicRoutes.any((route) => path.startsWith(route))) {
      return false;
    }
    
    // Check if it's explicitly a protected route
    if (_protectedRoutes.any((route) => path.startsWith(route))) {
      return true;
    }
    
    // Default to requiring authentication for unknown routes
    return true;
  }

  /// Check if user can access a specific route
  static bool canAccess(String path, states.AuthState authState) {
    final requiresAuth = requiresAuthentication(path);
    
    // Public routes are always accessible
    if (!requiresAuth) {
      return true;
    }
    
    // Protected routes require authentication
    return authState is states.AuthAuthenticated;
  }

  /// Get the appropriate redirect path based on authentication state
  static String? getRedirectPath(String currentPath, states.AuthState authState) {
    final isPublicRoute = !requiresAuthentication(currentPath);
    final isAuthenticated = authState is states.AuthAuthenticated;
    final isLoading = authState is states.AuthLoading || authState is states.AuthInitial;
    final isTokenRefreshing = authState is states.AuthTokenRefreshLoading;
    final isSessionExpired = authState is states.AuthSessionExpired;
    
    // Don't redirect during loading states
    if (isLoading || isTokenRefreshing) {
      return null;
    }
    
    // Handle session expiration
    if (isSessionExpired) {
      return '/login';
    }
    
    // Redirect unauthenticated users from protected routes
    if (!isAuthenticated && !isPublicRoute && currentPath != '/splash') {
      return '/login';
    }
    
    // Additional validation for profile routes - check for valid userId
    if (isAuthenticated && currentPath.startsWith(AppRouter.profile)) {
      final authenticatedState = authState as states.AuthAuthenticated;
      if (authenticatedState.user.id.isEmpty) {
        return '/login';
      }
    }
    
    // Redirect authenticated users from auth routes to exams
    if (isAuthenticated && isPublicRoute && currentPath != '/splash') {
      return AppRouter.exams;
    }
    
    return null;
  }

  /// Handle unauthorized access attempts
  static void handleUnauthorizedAccess(BuildContext context, String attemptedPath) {
    final authBloc = context.read<AuthBloc>();
    
    // Check if session might be expired
    final currentState = authBloc.state;
    if (currentState is states.AuthAuthenticated) {
      // Try to refresh token first
      authBloc.add(const events.AuthTokenRefreshRequested());
    } else {
      // Clear any existing auth state and redirect to login
      authBloc.add(const events.AuthSessionExpired());
    }
  }



  /// Get user-friendly route names for logging/debugging
  static String getRouteName(String path) {
    final routeNames = {
      AppRouter.splash: 'Splash',
      AppRouter.login: 'Login',
      AppRouter.register: 'Register',
      AppRouter.forgotPassword: 'Forgot Password',
      AppRouter.sessionExpired: 'Session Expired',

      AppRouter.exams: 'Exams',
      AppRouter.profile: 'Profile',
      AppRouter.settings: 'Settings',
      AppRouter.examDetail: 'Exam Detail',
      AppRouter.examTaking: 'Taking Exam',
  
      AppRouter.editProfile: 'Edit Profile',
    };
    
    for (final entry in routeNames.entries) {
      if (path.startsWith(entry.key)) {
        return entry.value;
      }
    }
    
    return 'Unknown Route';
  }

  /// Validate route parameters for security
  static bool validateRouteParams(String path, Map<String, String> params) {
    // Add validation logic for route parameters
    // For example, validate exam IDs, user IDs, etc.
    
    if (path.contains('/exams/') && params.containsKey('examId')) {
      final examId = params['examId'];
      // Validate exam ID format (e.g., must be numeric or UUID)
      if (examId == null || examId.isEmpty) {
        return false;
      }
    }
    
    return true;
  }

  /// Check if route supports deep linking
  static bool supportsDeepLinking(String path) {
    const deepLinkableRoutes = [
      AppRouter.exams,
      AppRouter.profile,
    ];
    
    return deepLinkableRoutes.any((route) => path.startsWith(route));
  }
}