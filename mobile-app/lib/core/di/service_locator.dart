import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../network/dio_client.dart';
import '../network/auth_interceptor.dart';
import '../events/auth_event_bus.dart';
import '../network/network_info.dart';
import '../services/hive_service.dart';
import '../storage/secure_token_storage.dart';
import '../../features/authentication/data/datasources/auth_local_datasource.dart';
import '../../features/authentication/data/datasources/auth_remote_datasource.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/domain/usecases/get_current_user_usecase.dart';
import '../../features/authentication/domain/usecases/login_usecase.dart';
import '../../features/authentication/domain/usecases/logout_usecase.dart';
import '../../features/authentication/domain/usecases/register_usecase.dart';
import '../../features/authentication/domain/usecases/refresh_token_usecase.dart';
import '../../features/authentication/presentation/bloc/auth_bloc.dart';

// Exam feature imports
import '../../features/exams/data/datasources/exam_local_datasource.dart';
import '../../features/exams/data/datasources/exam_remote_datasource.dart';
import '../../features/exams/data/repositories/exam_repository_impl.dart';
import '../../features/exams/domain/repositories/exam_repository.dart';
import '../../features/exams/domain/usecases/get_exams_usecase.dart';
import '../../features/exams/domain/usecases/get_exam_detail_usecase.dart';
import '../../features/exams/domain/usecases/get_categories_usecase.dart';
import '../../features/exams/domain/usecases/get_featured_exams_usecase.dart';
import '../../features/exams/domain/usecases/get_recent_exams_usecase.dart';
import '../../features/exams/domain/usecases/get_popular_exams_usecase.dart';
import '../../features/exams/domain/usecases/search_exams_usecase.dart';
import '../../features/exams/presentation/bloc/exam_bloc.dart';

// Search feature imports
import '../../features/search/data/datasources/search_local_datasource.dart';
import '../../features/search/data/datasources/search_remote_datasource.dart';
import '../../features/search/data/repositories/search_repository_impl.dart';
import '../../features/search/domain/repositories/search_repository.dart';
import '../../features/search/domain/usecases/search_exams_usecase.dart';
import '../../features/search/domain/usecases/get_search_suggestions_usecase.dart';
import '../../features/search/domain/usecases/manage_search_history_usecase.dart';
import '../../features/search/presentation/bloc/search_bloc.dart';

// Pagination utilities
import '../utils/pagination_controller.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External dependencies
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    ),
  );

  // Initialize Hive and register box
  final hiveService = HiveService();
  await hiveService.init();
  sl.registerLazySingleton<HiveService>(() => hiveService);
  sl.registerLazySingleton<Box<dynamic>>(() => hiveService.appBox);

  // Core services
  sl.registerLazySingleton<SecureTokenStorage>(
    () => SecureTokenStorage(),
  );
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );
  sl.registerLazySingleton<AuthEventBus>(
    () => AuthEventBus(),
  );

  // Register DioClient first without interceptor
  sl.registerLazySingleton<DioClient>(
    () => DioClient(),
  );

  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      tokenStorage: sl<SecureTokenStorage>(),
      hiveBox: sl<Box<dynamic>>(),
    ),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );

  // Authentication repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Register AuthInterceptor and add it to DioClient
  sl.registerLazySingleton<AuthInterceptor>(
    () {
      final interceptor = AuthInterceptor(
        tokenStorage: sl<SecureTokenStorage>(),
        authLocalDataSource: sl<AuthLocalDataSource>(),
        authRepository: sl<AuthRepository>(),
        eventBus: sl<AuthEventBus>(),
      );
      // Add interceptor to DioClient and set dio instance
      sl<DioClient>().dio.interceptors.add(interceptor);
      interceptor.setDio(sl<DioClient>().dio);
      return interceptor;
    },
  );

  // Authentication use cases
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<RefreshTokenUseCase>(
    () => RefreshTokenUseCase(sl<AuthRepository>()),
  );

  // Authentication BLoC
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      refreshTokenUseCase: sl<RefreshTokenUseCase>(),
      authRepository: sl<AuthRepository>(),
      eventBus: sl<AuthEventBus>(),
    ),
  );

  // Exam data sources
  sl.registerLazySingleton<ExamLocalDataSource>(
    () => ExamLocalDataSourceImpl(
      hiveBox: sl<Box<dynamic>>(),
    ),
  );
  sl.registerLazySingleton<ExamRemoteDataSource>(
    () => ExamRemoteDataSourceImpl(
      dio: sl<DioClient>().dio,
    ),
  );

  // Exam repository
  sl.registerLazySingleton<ExamRepository>(
    () => ExamRepositoryImpl(
      remoteDataSource: sl<ExamRemoteDataSource>(),
      localDataSource: sl<ExamLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Search data sources
  sl.registerLazySingleton<SearchLocalDataSource>(
    () => SearchLocalDataSourceImpl(
      hiveBox: sl<Box<dynamic>>(),
    ),
  );
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(
      dio: sl<DioClient>().dio,
    ),
  );

  // Search repository
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(
      remoteDataSource: sl<SearchRemoteDataSource>(),
      localDataSource: sl<SearchLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Exam use cases
  sl.registerLazySingleton<GetExamsUseCase>(
    () => GetExamsUseCase(sl<ExamRepository>()),
  );
  sl.registerLazySingleton<GetExamDetailUseCase>(
    () => GetExamDetailUseCase(sl<ExamRepository>()),
  );
  sl.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(sl<ExamRepository>()),
  );
  sl.registerLazySingleton<GetFeaturedExamsUseCase>(
    () => GetFeaturedExamsUseCase(sl<ExamRepository>()),
  );
  sl.registerLazySingleton<GetRecentExamsUseCase>(
    () => GetRecentExamsUseCase(sl<ExamRepository>()),
  );
  sl.registerLazySingleton<GetPopularExamsUseCase>(
    () => GetPopularExamsUseCase(sl<ExamRepository>()),
  );

  // Search use cases
  sl.registerLazySingleton<SearchExamsUseCase>(
    () => SearchExamsUseCase(
      examRepository: sl<ExamRepository>(),
      searchRepository: sl<SearchRepository>(),
    ),
  );
  sl.registerLazySingleton<GetSearchSuggestionsUseCase>(
    () => GetSearchSuggestionsUseCase(sl<SearchRepository>()),
  );
  sl.registerLazySingleton<ManageSearchHistoryUseCase>(
    () => ManageSearchHistoryUseCase(sl<SearchRepository>()),
  );
  sl.registerLazySingleton<GetSearchHistoryUseCase>(
    () => GetSearchHistoryUseCase(sl<SearchRepository>()),
  );
  sl.registerLazySingleton<ClearSearchHistoryUseCase>(
    () => ClearSearchHistoryUseCase(sl<SearchRepository>()),
  );
  sl.registerLazySingleton<RemoveSearchHistoryUseCase>(
    () => RemoveSearchHistoryUseCase(sl<SearchRepository>()),
  );

  // Pagination controller
  sl.registerFactory<PaginationController>(
    () => PaginationController(),
  );

  // Exam BLoC
  sl.registerFactory<ExamBloc>(
    () => ExamBloc(
      getExamsUseCase: sl<GetExamsUseCase>(),
      getExamDetailUseCase: sl<GetExamDetailUseCase>(),
      getCategoriesUseCase: sl<GetCategoriesUseCase>(),
      getFeaturedExamsUseCase: sl<GetFeaturedExamsUseCase>(),
      getRecentExamsUseCase: sl<GetRecentExamsUseCase>(),
      getPopularExamsUseCase: sl<GetPopularExamsUseCase>(),
      searchExamsUseCase: sl<SearchExamsUseCase>(),
      paginationController: sl<PaginationController>(),
    ),
  );

  // Search BLoC
  sl.registerFactory<SearchBloc>(
    () => SearchBloc(
      getSearchSuggestionsUseCase: sl<GetSearchSuggestionsUseCase>(),
      manageSearchHistoryUseCase: sl<ManageSearchHistoryUseCase>(),
      getSearchHistoryUseCase: sl<GetSearchHistoryUseCase>(),
      clearSearchHistoryUseCase: sl<ClearSearchHistoryUseCase>(),
      removeSearchHistoryUseCase: sl<RemoveSearchHistoryUseCase>(),
    ),
  );
}

/// Clean up resources when the app is disposed
Future<void> disposeDependencies() async {
  await sl.reset();
}