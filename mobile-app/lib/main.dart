import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'core/di/service_locator.dart' as di;
import 'core/services/firebase_service.dart';
import 'core/config/environment_config.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/authentication/presentation/bloc/auth_event.dart';
import 'features/settings/presentation/bloc/theme_bloc.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase based on environment
  await _initializeFirebase();

  // Initialize dependency injection
  await di.initializeDependencies();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const QwikTestApp());
}

class QwikTestApp extends StatelessWidget {
  const QwikTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
           create: (context) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
         ),
        BlocProvider<ThemeBloc>(
          create: (context) => di.sl<ThemeBloc>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            
            // Theme configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            
            // Router configuration
            routerConfig: AppRouter.getRouter(context),
            
            // Localization (will be added later)
            // localizationsDelegates: const [
            //   AppLocalizations.delegate,
            //   GlobalMaterialLocalizations.delegate,
            //   GlobalWidgetsLocalizations.delegate,
            //   GlobalCupertinoLocalizations.delegate,
            // ],
            // supportedLocales: const [
            //   Locale('en', 'US'),
            //   Locale('es', 'ES'),
            //   Locale('fr', 'FR'),
            // ],
          );
        },
      ),
    );
  }
}

/// Initialize Firebase based on environment configuration
Future<void> _initializeFirebase() async {
  try {
    // Always initialize Firebase core
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Only initialize Firebase services in production or when explicitly enabled
    if (EnvironmentConfig.isProduction || EnvironmentConfig.enableDebugLogging) {
      await FirebaseService.instance.initialize();
      
      if (EnvironmentConfig.enableDebugLogging) {
        debugPrint('Firebase services initialized for ${EnvironmentConfig.environmentName} environment');
      }
    } else {
      if (EnvironmentConfig.enableDebugLogging) {
        debugPrint('Firebase services skipped for ${EnvironmentConfig.environmentName} environment');
      }
    }
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    // Don't throw - app should continue to work without Firebase
  }
}
