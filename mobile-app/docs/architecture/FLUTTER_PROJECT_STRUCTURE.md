# QwikTest Mobile App - Flutter Project Structure

## 1. Overview

This document defines the comprehensive Flutter project structure for the QwikTest mobile application, implementing Clean Architecture principles with a feature-first approach. The structure promotes maintainability, scalability, and testability while ensuring clear separation of concerns.

### 1.1 Architecture Principles

- **Clean Architecture**: Clear separation between presentation, domain, and data layers
- **Feature-First**: Organize code by features rather than technical layers
- **Dependency Inversion**: High-level modules don't depend on low-level modules
- **Single Responsibility**: Each class/module has one reason to change
- **Testability**: Structure supports comprehensive testing at all levels

### 1.2 Project Structure Philosophy

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │    Pages    │  │   Widgets   │  │    State Mgmt       │ │
│  │    (UI)     │  │ (Components)│  │     (BLoC)          │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │  Entities   │  │  Use Cases  │  │   Repositories      │ │
│  │ (Business   │  │ (Business   │  │   (Interfaces)      │ │
│  │  Objects)   │  │   Logic)    │  │                     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │    Models   │  │ Data Sources│  │   Repositories      │ │
│  │ (DTOs/JSON) │  │(Remote/Local│  │ (Implementations)   │ │
│  │             │  │    Cache)   │  │                     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Root Project Structure

```
qwiktest_mobile/
├── android/                     # Android-specific configuration
├── ios/                         # iOS-specific configuration
├── lib/                         # Main Dart source code
├── test/                        # Unit and widget tests
├── integration_test/            # Integration tests
├── assets/                      # Static assets
│   ├── images/                 # Image assets
│   ├── icons/                  # Icon assets
│   ├── fonts/                  # Custom fonts
│   └── animations/             # Lottie animations
├── docs/                        # Project documentation
├── scripts/                     # Build and utility scripts
├── .github/                     # GitHub workflows
├── analysis_options.yaml        # Dart analyzer configuration
├── pubspec.yaml                # Dependencies and metadata
├── README.md                   # Project overview
└── CHANGELOG.md                # Version history
```

---

## 3. Lib Directory Structure

### 3.1 Complete Lib Structure

```
lib/
├── main.dart                    # Application entry point
├── app.dart                     # App widget configuration
├── core/                        # Core functionality
│   ├── constants/              # Application constants
│   │   ├── app_constants.dart
│   │   ├── api_constants.dart
│   │   ├── storage_constants.dart
│   │   └── route_constants.dart
│   ├── errors/                 # Error handling
│   │   ├── exceptions.dart
│   │   ├── failures.dart
│   │   └── error_handler.dart
│   ├── network/                # Network configuration
│   │   ├── dio_client.dart
│   │   ├── interceptors/
│   │   │   ├── auth_interceptor.dart
│   │   │   ├── cache_interceptor.dart
│   │   │   ├── error_interceptor.dart
│   │   │   └── logging_interceptor.dart
│   │   └── network_info.dart
│   ├── storage/                # Local storage
│   │   ├── secure_storage.dart
│   │   ├── cache_manager.dart
│   │   └── database/
│   │       ├── app_database.dart
│   │       ├── daos/
│   │       └── entities/
│   ├── theme/                  # App theming
│   │   ├── app_theme.dart
│   │   ├── colors.dart
│   │   ├── text_styles.dart
│   │   └── dimensions.dart
│   ├── utils/                  # Utility functions
│   │   ├── date_utils.dart
│   │   ├── validation_utils.dart
│   │   ├── format_utils.dart
│   │   ├── device_utils.dart
│   │   └── extensions/
│   │       ├── string_extensions.dart
│   │       ├── datetime_extensions.dart
│   │       └── context_extensions.dart
│   ├── widgets/                # Reusable core widgets
│   │   ├── buttons/
│   │   │   ├── primary_button.dart
│   │   │   ├── secondary_button.dart
│   │   │   └── icon_button.dart
│   │   ├── inputs/
│   │   │   ├── text_field.dart
│   │   │   ├── search_field.dart
│   │   │   └── dropdown_field.dart
│   │   ├── loading/
│   │   │   ├── loading_indicator.dart
│   │   │   ├── shimmer_loading.dart
│   │   │   └── skeleton_loader.dart
│   │   ├── dialogs/
│   │   │   ├── confirmation_dialog.dart
│   │   │   ├── error_dialog.dart
│   │   │   └── info_dialog.dart
│   │   └── layout/
│   │       ├── app_bar.dart
│   │       ├── bottom_nav.dart
│   │       └── drawer.dart
│   ├── services/               # Core services
│   │   ├── analytics_service.dart
│   │   ├── crash_reporting_service.dart
│   │   └── notification_service.dart
│   └── dependency_injection/    # DI configuration
│       ├── injection_container.dart
│       └── service_locator.dart
├── features/                    # Feature modules
│   ├── authentication/         # Authentication feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   └── auth_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── user_model.dart
│   │   │   │   ├── login_request_model.dart
│   │   │   │   └── auth_response_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── user.dart
│   │   │   │   └── auth_token.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       ├── logout_usecase.dart
│   │   │       ├── register_usecase.dart
│   │   │       ├── forgot_password_usecase.dart
│   │   │       └── get_current_user_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   ├── register_page.dart
│   │       │   ├── forgot_password_page.dart
│   │       │   └── profile_setup_page.dart
│   │       └── widgets/
│   │           ├── login_form.dart
│   │           ├── register_form.dart
│   │           └── social_login_buttons.dart
│   ├── dashboard/              # Dashboard feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── dashboard_remote_datasource.dart
│   │   │   │   └── dashboard_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── dashboard_model.dart
│   │   │   │   ├── user_stats_model.dart
│   │   │   │   └── activity_model.dart
│   │   │   └── repositories/
│   │   │       └── dashboard_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── dashboard.dart
│   │   │   │   ├── user_stats.dart
│   │   │   │   └── activity.dart
│   │   │   ├── repositories/
│   │   │   │   └── dashboard_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_dashboard_data_usecase.dart
│   │   │       └── refresh_dashboard_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── dashboard_bloc.dart
│   │       │   ├── dashboard_event.dart
│   │       │   └── dashboard_state.dart
│   │       ├── pages/
│   │       │   └── dashboard_page.dart
│   │       └── widgets/
│   │           ├── stats_card.dart
│   │           ├── activity_list.dart
│   │           ├── recommended_exams.dart
│   │           └── achievement_progress.dart
│   ├── exams/                  # Exams feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── exam_remote_datasource.dart
│   │   │   │   └── exam_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── exam_model.dart
│   │   │   │   ├── question_model.dart
│   │   │   │   ├── answer_model.dart
│   │   │   │   └── exam_result_model.dart
│   │   │   └── repositories/
│   │   │       └── exam_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── exam.dart
│   │   │   │   ├── question.dart
│   │   │   │   ├── answer.dart
│   │   │   │   ├── exam_session.dart
│   │   │   │   └── exam_result.dart
│   │   │   ├── repositories/
│   │   │   │   └── exam_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_exams_usecase.dart
│   │   │       ├── get_exam_details_usecase.dart
│   │   │       ├── start_exam_usecase.dart
│   │   │       ├── submit_answer_usecase.dart
│   │   │       ├── submit_exam_usecase.dart
│   │   │       └── get_exam_results_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── exam_list/
│   │       │   │   ├── exam_list_bloc.dart
│   │       │   │   ├── exam_list_event.dart
│   │       │   │   └── exam_list_state.dart
│   │       │   ├── exam_session/
│   │       │   │   ├── exam_session_bloc.dart
│   │       │   │   ├── exam_session_event.dart
│   │       │   │   └── exam_session_state.dart
│   │       │   └── exam_results/
│   │       │       ├── exam_results_bloc.dart
│   │       │       ├── exam_results_event.dart
│   │       │       └── exam_results_state.dart
│   │       ├── pages/
│   │       │   ├── exam_list_page.dart
│   │       │   ├── exam_details_page.dart
│   │       │   ├── exam_session_page.dart
│   │       │   └── exam_results_page.dart
│   │       └── widgets/
│   │           ├── exam_card.dart
│   │           ├── exam_filter.dart
│   │           ├── question_widget.dart
│   │           ├── answer_option.dart
│   │           ├── exam_timer.dart
│   │           ├── progress_indicator.dart
│   │           └── results_summary.dart
│   ├── categories/             # Categories feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── profile/                # User profile feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── search/                 # Search feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── settings/               # Settings feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── notifications/          # Notifications feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── offline/                # Offline functionality
│       ├── data/
│       ├── domain/
│       └── presentation/
├── shared/                     # Shared components across features
│   ├── data/
│   │   ├── datasources/
│   │   │   └── base_remote_datasource.dart
│   │   ├── models/
│   │   │   ├── paginated_response.dart
│   │   │   └── api_response.dart
│   │   └── repositories/
│   │       └── base_repository.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── base_entity.dart
│   │   │   └── pagination.dart
│   │   ├── repositories/
│   │   │   └── base_repository.dart
│   │   └── usecases/
│   │       ├── base_usecase.dart
│   │       └── no_params.dart
│   └── presentation/
│       ├── bloc/
│       │   ├── base_bloc.dart
│       │   └── pagination_bloc.dart
│       └── widgets/
│           ├── paginated_list.dart
│           ├── empty_state.dart
│           ├── error_state.dart
│           └── network_image.dart
└── routes/                     # Navigation and routing
    ├── app_router.dart
    ├── route_generator.dart
    └── route_names.dart
```

---

## 4. Feature Structure Deep Dive

### 4.1 Authentication Feature Structure

```
features/authentication/
├── data/
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart     # API calls
│   │   └── auth_local_datasource.dart      # Local storage
│   ├── models/
│   │   ├── user_model.dart                 # User JSON model
│   │   ├── login_request_model.dart        # Login request DTO
│   │   ├── register_request_model.dart     # Register request DTO
│   │   └── auth_response_model.dart        # Auth response DTO
│   └── repositories/
│       └── auth_repository_impl.dart       # Repository implementation
├── domain/
│   ├── entities/
│   │   ├── user.dart                       # User business object
│   │   └── auth_token.dart                 # Token business object
│   ├── repositories/
│   │   └── auth_repository.dart            # Repository interface
│   └── usecases/
│       ├── login_usecase.dart              # Login business logic
│       ├── logout_usecase.dart             # Logout business logic
│       ├── register_usecase.dart           # Registration logic
│       ├── forgot_password_usecase.dart    # Password reset logic
│       └── get_current_user_usecase.dart   # Get user logic
└── presentation/
    ├── bloc/
    │   ├── auth_bloc.dart                  # State management
    │   ├── auth_event.dart                 # Events
    │   └── auth_state.dart                 # States
    ├── pages/
    │   ├── login_page.dart                 # Login screen
    │   ├── register_page.dart              # Registration screen
    │   ├── forgot_password_page.dart       # Password reset screen
    │   └── profile_setup_page.dart         # Profile setup screen
    └── widgets/
        ├── login_form.dart                 # Login form widget
        ├── register_form.dart              # Registration form widget
        └── social_login_buttons.dart       # Social login options
```

### 4.2 Data Layer Implementation

#### 4.2.1 Remote Data Source

```dart
// features/authentication/data/datasources/auth_remote_datasource.dart
abstract class AuthRemoteDataSource {
  Future<UserModel> login(LoginRequestModel request);
  Future<UserModel> register(RegisterRequestModel request);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
  Future<void> forgotPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  
  AuthRemoteDataSourceImpl({required Dio dio}) : _dio = dio;
  
  @override
  Future<UserModel> login(LoginRequestModel request) async {
    final response = await _dio.post(
      '/auth/login',
      data: request.toJson(),
    );
    
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data['data']['user']);
    } else {
      throw ServerException(response.statusCode!);
    }
  }
  
  // Other method implementations...
}
```

#### 4.2.2 Local Data Source

```dart
// features/authentication/data/datasources/auth_local_datasource.dart
abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> deleteToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  final Box _hiveBox;
  
  AuthLocalDataSourceImpl({
    required FlutterSecureStorage secureStorage,
    required Box hiveBox,
  }) : _secureStorage = secureStorage,
       _hiveBox = hiveBox;
  
  @override
  Future<UserModel?> getCachedUser() async {
    final userData = _hiveBox.get('cached_user');
    if (userData != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(userData));
    }
    return null;
  }
  
  @override
  Future<void> cacheUser(UserModel user) async {
    await _hiveBox.put('cached_user', user.toJson());
  }
  
  @override
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }
  
  @override
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }
  
  // Other method implementations...
}
```

#### 4.2.3 Repository Implementation

```dart
// features/authentication/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;
  
  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final request = LoginRequestModel(
          email: email,
          password: password,
        );
        
        final userModel = await _remoteDataSource.login(request);
        await _localDataSource.cacheUser(userModel);
        
        return Right(userModel.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  // Other method implementations...
}
```

### 4.3 Domain Layer Implementation

#### 4.3.1 Entity

```dart
// features/authentication/domain/entities/user.dart
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final DateTime createdAt;
  final UserSubscription? subscription;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.createdAt,
    this.subscription,
  });
  
  @override
  List<Object?> get props => [
    id,
    name,
    email,
    avatar,
    createdAt,
    subscription,
  ];
}

class UserSubscription extends Equatable {
  final String status;
  final String plan;
  final DateTime? expiresAt;
  final bool autoRenew;
  
  const UserSubscription({
    required this.status,
    required this.plan,
    this.expiresAt,
    required this.autoRenew,
  });
  
  @override
  List<Object?> get props => [status, plan, expiresAt, autoRenew];
}
```

#### 4.3.2 Repository Interface

```dart
// features/authentication/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });
  
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  });
  
  Future<Either<Failure, void>> logout();
  
  Future<Either<Failure, User>> getCurrentUser();
  
  Future<Either<Failure, void>> forgotPassword(String email);
}
```

#### 4.3.3 Use Case

```dart
// features/authentication/domain/usecases/login_usecase.dart
class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository _repository;
  
  LoginUseCase(this._repository);
  
  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await _repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;
  
  const LoginParams({
    required this.email,
    required this.password,
  });
  
  @override
  List<Object> get props => [email, password];
}
```

### 4.4 Presentation Layer Implementation

#### 4.4.1 BLoC State Management

```dart
// features/authentication/presentation/bloc/auth_bloc.dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  
  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }
  
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    final result = await _loginUseCase(LoginParams(
      email: event.email,
      password: event.password,
    ));
    
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }
  
  // Other event handlers...
}
```

#### 4.4.2 Page Implementation

```dart
// features/authentication/presentation/pages/login_page.dart
class LoginPage extends StatelessWidget {
  static const String routeName = '/login';
  
  const LoginPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        elevation: 0,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacementNamed(
              DashboardPage.routeName,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  _buildLogo(),
                  const SizedBox(height: 48),
                  const LoginForm(),
                  const SizedBox(height: 24),
                  _buildSocialLogin(),
                  const Spacer(),
                  _buildSignUpLink(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildLogo() {
    return const Column(
      children: [
        Icon(
          Icons.quiz,
          size: 80,
          color: AppColors.primary,
        ),
        SizedBox(height: 16),
        Text(
          'QwikTest',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
  
  Widget _buildSocialLogin() {
    return const Column(
      children: [
        Text(
          'Or continue with',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 16),
        SocialLoginButtons(),
      ],
    );
  }
  
  Widget _buildSignUpLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(RegisterPage.routeName);
          },
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
}
```

---

## 5. Core Directory Structure

### 5.1 Constants

```dart
// core/constants/app_constants.dart
class AppConstants {
  static const String appName = 'QwikTest';
  static const String appVersion = '1.0.0';
  static const int sessionTimeoutMinutes = 30;
  static const int maxOfflineExams = 10;
  static const int maxRetryAttempts = 3;
}

// core/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'https://api.qwiktest.com/api/mobile';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String examsEndpoint = '/exams';
  static const String dashboardEndpoint = '/dashboard';
  
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
}

// core/constants/storage_constants.dart
class StorageConstants {
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String settingsKey = 'app_settings';
  static const String cacheBoxName = 'app_cache';
  static const String offlineBoxName = 'offline_data';
}
```

### 5.2 Theme Configuration

```dart
// core/theme/app_theme.dart
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      textTheme: AppTextStyles.textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      textTheme: AppTextStyles.textTheme,
      // Dark theme specific configurations...
    );
  }
}

// core/theme/colors.dart
class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1F2937);
  
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF9CA3AF);
}
```

### 5.3 Dependency Injection

```dart
// core/dependency_injection/injection_container.dart
final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  
  const secureStorage = FlutterSecureStorage();
  getIt.registerLazySingleton(() => secureStorage);
  
  final hiveBox = await Hive.openBox('app_cache');
  getIt.registerLazySingleton(() => hiveBox);
  
  // Core services
  getIt.registerLazySingleton<Dio>(() => DioClient.createDio());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  
  // Authentication feature
  _initAuthFeature();
  
  // Dashboard feature
  _initDashboardFeature();
  
  // Exam feature
  _initExamFeature();
}

void _initAuthFeature() {
  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt()),
  );
  
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      secureStorage: getIt(),
      hiveBox: getIt(),
    ),
  );
  
  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  
  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));
  
  // BLoC
  getIt.registerFactory(
    () => AuthBloc(
      loginUseCase: getIt(),
      logoutUseCase: getIt(),
      getCurrentUserUseCase: getIt(),
    ),
  );
}
```

---

## 6. Testing Structure

### 6.1 Test Directory Organization

```
test/
├── features/
│   ├── authentication/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_datasource_test.dart
│   │   │   │   └── auth_local_datasource_test.dart
│   │   │   ├── models/
│   │   │   │   ├── user_model_test.dart
│   │   │   │   └── auth_response_model_test.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl_test.dart
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       ├── login_usecase_test.dart
│   │   │       └── logout_usecase_test.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   └── auth_bloc_test.dart
│   │       ├── pages/
│   │       │   └── login_page_test.dart
│   │       └── widgets/
│   │           └── login_form_test.dart
│   ├── dashboard/
│   └── exams/
├── core/
│   ├── network/
│   ├── utils/
│   └── widgets/
├── shared/
├── helpers/
│   ├── test_helper.dart
│   ├── mock_data.dart
│   └── pump_app.dart
└── fixtures/
    ├── user.json
    ├── exam.json
    └── dashboard.json
```

### 6.2 Test Helpers

```dart
// test/helpers/test_helper.dart
class TestHelper {
  static Widget createWidgetUnderTest({
    required Widget child,
    List<BlocProvider>? providers,
  }) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: providers ?? [],
        child: child,
      ),
    );
  }
  
  static Future<void> pumpAndSettle(
    WidgetTester tester,
    Widget widget,
  ) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }
}

// test/helpers/mock_data.dart
class MockData {
  static const userJson = {
    'id': '1',
    'name': 'Test User',
    'email': 'test@example.com',
    'avatar': 'https://example.com/avatar.jpg',
    'created_at': '2024-01-01T00:00:00Z',
  };
  
  static const examJson = {
    'id': 'exam-1',
    'title': 'Flutter Basics',
    'description': 'Test your Flutter knowledge',
    'duration': 60,
    'total_questions': 25,
  };
}
```

---

## 7. Build Configuration

### 7.1 Pubspec.yaml Structure

```yaml
name: qwiktest_mobile
description: A Flutter mobile application for online exam taking and learning.
version: 1.0.0+1

environment:
  sdk: '>=3.6.0 <4.0.0'
  flutter: ">=3.35.0"

dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.6
  bloc: ^8.1.4
  equatable: ^2.0.5

  # Dependency Injection
  get_it: ^8.0.2
  injectable: ^2.4.4

  # Navigation
  go_router: ^14.6.2

  # Network
  dio: ^5.7.0
  retrofit: ^4.4.1
  pretty_dio_logger: ^1.4.0
  connectivity_plus: ^5.0.2

  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_secure_storage: ^9.2.2
  shared_preferences: ^2.3.2

  # Database
  drift: ^2.21.0
  sqlite3_flutter_libs: ^0.5.24
  path_provider: ^2.1.4
  path: ^1.9.0

  # Code Generation
  freezed: ^2.5.7
  json_annotation: ^4.9.0

  # Firebase Services
  firebase_core: ^3.6.0
  firebase_messaging: ^15.1.3  # Push Notifications (FCM)
  firebase_analytics: ^11.3.3  # User Behavior Tracking
  firebase_crashlytics: ^4.1.3 # Error Monitoring
  firebase_performance: ^0.10.0+8 # Performance Monitoring
  flutter_local_notifications: ^17.2.3

  # UI Components
  cached_network_image: ^3.4.1
  shimmer: ^3.0.0
  lottie: ^3.1.2
  flutter_svg: ^2.0.14

  # Device Features
  device_info_plus: ^9.1.1
  package_info_plus: ^4.2.0
  local_auth: ^2.1.7

  # Utilities
  dartz: ^0.10.1
  intl: ^0.19.0
  uuid: ^4.5.1

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Code Generation
  build_runner: ^2.4.7
  injectable_generator: ^2.4.1
  retrofit_generator: ^8.0.4
  hive_generator: ^2.0.1
  drift_dev: ^2.21.0
  json_serializable: ^6.8.0
  freezed: ^2.5.7

  # Testing
  bloc_test: ^9.1.5
  mocktail: ^1.0.4

  # Linting
  flutter_lints: ^4.0.0
  very_good_analysis: ^6.0.0

  # App Configuration
  flutter_launcher_icons: ^0.14.1
  flutter_native_splash: ^2.4.1

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
    - assets/animations/
  
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
        - asset: assets/fonts/Inter-Medium.ttf
          weight: 500
        - asset: assets/fonts/Inter-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Inter-Bold.ttf
          weight: 700
```

### 7.2 Analysis Options

```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # Error rules
    avoid_empty_else: true
    avoid_relative_lib_imports: true
    avoid_returning_null_for_future: true
    avoid_slow_async_io: true
    avoid_types_as_parameter_names: true
    cancel_subscriptions: true
    close_sinks: true
    comment_references: true
    control_flow_in_finally: true
    empty_statements: true
    hash_and_equals: true
    invariant_booleans: true
    iterable_contains_unrelated_type: true
    list_remove_unrelated_type: true
    literal_only_boolean_expressions: true
    no_adjacent_strings_in_list: true
    no_duplicate_case_values: true
    prefer_void_to_null: true
    test_types_in_equals: true
    throw_in_finally: true
    unnecessary_statements: true
    unrelated_type_equality_checks: true
    use_key_in_widget_constructors: true
    valid_regexps: true
    
    # Style rules
    always_declare_return_types: true
    always_put_control_body_on_new_line: true
    always_put_required_named_parameters_first: true
    always_specify_types: false
    annotate_overrides: true
    avoid_annotating_with_dynamic: true
    avoid_bool_literals_in_conditional_expressions: true
    avoid_catches_without_on_clauses: true
    avoid_catching_errors: true
    avoid_double_and_int_checks: true
    avoid_field_initializers_in_const_classes: true
    avoid_function_literals_in_foreach_calls: true
    avoid_implementing_value_types: true
    avoid_init_to_null: true
    avoid_null_checks_in_equality_operators: true
    avoid_positional_boolean_parameters: true
    avoid_print: true
    avoid_private_typedef_functions: true
    avoid_redundant_argument_values: true
    avoid_renaming_method_parameters: true
    avoid_return_types_on_setters: true
    avoid_returning_null: true
    avoid_returning_null_for_void: true
    avoid_setters_without_getters: true
    avoid_shadowing_type_parameters: true
    avoid_single_cascade_in_expression_statements: true
    avoid_unnecessary_containers: true
    avoid_unused_constructor_parameters: true
    avoid_void_async: true
    await_only_futures: true
    camel_case_extensions: true
    camel_case_types: true
    cascade_invocations: true
    constant_identifier_names: true
    curly_braces_in_flow_control_structures: true
    directives_ordering: true
    empty_catches: true
    empty_constructor_bodies: true
    file_names: true
    implementation_imports: true
    join_return_with_assignment: true
    leading_newlines_in_multiline_strings: true
    library_names: true
    library_prefixes: true
    lines_longer_than_80_chars: true
    missing_whitespace_between_adjacent_strings: true
    no_runtimeType_toString: true
    non_constant_identifier_names: true
    null_closures: true
    omit_local_variable_types: true
    one_member_abstracts: true
    only_throw_errors: true
    overridden_fields: true
    package_api_docs: true
    package_prefixed_library_names: true
    parameter_assignments: true
    prefer_adjacent_string_concatenation: true
    prefer_asserts_in_initializer_lists: true
    prefer_collection_literals: true
    prefer_conditional_assignment: true
    prefer_const_constructors: true
    prefer_const_constructors_in_immutables: true
    prefer_const_declarations: true
    prefer_const_literals_to_create_immutables: true
    prefer_constructors_over_static_methods: true
    prefer_contains: true
    prefer_equal_for_default_values: true
    prefer_expression_function_bodies: true
    prefer_final_fields: true
    prefer_final_in_for_each: true
    prefer_final_locals: true
    prefer_for_elements_to_map_fromIterable: true
    prefer_foreach: true
    prefer_function_declarations_over_variables: true
    prefer_generic_function_type_aliases: true
    prefer_if_elements_to_conditional_expressions: true
    prefer_if_null_operators: true
    prefer_initializing_formals: true
    prefer_inlined_adds: true
    prefer_interpolation_to_compose_strings: true
    prefer_is_empty: true
    prefer_is_not_empty: true
    prefer_is_not_operator: true
    prefer_iterable_whereType: true
    prefer_mixin: true
    prefer_null_aware_operators: true
    prefer_relative_imports: true
    prefer_single_quotes: true
    prefer_spread_collections: true
    prefer_typing_uninitialized_variables: true
    provide_deprecation_message: true
    recursive_getters: true
    slash_for_doc_comments: true
    sort_child_properties_last: true
    sort_constructors_first: true
    sort_unnamed_constructors_first: true
    type_annotate_public_apis: true
    type_init_formals: true
    unawaited_futures: true
    unnecessary_await_in_return: true
    unnecessary_brace_in_string_interps: true
    unnecessary_const: true
    unnecessary_getters_setters: true
    unnecessary_lambdas: true
    unnecessary_new: true
    unnecessary_null_aware_assignments: true
    unnecessary_null_in_if_null_operators: true
    unnecessary_overrides: true
    unnecessary_parenthesis: true
    unnecessary_raw_strings: true
    unnecessary_string_escapes: true
    unnecessary_string_interpolations: true
    unnecessary_this: true
    use_full_hex_values_for_flutter_colors: true
    use_function_type_syntax_for_parameters: true
    use_rethrow_when_possible: true
    use_setters_to_change_properties: true
    use_string_buffers: true
    use_to_and_as_if_applicable: true
    void_checks: true

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.mocks.dart"
  
  errors:
    invalid_annotation_target: ignore
    missing_required_param: error
    missing_return: error
    todo: ignore
  
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
```

---

## 8. Implementation Guidelines

### 8.1 Development Workflow

1. **Feature Planning**
   - Define feature requirements
   - Create domain entities and use cases
   - Design API contracts
   - Plan UI/UX flow

2. **Implementation Order**
   - Domain layer (entities, repositories, use cases)
   - Data layer (models, data sources, repository implementations)
   - Presentation layer (BLoC, pages, widgets)
   - Tests (unit, widget, integration)

3. **Code Review Process**
   - Self-review before creating PR
   - Automated checks (linting, tests)
   - Peer review
   - QA testing
   - Merge to main

### 8.2 Best Practices

- **Naming Conventions**: Follow Dart naming conventions consistently
- **Documentation**: Document public APIs and complex business logic
- **Error Handling**: Implement comprehensive error handling at all layers
- **Testing**: Maintain high test coverage (>80%)
- **Performance**: Optimize for mobile constraints
- **Security**: Follow security best practices for mobile apps
- **Accessibility**: Ensure app is accessible to all users

### 8.3 Quality Assurance

- **Static Analysis**: Use dart analyze and custom linting rules
- **Unit Testing**: Test business logic and data transformations
- **Widget Testing**: Test UI components and user interactions
- **Integration Testing**: Test complete user flows
- **Performance Testing**: Monitor app performance and memory usage
- **Security Testing**: Validate security implementations

---

**Document Version**: 1.0  
**Last Updated**: January 2024  
**Next Review**: March 2024  
**Approved By**: Development Team