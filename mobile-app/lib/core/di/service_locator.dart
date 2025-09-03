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
import '../../features/exams/domain/usecases/get_featured_exams_usecase.dart';
import '../../features/exams/domain/usecases/get_recent_exams_usecase.dart';
import '../../features/exams/domain/usecases/get_popular_exams_usecase.dart';
import '../../features/exams/domain/usecases/search_exams_usecase.dart' as exam_search;
import '../../features/exams/presentation/bloc/exam_bloc.dart';

// Search feature imports
import '../../features/search/data/datasources/search_local_datasource.dart';
import '../../features/search/data/datasources/search_remote_datasource.dart';
import '../../features/search/data/repositories/search_repository_impl.dart';
import '../../features/search/domain/repositories/search_repository.dart';
import '../../features/search/domain/usecases/search_usecase.dart';
import '../../features/search/domain/usecases/search_exams_usecase.dart' as search_search;
import '../../features/search/domain/usecases/get_search_suggestions_usecase.dart';
import '../../features/search/domain/usecases/manage_search_history_usecase.dart';
import '../../features/search/domain/usecases/get_search_history_usecase.dart' as search_get_history;
import '../../features/search/domain/usecases/clear_search_history_usecase.dart' as search_clear_history;
import '../../features/search/domain/usecases/remove_search_history_usecase.dart' as search_remove_history;
import '../../features/search/domain/usecases/report_search_analytics_usecase.dart';
import '../../features/search/presentation/bloc/search_bloc.dart';

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
import '../../features/settings/domain/usecases/get_notification_settings_usecase.dart';
import '../../features/settings/domain/usecases/get_app_preferences_usecase.dart';
import '../../features/settings/domain/usecases/get_available_themes_usecase.dart';
import '../../features/settings/domain/usecases/get_available_languages_usecase.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../features/settings/presentation/bloc/theme_bloc.dart';

// Dashboard feature imports
import '../../features/dashboard/data/datasources/dashboard_local_datasource.dart';
import '../../features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_data.dart';
import '../../features/dashboard/domain/usecases/get_user_stats.dart';
import '../../features/dashboard/domain/usecases/get_achievements.dart';
import '../../features/dashboard/domain/usecases/get_recent_activities.dart';
import '../../features/dashboard/domain/usecases/get_performance_trends.dart';
import '../../features/dashboard/domain/usecases/update_achievement_progress.dart';
import '../../features/dashboard/domain/usecases/unlock_achievement.dart';
import '../../features/dashboard/domain/usecases/add_recent_activity.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';

// Profile feature imports
import '../../features/profile/data/datasources/profile_local_datasource.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_user_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_user_profile_usecase.dart';
import '../../features/profile/domain/usecases/upload_avatar_usecase.dart';
import '../../features/profile/domain/usecases/get_user_stats_usecase.dart';
import '../../features/profile/domain/usecases/get_subscription_info_usecase.dart';
import '../../features/profile/domain/usecases/search_users_usecase.dart';
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
  sl.registerLazySingletonAsync<ExamLocalDataSource>(
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
  sl.registerLazySingletonAsync<SearchLocalDataSource>(
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
  sl.registerLazySingleton<GetFeaturedExamsUseCase>(
    () => GetFeaturedExamsUseCase(sl<ExamRepository>()),
  );
  sl.registerLazySingleton<GetRecentExamsUseCase>(
    () => GetRecentExamsUseCase(sl<ExamRepository>()),
  );
  sl.registerLazySingleton<GetPopularExamsUseCase>(
    () => GetPopularExamsUseCase(sl<ExamRepository>()),
  );
  sl.registerLazySingleton<exam_search.SearchExamsUseCase>(
    () => exam_search.SearchExamsUseCase(sl<ExamRepository>()),
  );

  // Search use cases
  sl.registerLazySingleton<SearchUseCase>(
    () => SearchUseCase(
      searchRepository: sl<SearchRepository>(),
    ),
  );
  sl.registerLazySingleton<search_search.SearchExamsUseCase>(
    () => search_search.SearchExamsUseCase(
      examRepository: sl<ExamRepository>(),
      searchRepository: sl<SearchRepository>(),
    ),
  );
  sl.registerLazySingleton<GetSearchSuggestionsUseCase>(
    () => GetSearchSuggestionsUseCase(repository: sl<SearchRepository>()),
  );
  sl.registerLazySingleton<ManageSearchHistoryUseCase>(
    () => ManageSearchHistoryUseCase(repository: sl<SearchRepository>()),
  );
  sl.registerLazySingleton<search_get_history.GetSearchHistoryUseCase>(
    () => search_get_history.GetSearchHistoryUseCase(sl<SearchRepository>()),
  );
  sl.registerLazySingleton<search_clear_history.ClearSearchHistoryUseCase>(
    () => search_clear_history.ClearSearchHistoryUseCase(sl<SearchRepository>()),
  );
  sl.registerLazySingleton<search_remove_history.RemoveSearchHistoryUseCase>(
    () => search_remove_history.RemoveSearchHistoryUseCase(sl<SearchRepository>()),
  );
  sl.registerLazySingleton<ReportSearchAnalyticsUseCase>(
    () => ReportSearchAnalyticsUseCase(repository: sl<SearchRepository>()),
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
      getFeaturedExamsUseCase: sl<GetFeaturedExamsUseCase>(),
      getRecentExamsUseCase: sl<GetRecentExamsUseCase>(),
      getPopularExamsUseCase: sl<GetPopularExamsUseCase>(),
      searchExamsUseCase: sl<exam_search.SearchExamsUseCase>(),
    ),
  );

  // Search BLoC
  sl.registerFactory<SearchBloc>(
    () => SearchBloc(
      searchUseCase: sl<SearchUseCase>(),
      getSearchSuggestionsUseCase: sl<GetSearchSuggestionsUseCase>(),
      manageSearchHistoryUseCase: sl<ManageSearchHistoryUseCase>(),
    ),
  );

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
  sl.registerLazySingleton<GetNotificationSettingsUseCase>(
    () => GetNotificationSettingsUseCase(sl<SettingsRepository>()),
  );
  sl.registerLazySingleton<GetAppPreferencesUseCase>(
    () => GetAppPreferencesUseCase(sl<SettingsRepository>()),
  );
  sl.registerLazySingleton<GetAvailableThemesUseCase>(
    () => GetAvailableThemesUseCase(sl<SettingsRepository>()),
  );
  sl.registerLazySingleton<GetAvailableLanguagesUseCase>(
    () => GetAvailableLanguagesUseCase(sl<SettingsRepository>()),
  );

  // Settings BLoC
  sl.registerFactory<SettingsBloc>(
    () => SettingsBloc(
      getUserSettingsUseCase: sl<GetUserSettingsUseCase>(),
      updateUserSettingsUseCase: sl<UpdateUserSettingsUseCase>(),
      getNotificationSettingsUseCase: sl<GetNotificationSettingsUseCase>(),
      getAppPreferencesUseCase: sl<GetAppPreferencesUseCase>(),
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

  // Dashboard data sources
  sl.registerLazySingleton<DashboardLocalDataSource>(
    () => DashboardLocalDataSourceImpl(
      hiveBox: sl<HiveService>().appBox,
    ),
  );
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(
      dio: sl<DioClient>().dio,
      baseUrl: AppConstants.baseUrl,
    ),
  );

  // Dashboard repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: sl<DashboardRemoteDataSource>(),
      localDataSource: sl<DashboardLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Dashboard use cases
  sl.registerLazySingleton<GetDashboardData>(
    () => GetDashboardData(sl<DashboardRepository>()),
  );
  sl.registerLazySingleton<GetUserStats>(
    () => GetUserStats(sl<DashboardRepository>()),
  );
  sl.registerLazySingleton<GetAchievements>(
    () => GetAchievements(sl<DashboardRepository>()),
  );
  sl.registerLazySingleton<GetRecentActivities>(
    () => GetRecentActivities(sl<DashboardRepository>()),
  );
  sl.registerLazySingleton<GetPerformanceTrends>(
    () => GetPerformanceTrends(sl<DashboardRepository>()),
  );
  sl.registerLazySingleton<UpdateAchievementProgress>(
    () => UpdateAchievementProgress(sl<DashboardRepository>()),
  );
  sl.registerLazySingleton<UnlockAchievement>(
    () => UnlockAchievement(sl<DashboardRepository>()),
  );
  sl.registerLazySingleton<AddRecentActivity>(
    () => AddRecentActivity(sl<DashboardRepository>()),
  );

  // Dashboard BLoC
  sl.registerFactory<DashboardBloc>(
    () => DashboardBloc(
      getDashboardData: sl<GetDashboardData>(),
      getUserStats: sl<GetUserStats>(),
      getAchievements: sl<GetAchievements>(),
      getRecentActivities: sl<GetRecentActivities>(),
      getPerformanceTrends: sl<GetPerformanceTrends>(),
      updateAchievementProgress: sl<UpdateAchievementProgress>(),
      unlockAchievement: sl<UnlockAchievement>(),
      addRecentActivity: sl<AddRecentActivity>(),
      dashboardRepository: sl<DashboardRepository>(),
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
  sl.registerLazySingleton<GetUserStatsUseCase>(
    () => GetUserStatsUseCase(sl<ProfileRepository>()),
  );
  sl.registerLazySingleton<GetSubscriptionInfoUseCase>(
    () => GetSubscriptionInfoUseCase(sl<ProfileRepository>()),
  );
  sl.registerLazySingleton<SearchUsersUseCase>(
    () => SearchUsersUseCase(sl<ProfileRepository>()),
  );

  // Profile BLoC
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getUserProfileUseCase: sl<GetUserProfileUseCase>(),
      updateUserProfileUseCase: sl<UpdateUserProfileUseCase>(),
      uploadAvatarUseCase: sl<UploadAvatarUseCase>(),
      getUserStatsUseCase: sl<GetUserStatsUseCase>(),
      getSubscriptionInfoUseCase: sl<GetSubscriptionInfoUseCase>(),
      searchUsersUseCase: sl<SearchUsersUseCase>(),
    ),
  );

  // Results BLoC (placeholder - requires results dependencies)
  // TODO: Add results use cases and repository registrations
  // sl.registerFactory<ResultsBloc>(
  //   () => ResultsBloc(
  //     getExamResults: sl<GetExamResults>(),
  //     submitExamResult: sl<SubmitExamResult>(),
  //     getQuestionResults: sl<GetQuestionResults>(),
  //     getPerformanceAnalytics: sl<GetPerformanceAnalytics>(),
  //     getExamAnalysis: sl<GetExamAnalysis>(),
  //     getStudyRecommendations: sl<GetStudyRecommendations>(),
  //     resultsRepository: sl<ResultsRepository>(),
  //   ),
  // );

  // Wait for all async registrations to complete
  await sl.allReady();
}

/// Clean up resources when the app is disposed
Future<void> disposeDependencies() async {
  await sl.reset();
}