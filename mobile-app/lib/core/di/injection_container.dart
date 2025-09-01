import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../storage/local_storage_service.dart';
import '../utils/network_info.dart';

/// Dependency injection container
final GetIt sl = GetIt.instance;

/// Initialize dependencies (alias for initializeDependencies)
Future<void> init() async {
  await initializeDependencies();
}

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // Initialize Hive
  await Hive.initFlutter();

  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    ),
  );

  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // Core services
  sl.registerLazySingleton<LocalStorageService>(() => LocalStorageService());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfo(sl()));

  // Initialize storage service
  await sl<LocalStorageService>().init();
}

/// Clean up dependencies
Future<void> disposeDependencies() async {
  await Hive.close();
  await sl.reset();
}