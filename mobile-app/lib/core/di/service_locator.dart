import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../network/dio_client.dart';
import '../network/auth_interceptor.dart';
import '../events/auth_event_bus.dart';
import '../network/network_info.dart';
import '../storage/hive_service.dart';
import '../services/firebase_service.dart';
import '../storage/secure_token_storage.dart';
import '../../features/authentication/data/datasources/auth_local_datasource.dart';
import '../../features/authentication/data/datasources/auth_remote_datasource.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/domain/usecases/login_usecase.dart';
import '../../features/authentication/domain/usecases/register_usecase.dart';
import '../../features/authentication/domain/usecases/logout_usecase.dart';
import '../../features/authentication/domain/usecases/get_current_user_usecase.dart';
import '../../features/authentication/domain/usecases/refresh_token_usecase.dart';
import '../../features/authentication/domain/usecases/request_password_reset_usecase.dart';
import '../../features/authentication/presentation/bloc/auth_bloc.dart';

// Exam feature imports
import '../../features/exams/data/datasources/exam_local_datasource.dart';
import '../../features/exams/data/datasources/exam_remote_datasource.dart';
import '../../features/exams/data/repositories/exam_repository_impl.dart';
import '../../features/exams/domain/repositories/exam_repository.dart';
import '../../features/exams/domain/usecases/get_exams_usecase.dart';
import '../../features/exams/domain/usecases/get_exam_detail_usecase.dart';
import '../../features/exams/domain/usecases/get_categories_usecase.dart';

import '../../features/search/domain/usecases/search_exams_usecase.dart';
import '../../features/exams/presentation/bloc/exam_bloc.dart';

// Search feature imports
import '../../features/search/data/datasources/search_local_datasource.dart';
import '../../features/search/data/datasources/search_remote_datasource.dart';
import '../../features/search/data/repositories/search_repository_impl.dart';
import '../../features/search/domain/repositories/search_repository.dart';
import '../../features/search/domain/usecases/get_search_suggestions_usecase.dart';
import '../../features/search/domain/usecases/manage_search_history_usecase.dart';
import '../../features/exams/presentation/bloc/search_bloc.dart' as exam_search_bloc;



// Exam Session feature imports
import '../../features/exam_session/data/datasources/exam_session_local_datasource.dart';
import '../../features/exam_session/data/datasources/exam_session_remote_datasource.dart';
import '../../features/exam_session/data/repositories/exam_session_repository_impl.dart';
import '../../features/exam_session/domain/repositories/exam_session_repository.dart';
import '../../features/exam_session/domain/usecases/start_exam_session_usecase.dart';
import '../../features/exam_session/domain/usecases/get_exam_session_usecase.dart';
import '../../features/exam_session/domain/usecases/submit_answer_usecase.dart';
import '../../features/exam_session/domain/usecases/submit_exam_usecase.dart';
import '../../features/exam_session/domain/usecases/update_exam_session_usecase.dart';
import '../../features/exam_session/domain/usecases/abandon_exam_session_usecase.dart';
import '../../features/exam_session/presentation/bloc/exam_session_bloc.dart';

// Settings feature imports
import '../../features/settings/data/datasources/settings_local_datasource.dart';
import '../../features/settings/data/datasources/settings_remote_datasource.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_user_settings_usecase.dart';
import '../../features/settings/domain/usecases/update_user_settings_usecase.dart';
// Removed advanced settings use cases
import '../../features/settings/domain/usecases/get_available_themes_usecase.dart';
import '../../features/settings/domain/usecases/get_available_languages_usecase.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../features/settings/presentation/bloc/theme_bloc.dart';



// Profile feature imports
import '../../features/profile/data/datasources/profile_local_datasource.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_user_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_user_profile_usecase.dart';
import '../../features/profile/domain/usecases/upload_avatar_usecase.dart';
// Removed advanced profile use cases
import '../../features/profile/presentation/bloc/profile_bloc.dart';

// Pagination utilities
import '../utils/pagination_utils.dart';

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
    () => SecureTokenStorage(storage: sl<FlutterSecureStorage>()),
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
  sl.registerLazySingleton<RequestPasswordResetUseCase>(
    () => RequestPasswordResetUseCase(sl<AuthRepository>()),
  );

  // Authentication BLoC
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      refreshTokenUseCase: sl<RefreshTokenUseCase>(),
      requestPasswordResetUseCase: sl<RequestPasswordResetUseCase>(),
      authRepository: sl<AuthRepository>(),
      eventBus: sl<AuthEventBus>(),
    ),
  );

  // Exam data sources
  sl.registerSingletonAsync<ExamLocalDataSource>(
    () async {
      final dataSource = ExamLocalDataSourceImpl();
      await dataSource.init();
      return dataSource;
    },
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
  sl.registerSingletonAsync<SearchLocalDataSource>(
    () async {
      final dataSource = SearchLocalDataSourceImpl();
      await dataSource.init();
      return dataSource;
    },
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

  sl.registerLazySingleton<SearchExamsUseCase>(() => SearchExamsUseCase(
    examRepository: sl<ExamRepository>(),
    searchRepository: sl<SearchRepository>(),
  ));
  // Search use cases (used by exam search functionality)
  sl.registerLazySingleton<GetSearchSuggestionsUseCase>(
    () => GetSearchSuggestionsUseCase(repository: sl<SearchRepository>()),
  );
  sl.registerLazySingleton<ManageSearchHistoryUseCase>(
    () => ManageSearchHistoryUseCase(repository: sl<SearchRepository>()),
  );

  // Exam Search BLoC
  sl.registerFactory<exam_search_bloc.SearchBloc>(
    () => exam_search_bloc.SearchBloc(
      getSearchSuggestionsUseCase: sl<GetSearchSuggestionsUseCase>(),
      manageSearchHistoryUseCase: sl<ManageSearchHistoryUseCase>(),
    ),
  );

  // Pagination utilities
  sl.registerFactory<PaginationController>(
    () => PaginationController(),
  );

  // Exam BLoC
  sl.registerFactory<ExamBloc>(
    () => ExamBloc(
      getExamsUseCase: sl<GetExamsUseCase>(),
      getExamDetailUseCase: sl<GetExamDetailUseCase>(),
      getCategoriesUseCase: sl<GetCategoriesUseCase>(),
      searchExamsUseCase: sl<SearchExamsUseCase>(),
    ),
  );

  // Removed unused search BLoC registration - search functionality is handled by exam-specific search

  // Firebase service
  sl.registerLazySingleton<FirebaseService>(() => FirebaseService.instance);

  // Exam Session data sources
  sl.registerLazySingleton<ExamSessionLocalDataSource>(
    () => ExamSessionLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<ExamSessionRemoteDataSource>(
    () => ExamSessionRemoteDataSourceImpl(
      dio: sl<DioClient>().dio,
    ),
  );

  // Exam Session repository
  sl.registerLazySingleton<ExamSessionRepository>(
    () => ExamSessionRepositoryImpl(
      remoteDataSource: sl<ExamSessionRemoteDataSource>(),
      localDataSource: sl<ExamSessionLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Exam Session use cases
  sl.registerLazySingleton<StartExamSessionUseCase>(
    () => StartExamSessionUseCase(sl<ExamSessionRepository>()),
  );
  sl.registerLazySingleton<GetExamSessionUseCase>(
    () => GetExamSessionUseCase(sl<ExamSessionRepository>()),
  );
  sl.registerLazySingleton<SubmitAnswerUseCase>(
    () => SubmitAnswerUseCase(sl<ExamSessionRepository>()),
  );
  sl.registerLazySingleton<SubmitExamUseCase>(
    () => SubmitExamUseCase(sl<ExamSessionRepository>()),
  );
  sl.registerLazySingleton<UpdateExamSessionUseCase>(
    () => UpdateExamSessionUseCase(sl<ExamSessionRepository>()),
  );
  sl.registerLazySingleton<AbandonExamSessionUseCase>(
    () => AbandonExamSessionUseCase(sl<ExamSessionRepository>()),
  );

  // Exam Session BLoC
  sl.registerFactory<ExamSessionBloc>(
    () => ExamSessionBloc(
      startExamSessionUseCase: sl<StartExamSessionUseCase>(),
      getExamSessionUseCase: sl<GetExamSessionUseCase>(),
      submitAnswerUseCase: sl<SubmitAnswerUseCase>(),
      submitExamUseCase: sl<SubmitExamUseCase>(),
      updateExamSessionUseCase: sl<UpdateExamSessionUseCase>(),
      abandonExamSessionUseCase: sl<AbandonExamSessionUseCase>(),
    ),
  );

  // Settings data sources
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(
      hiveBox: sl<HiveService>().appBox,
    ),
  );
  sl.registerLazySingleton<SettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(
      dio: sl<DioClient>().dio,
    ),
  );

  // Settings repository
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      remoteDataSource: sl<SettingsRemoteDataSource>(),
      localDataSource: sl<SettingsLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Settings use cases
  sl.registerLazySingleton<GetUserSettingsUseCase>(
    () => GetUserSettingsUseCase(sl<SettingsRepository>()),
  );
  sl.registerLazySingleton<UpdateUserSettingsUseCase>(
    () => UpdateUserSettingsUseCase(sl<SettingsRepository>()),
  );
  sl.registerLazySingleton<GetAvailableThemesUseCase>(
    () => GetAvailableThemesUseCase(sl<SettingsRepository>()),
  );
  // Removed advanced settings use cases registrations
  sl.registerLazySingleton<GetAvailableLanguagesUseCase>(
    () => GetAvailableLanguagesUseCase(sl<SettingsRepository>()),
  );

  // Settings BLoC
  sl.registerFactory<SettingsBloc>(
    () => SettingsBloc(
      getUserSettingsUseCase: sl<GetUserSettingsUseCase>(),
      updateUserSettingsUseCase: sl<UpdateUserSettingsUseCase>(),
      getAvailableThemesUseCase: sl<GetAvailableThemesUseCase>(),
      getAvailableLanguagesUseCase: sl<GetAvailableLanguagesUseCase>(),
    ),
  );

  // Theme BLoC
  sl.registerFactory<ThemeBloc>(
    () => ThemeBloc(
      getAvailableThemesUseCase: sl<GetAvailableThemesUseCase>(),
    ),
  );



  // Profile data sources
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(
      hiveBox: sl<HiveService>().appBox,
    ),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      dio: sl<DioClient>().dio,
    ),
  );

  // Profile repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl<ProfileRemoteDataSource>(),
      localDataSource: sl<ProfileLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Profile use cases
  sl.registerLazySingleton<GetUserProfileUseCase>(
    () => GetUserProfileUseCase(sl<ProfileRepository>()),
  );
  sl.registerLazySingleton<UpdateUserProfileUseCase>(
    () => UpdateUserProfileUseCase(sl<ProfileRepository>()),
  );
  sl.registerLazySingleton<UploadAvatarUseCase>(
    () => UploadAvatarUseCase(sl<ProfileRepository>()),
  );
  // Removed advanced profile use cases registrations

  // Profile BLoC
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getUserProfileUseCase: sl<GetUserProfileUseCase>(),
      updateUserProfileUseCase: sl<UpdateUserProfileUseCase>(),
      uploadAvatarUseCase: sl<UploadAvatarUseCase>(),
    ),
  );



  // Wait for all async registrations to complete
  await sl.allReady();
}

/// Clean up resources when the app is disposed
Future<void> disposeDependencies() async {
  await sl.reset();
}