# QwikTest Mobile App - Technical Architecture Document

## 1. Architecture Overview

### 1.1 Architecture Philosophy
The QwikTest mobile app follows **Clean Architecture** principles combined with **Feature-First** organization to ensure:
- **Separation of Concerns**: Clear boundaries between business logic, data, and presentation layers
- **Testability**: Easy unit and integration testing
- **Maintainability**: Scalable and maintainable codebase
- **Platform Independence**: Business logic independent of Flutter framework
- **Dependency Inversion**: High-level modules don't depend on low-level modules

### 1.2 Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Widgets   │  │   Screens   │  │   State Management  │ │
│  │   (UI)      │  │   (Pages)   │  │   (BLoC/Cubit)      │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │  Entities   │  │ Use Cases   │  │   Repositories      │ │
│  │  (Models)   │  │ (Business   │  │   (Interfaces)      │ │
│  │             │  │  Logic)     │  │                     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ Repository  │  │ Data Sources│  │   External APIs     │ │
│  │Implementations│ │(Local/Remote│  │   (REST/GraphQL)    │ │
│  │             │  │  Storage)   │  │                     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Technology Stack

### 2.1 Core Technologies
- **Framework**: Flutter 3.35+
- **Language**: Dart 3.6+
- **State Management**: BLoC Pattern with flutter_bloc
- **Dependency Injection**: get_it + injectable
- **Routing**: go_router
- **Local Storage**: Hive + SQLite (drift)
- **Network**: Dio with interceptors
- **Code Generation**: build_runner, json_annotation

### 2.2 Key Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.6
  bloc: ^8.1.4
  
  # Dependency Injection
  get_it: ^8.0.2
  injectable: ^2.4.4
  
  # Routing
  go_router: ^14.6.2
  
  # Network
  dio: ^5.7.0
  retrofit: ^4.4.1
  pretty_dio_logger: ^1.4.0
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  drift: ^2.21.0
  sqlite3_flutter_libs: ^0.5.24
  
  # Utilities
  freezed: ^2.5.7
  json_annotation: ^4.9.0
  equatable: ^2.0.5
  dartz: ^0.10.1
  
  # Firebase Integration (Specific Features Only)
  firebase_core: ^3.6.0
  firebase_messaging: ^15.1.3  # Push Notifications (FCM)
  firebase_analytics: ^11.3.3  # User Behavior Tracking
  firebase_crashlytics: ^4.1.3 # Error Monitoring
  firebase_performance: ^0.10.0+8 # Performance Monitoring
  
  # UI/UX
  cached_network_image: ^3.4.1
  shimmer: ^3.0.0
  lottie: ^3.1.2
  flutter_svg: ^2.0.14
  
  # Device Features
  connectivity_plus: ^5.0.2
  device_info_plus: ^9.1.1
  package_info_plus: ^4.2.0
  local_auth: ^2.1.7
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  build_runner: ^2.4.7
  injectable_generator: ^2.4.1
  retrofit_generator: ^8.0.4
  hive_generator: ^2.0.1
  drift_dev: ^2.13.2
  json_serializable: ^6.7.1
  freezed: ^2.4.6
  
  # Testing
  bloc_test: ^9.1.5
  mocktail: ^1.0.1
  integration_test:
    sdk: flutter
  
  # Analysis
  flutter_lints: ^3.0.1
  very_good_analysis: ^5.1.0
```

---

## 3. Project Structure

### 3.1 Feature-First Organization

```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   └── theme/
│       ├── app_theme.dart
│       ├── colors.dart
│       └── typography.dart
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   ├── app_constants.dart
│   │   └── storage_keys.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   ├── api_client.dart
│   │   ├── network_info.dart
│   │   └── interceptors/
│   ├── storage/
│   │   ├── local_storage.dart
│   │   └── secure_storage.dart
│   ├── utils/
│   │   ├── extensions/
│   │   ├── helpers/
│   │   └── validators/
│   └── di/
│       ├── injection.dart
│       └── injection.config.dart
├── shared/
│   ├── widgets/
│   │   ├── buttons/
│   │   ├── inputs/
│   │   ├── loading/
│   │   └── common/
│   ├── models/
│   │   ├── api_response.dart
│   │   └── pagination.dart
│   └── mixins/
│       ├── validation_mixin.dart
│       └── loading_mixin.dart
└── features/
    ├── authentication/
    │   ├── data/
    │   │   ├── datasources/
    │   │   ├── models/
    │   │   └── repositories/
    │   ├── domain/
    │   │   ├── entities/
    │   │   ├── repositories/
    │   │   └── usecases/
    │   └── presentation/
    │       ├── bloc/
    │       ├── pages/
    │       └── widgets/
    ├── dashboard/
    ├── exams/
    ├── profile/
    ├── settings/
    └── offline/
```

### 3.2 Feature Structure Template

Each feature follows this consistent structure:

```
feature_name/
├── data/
│   ├── datasources/
│   │   ├── feature_local_datasource.dart
│   │   └── feature_remote_datasource.dart
│   ├── models/
│   │   ├── feature_model.dart
│   │   └── feature_model.g.dart
│   └── repositories/
│       └── feature_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── feature_entity.dart
│   ├── repositories/
│   │   └── feature_repository.dart
│   └── usecases/
│       ├── get_feature_usecase.dart
│       └── update_feature_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── feature_bloc.dart
    │   ├── feature_event.dart
    │   └── feature_state.dart
    ├── pages/
    │   ├── feature_page.dart
    │   └── feature_detail_page.dart
    └── widgets/
        ├── feature_card.dart
        └── feature_list.dart
```

---

## 4. State Management Architecture

### 4.1 BLoC Pattern Implementation

```dart
// Event
abstract class ExamEvent extends Equatable {
  const ExamEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadExams extends ExamEvent {
  const LoadExams({this.categoryId});
  
  final String? categoryId;
  
  @override
  List<Object?> get props => [categoryId];
}

// State
abstract class ExamState extends Equatable {
  const ExamState();
  
  @override
  List<Object?> get props => [];
}

class ExamInitial extends ExamState {}

class ExamLoading extends ExamState {}

class ExamLoaded extends ExamState {
  const ExamLoaded(this.exams);
  
  final List<Exam> exams;
  
  @override
  List<Object?> get props => [exams];
}

class ExamError extends ExamState {
  const ExamError(this.message);
  
  final String message;
  
  @override
  List<Object?> get props => [message];
}

// BLoC
class ExamBloc extends Bloc<ExamEvent, ExamState> {
  ExamBloc({
    required GetExamsUseCase getExamsUseCase,
  }) : _getExamsUseCase = getExamsUseCase,
       super(ExamInitial()) {
    on<LoadExams>(_onLoadExams);
  }
  
  final GetExamsUseCase _getExamsUseCase;
  
  Future<void> _onLoadExams(
    LoadExams event,
    Emitter<ExamState> emit,
  ) async {
    emit(ExamLoading());
    
    final result = await _getExamsUseCase(
      GetExamsParams(categoryId: event.categoryId),
    );
    
    result.fold(
      (failure) => emit(ExamError(failure.message)),
      (exams) => emit(ExamLoaded(exams)),
    );
  }
}
```

### 4.2 State Management Best Practices

1. **Single Responsibility**: Each BLoC handles one feature
2. **Immutable States**: All states are immutable using Equatable
3. **Event-Driven**: UI triggers events, BLoC processes them
4. **Error Handling**: Consistent error state management
5. **Loading States**: Clear loading indicators for better UX

---

## 5. Data Layer Architecture

### 5.1 Repository Pattern

```dart
// Domain Repository Interface
abstract class ExamRepository {
  Future<Either<Failure, List<Exam>>> getExams({
    String? categoryId,
    int page = 1,
  });
  
  Future<Either<Failure, Exam>> getExamById(String id);
  
  Future<Either<Failure, void>> cacheExam(Exam exam);
}

// Data Repository Implementation
class ExamRepositoryImpl implements ExamRepository {
  ExamRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  
  final ExamRemoteDataSource remoteDataSource;
  final ExamLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  @override
  Future<Either<Failure, List<Exam>>> getExams({
    String? categoryId,
    int page = 1,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final exams = await remoteDataSource.getExams(
          categoryId: categoryId,
          page: page,
        );
        
        // Cache the results
        await localDataSource.cacheExams(exams);
        
        return Right(exams.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final cachedExams = await localDataSource.getCachedExams(
          categoryId: categoryId,
        );
        return Right(cachedExams.map((model) => model.toEntity()).toList());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
```

### 5.2 Data Sources

#### Remote Data Source
```dart
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ExamRemoteDataSource {
  factory ExamRemoteDataSource(Dio dio) = _ExamRemoteDataSource;
  
  @GET('/mobile/exams')
  Future<ApiResponse<List<ExamModel>>> getExams({
    @Query('category_id') String? categoryId,
    @Query('page') int page = 1,
    @Query('per_page') int perPage = 15,
  });
  
  @GET('/mobile/exams/{id}')
  Future<ApiResponse<ExamModel>> getExamById(
    @Path('id') String id,
  );
}
```

#### Local Data Source
```dart
abstract class ExamLocalDataSource {
  Future<List<ExamModel>> getCachedExams({String? categoryId});
  Future<ExamModel> getCachedExamById(String id);
  Future<void> cacheExams(List<ExamModel> exams);
  Future<void> cacheExam(ExamModel exam);
  Future<void> clearCache();
}

class ExamLocalDataSourceImpl implements ExamLocalDataSource {
  ExamLocalDataSourceImpl(this.database);
  
  final AppDatabase database;
  
  @override
  Future<List<ExamModel>> getCachedExams({String? categoryId}) async {
    final query = database.select(database.exams);
    
    if (categoryId != null) {
      query.where((exam) => exam.categoryId.equals(categoryId));
    }
    
    final results = await query.get();
    return results.map((row) => ExamModel.fromDrift(row)).toList();
  }
}
```

---

## 6. Network Architecture

### 6.1 API Client Configuration

```dart
@injectable
class ApiClient {
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    _setupInterceptors();
  }
  
  late final Dio _dio;
  
  Dio get dio => _dio;
  
  void _setupInterceptors() {
    _dio.interceptors.addAll([
      AuthInterceptor(),
      ErrorInterceptor(),
      CacheInterceptor(),
      if (kDebugMode) PrettyDioLogger(),
    ]);
  }
}
```

### 6.2 Interceptors

#### Authentication Interceptor
```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await getIt<SecureStorage>().getToken();
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    handler.next(options);
  }
  
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Handle token refresh or logout
      await _handleUnauthorized();
    }
    
    handler.next(err);
  }
}
```

---

## 7. Local Storage Architecture

### 7.1 Database Schema (Drift)

```dart
@DataClassName('ExamData')
class Exams extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  IntColumn get duration => integer()();
  IntColumn get totalQuestions => integer()();
  TextColumn get difficulty => text()();
  TextColumn get categoryId => text()();
  BoolColumn get isFree => boolean()();
  RealColumn get price => real().nullable()();
  IntColumn get passingScore => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get cachedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Exams, Questions, UserSessions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  
  @override
  int get schemaVersion => 1;
  
  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(path.join(dbFolder.path, 'qwiktest.db'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
```

### 7.2 Cache Strategy

```dart
@injectable
class CacheManager {
  CacheManager(this.database, this.hiveBox);
  
  final AppDatabase database;
  final Box hiveBox;
  
  static const Duration cacheExpiry = Duration(hours: 24);
  
  Future<bool> isCacheValid(String key) async {
    final cachedAt = hiveBox.get('${key}_cached_at') as DateTime?;
    
    if (cachedAt == null) return false;
    
    return DateTime.now().difference(cachedAt) < cacheExpiry;
  }
  
  Future<void> invalidateCache(String key) async {
    await hiveBox.delete(key);
    await hiveBox.delete('${key}_cached_at');
  }
  
  Future<void> clearExpiredCache() async {
    final now = DateTime.now();
    final keysToDelete = <String>[];
    
    for (final key in hiveBox.keys) {
      if (key.toString().endsWith('_cached_at')) {
        final cachedAt = hiveBox.get(key) as DateTime?;
        if (cachedAt != null && now.difference(cachedAt) > cacheExpiry) {
          keysToDelete.add(key.toString().replaceAll('_cached_at', ''));
        }
      }
    }
    
    for (final key in keysToDelete) {
      await invalidateCache(key);
    }
  }
}
```

---

## 8. Offline Architecture

### 8.1 Offline Strategy

```dart
@injectable
class OfflineManager {
  OfflineManager({
    required this.connectivity,
    required this.cacheManager,
    required this.syncManager,
  });
  
  final Connectivity connectivity;
  final CacheManager cacheManager;
  final SyncManager syncManager;
  
  Stream<bool> get isOnline => connectivity.onConnectivityChanged
      .map((result) => result != ConnectivityResult.none);
  
  Future<void> enableOfflineMode() async {
    // Download essential content for offline use
    await _downloadOfflineContent();
    
    // Set offline mode flag
    await getIt<LocalStorage>().setBool('offline_mode', true);
  }
  
  Future<void> syncWhenOnline() async {
    await for (final isConnected in isOnline) {
      if (isConnected) {
        await syncManager.syncPendingData();
        break;
      }
    }
  }
  
  Future<void> _downloadOfflineContent() async {
    // Download popular exams
    final popularExams = await _getPopularExams();
    await cacheManager.cacheExams(popularExams);
    
    // Download user's bookmarked content
    final bookmarkedContent = await _getBookmarkedContent();
    await cacheManager.cacheBookmarkedContent(bookmarkedContent);
  }
}
```

### 8.2 Data Synchronization

```dart
@injectable
class SyncManager {
  SyncManager({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.conflictResolver,
  });
  
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;
  final ConflictResolver conflictResolver;
  
  Future<void> syncPendingData() async {
    try {
      // Upload pending exam sessions
      await _uploadPendingSessions();
      
      // Download latest content updates
      await _downloadContentUpdates();
      
      // Resolve any conflicts
      await _resolveConflicts();
      
    } catch (e) {
      // Log sync error and retry later
      await _scheduleSyncRetry();
    }
  }
  
  Future<void> _uploadPendingSessions() async {
    final pendingSessions = await localDataSource.getPendingSessions();
    
    for (final session in pendingSessions) {
      try {
        await remoteDataSource.uploadSession(session);
        await localDataSource.markSessionAsSynced(session.id);
      } catch (e) {
        // Mark for retry
        await localDataSource.markSessionForRetry(session.id);
      }
    }
  }
}
```

---

## 9. Security Architecture

### 9.1 Data Encryption

```dart
@injectable
class EncryptionService {
  static const String _keyAlias = 'qwiktest_encryption_key';
  
  Future<String> encrypt(String data) async {
    final key = await _getOrCreateKey();
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromSecureRandom(16);
    
    final encrypted = encrypter.encrypt(data, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }
  
  Future<String> decrypt(String encryptedData) async {
    final parts = encryptedData.split(':');
    final iv = IV.fromBase64(parts[0]);
    final encrypted = Encrypted.fromBase64(parts[1]);
    
    final key = await _getOrCreateKey();
    final encrypter = Encrypter(AES(key));
    
    return encrypter.decrypt(encrypted, iv: iv);
  }
  
  Future<Key> _getOrCreateKey() async {
    // Implementation depends on platform
    // Use Android Keystore / iOS Keychain
    return Key.fromSecureRandom(32);
  }
}
```


    } catch (e) {
      return false;
    }
  }
}
```

---

## 10. Performance Optimization

### 10.1 Image Optimization

```dart
class OptimizedImage extends StatelessWidget {
  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });
  
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Icon(Icons.error),
      ),
    );
  }
}
```

### 10.2 List Performance

```dart
class OptimizedListView extends StatelessWidget {
  const OptimizedListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onLoadMore,
  });
  
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final VoidCallback? onLoadMore;
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      cacheExtent: 1000, // Cache items outside viewport
      addAutomaticKeepAlives: false, // Don't keep items alive
      addRepaintBoundaries: false, // Reduce repaint boundaries
      physics: const BouncingScrollPhysics(),
      controller: _createScrollController(),
    );
  }
  
  ScrollController _createScrollController() {
    final controller = ScrollController();
    
    controller.addListener(() {
      if (controller.position.pixels >= 
          controller.position.maxScrollExtent * 0.8) {
        onLoadMore?.call();
      }
    });
    
    return controller;
  }
}
```

---

## 11. Testing Architecture

### 11.1 Testing Strategy

```dart
// Unit Test Example
class MockExamRepository extends Mock implements ExamRepository {}

void main() {
  group('GetExamsUseCase', () {
    late GetExamsUseCase useCase;
    late MockExamRepository mockRepository;
    
    setUp(() {
      mockRepository = MockExamRepository();
      useCase = GetExamsUseCase(mockRepository);
    });
    
    test('should return list of exams when repository call is successful', () async {
      // Arrange
      const tExams = [Exam(id: '1', title: 'Test Exam')];
      when(() => mockRepository.getExams())
          .thenAnswer((_) async => const Right(tExams));
      
      // Act
      final result = await useCase(const GetExamsParams());
      
      // Assert
      expect(result, const Right(tExams));
      verify(() => mockRepository.getExams()).called(1);
    });
  });
}
```

### 11.2 Widget Testing

```dart
void main() {
  group('ExamCard Widget', () {
    testWidgets('should display exam information correctly', (tester) async {
      // Arrange
      const exam = Exam(
        id: '1',
        title: 'Flutter Test',
        duration: 60,
        totalQuestions: 25,
      );
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExamCard(exam: exam),
          ),
        ),
      );
      
      // Assert
      expect(find.text('Flutter Test'), findsOneWidget);
      expect(find.text('60 min'), findsOneWidget);
      expect(find.text('25 questions'), findsOneWidget);
    });
  });
}
```

---

## 12. Deployment Architecture

### 12.1 Build Configuration

```yaml
# pubspec.yaml
flutter:
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

### 12.2 Environment Configuration

```dart
enum Environment { development, staging, production }

class AppConfig {
  static Environment get environment {
    const env = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
    
    switch (env) {
      case 'staging':
        return Environment.staging;
      case 'production':
        return Environment.production;
      default:
        return Environment.development;
    }
  }
  
  static String get apiBaseUrl {
    switch (environment) {
      case Environment.development:
        return 'https://dev-api.qwiktest.com';
      case Environment.staging:
        return 'https://staging-api.qwiktest.com';
      case Environment.production:
        return 'https://api.qwiktest.com';
    }
  }
}
```

---

## 13. Firebase Integration Strategy

### 13.1 Integration Philosophy
We integrate Firebase selectively for specific mobile-optimized features while maintaining our Laravel backend for core functionality:

- **Core Backend**: Laravel API handles authentication, exams, user management, and business logic
- **Firebase Features**: Only for mobile-specific capabilities where Firebase excels
- **Hybrid Approach**: Best of both worlds without full migration complexity

### 13.2 Firebase Cloud Messaging (FCM) - Push Notifications

```dart
@injectable
class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  
  Future<void> initialize() async {
    // Request permission for iOS
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    
    // Get FCM token
    final token = await _messaging.getToken();
    await _sendTokenToServer(token);
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    
    // Handle notification taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  }
  
  Future<void> _sendTokenToServer(String? token) async {
    if (token != null) {
      await _apiClient.post('/user/fcm-token', {'token': token});
    }
  }
  
  void _handleForegroundMessage(RemoteMessage message) {
    // Show in-app notification or update UI
    _showInAppNotification(message);
  }
  
  void _handleNotificationTap(RemoteMessage message) {
    // Navigate to specific screen based on notification data
    _navigateFromNotification(message.data);
  }
}

@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  // Handle background message processing
}
```

### 13.3 Firebase Analytics - User Behavior Tracking

```dart
@injectable
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  // Track exam events
  Future<void> trackExamStarted(String examId, String examTitle) async {
    await _analytics.logEvent(
      name: 'exam_started',
      parameters: {
        'exam_id': examId,
        'exam_title': examTitle,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
  
  Future<void> trackExamCompleted({
    required String examId,
    required int score,
    required int totalQuestions,
    required Duration timeTaken,
  }) async {
    await _analytics.logEvent(
      name: 'exam_completed',
      parameters: {
        'exam_id': examId,
        'score': score,
        'total_questions': totalQuestions,
        'time_taken_seconds': timeTaken.inSeconds,
        'success_rate': (score / totalQuestions * 100).round(),
      },
    );
  }
  
  // Track user engagement
  Future<void> trackScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }
  
  Future<void> trackUserProperty(String name, String value) async {
    await _analytics.setUserProperty(name: name, value: value);
  }
}
```

### 13.4 Firebase Crashlytics - Error Monitoring

```dart
@injectable
class CrashReportingService {
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;
  
  static Future<void> initialize() async {
    // Enable crash collection in release mode
    await _crashlytics.setCrashlyticsCollectionEnabled(kReleaseMode);
    
    // Set up Flutter error handling
    FlutterError.onError = (errorDetails) {
      _crashlytics.recordFlutterFatalError(errorDetails);
    };
    
    // Set up platform error handling
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }
  
  static Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    bool fatal = false,
    Map<String, dynamic>? context,
  }) async {
    if (context != null) {
      for (final entry in context.entries) {
        await _crashlytics.setCustomKey(entry.key, entry.value);
      }
    }
    
    await _crashlytics.recordError(exception, stackTrace, fatal: fatal);
  }
  
  static Future<void> setUserIdentifier(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }
  
  static Future<void> log(String message) async {
    await _crashlytics.log(message);
  }
}
```

### 13.5 Firebase Performance - App Optimization

```dart
@injectable
class PerformanceMonitoringService {
  static final FirebasePerformance _performance = FirebasePerformance.instance;
  
  // Track API calls
  static Future<T> trackApiCall<T>(
    String endpoint,
    Future<T> Function() apiCall,
  ) async {
    final trace = _performance.newTrace('api_call_$endpoint');
    await trace.start();
    
    try {
      final result = await apiCall();
      trace.setMetric('success', 1);
      return result;
    } catch (e) {
      trace.setMetric('error', 1);
      rethrow;
    } finally {
      await trace.stop();
    }
  }
  
  // Track screen loading times
  static Future<T> trackScreenLoad<T>(
    String screenName,
    Future<T> Function() loadOperation,
  ) async {
    final trace = _performance.newTrace('screen_load_$screenName');
    await trace.start();
    
    try {
      final result = await loadOperation();
      trace.setMetric('loaded', 1);
      return result;
    } catch (e) {
      trace.setMetric('load_error', 1);
      rethrow;
    } finally {
      await trace.stop();
    }
  }
  
  // Track custom operations
  static Future<T> trackCustomOperation<T>(
    String operationName,
    Future<T> Function() operation, {
    Map<String, int>? customMetrics,
  }) async {
    final trace = _performance.newTrace(operationName);
    await trace.start();
    
    if (customMetrics != null) {
      for (final entry in customMetrics.entries) {
        trace.setMetric(entry.key, entry.value);
      }
    }
    
    try {
      final result = await operation();
      return result;
    } finally {
      await trace.stop();
    }
  }
}
```

### 13.6 Firebase Integration in Main App

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Firebase services
  await CrashReportingService.initialize();
  
  // Set up dependency injection
  await configureDependencies();
  
  // Initialize push notifications
  final pushService = getIt<PushNotificationService>();
  await pushService.initialize();
  
  runApp(const QwikTestApp());
}
```

---

## 14. Monitoring & Analytics

### 13.1 Crash Reporting

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  
  // Set up crash reporting
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  
  runApp(const QwikTestApp());
}
```

### 13.2 Performance Monitoring

```dart
@injectable
class PerformanceMonitor {
  static final FirebasePerformance _performance = FirebasePerformance.instance;
  
  static Future<T> trackOperation<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    final trace = _performance.newTrace(operationName);
    await trace.start();
    
    try {
      final result = await operation();
      trace.setMetric('success', 1);
      return result;
    } catch (e) {
      trace.setMetric('error', 1);
      rethrow;
    } finally {
      await trace.stop();
    }
  }
}
```

---

## 14. Conclusion

This technical architecture provides a solid foundation for building a scalable, maintainable, and performant Flutter mobile application. The architecture emphasizes:

- **Clean separation of concerns** through layered architecture
- **Testability** with dependency injection and mocking
- **Performance** through optimized caching and lazy loading
- **Offline capabilities** with robust synchronization
- **Security** through encryption and secure authentication
- **Maintainability** through consistent patterns and code organization

The architecture should be reviewed and updated as the application evolves and new requirements emerge.

---

**Document Version**: 1.0  
**Last Updated**: January 2024  
**Next Review**: March 2024  
**Approved By**: Technical Architecture Team