# QwikTest Mobile App - API Integration Plan

## 1. Overview

This document outlines the comprehensive plan for integrating the QwikTest mobile application with the Laravel backend API. It provides detailed mapping of API endpoints to mobile app features, implementation strategies, error handling, caching mechanisms, and offline synchronization.

### 1.1 API Base Information

- **Base URL**: `https://api.qwiktest.com/api/mobile`
- **Authentication**: Laravel Sanctum (Bearer Token)
- **Content Type**: `application/json`
- **API Version**: v1
- **Rate Limiting**: 1000 requests per hour per user

### 1.2 Integration Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    MOBILE APPLICATION                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ Presentation│  │   Domain    │  │       Data          │ │
│  │   Layer     │  │   Layer     │  │      Layer          │ │
│  │   (UI)      │  │ (Use Cases) │  │  (Repositories)     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    API CLIENT LAYER                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Dio       │  │ Interceptors│  │    Data Sources     │ │
│  │  Client     │  │(Auth, Cache,│  │  (Remote/Local)     │ │
│  │             │  │   Error)    │  │                     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                    │                         │
                    ▼                         ▼
┌─────────────────────────────┐  ┌─────────────────────────────┐
│      LARAVEL BACKEND        │  │      FIREBASE SERVICES      │
│  ┌─────────────────────────┐ │  │  ┌─────────────────────────┐ │
│  │ Controllers/Middleware  │ │  │  │ FCM (Push Notifications)│ │
│  │ Database/Business Logic │ │  │  │ Analytics (User Tracking│ │
│  │ Authentication/Exams    │ │  │  │ Crashlytics (Monitoring)│ │
│  │ User Management         │ │  │  │ Performance (Metrics)   │ │
│  └─────────────────────────┘ │  │  └─────────────────────────┘ │
└─────────────────────────────┘  └─────────────────────────────┘
```

### 1.3 Hybrid Integration Strategy

**Laravel Backend (Core Features)**:
- User authentication and management
- Exam content and questions
- User progress and scores
- Subscription management
- Business logic and data persistence

**Firebase Services (Mobile-Optimized Features)**:
- Push notifications via FCM
- User behavior analytics
- Crash reporting and monitoring
- Performance tracking and optimization

---

## 2. Authentication Integration

### 2.1 Authentication Flow

#### Login Process
```dart
class AuthRemoteDataSource {
  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _dio.post(
      '/auth/login',
      data: {
        'email': request.email,
        'password': request.password,
        'device_name': await _getDeviceName(),
      },
    );
    
    return AuthResponse.fromJson(response.data);
  }
}
```

**API Endpoint**: `POST /mobile/auth/login`

**Request Body**:
```json
{
  "email": "user@example.com",
  "password": "password123",
  "device_name": "iPhone 15 Pro"
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "user@example.com",
      "avatar": "https://api.qwiktest.com/storage/avatars/1.jpg",
      "email_verified_at": "2024-01-15T10:30:00Z",
      "subscription_status": "premium",
      "subscription_expires_at": "2024-12-31T23:59:59Z"
    },
    "token": "1|abc123def456...",
    "expires_at": "2024-02-15T10:30:00Z"
  },
  "message": "Login successful"
}
```

#### Registration Process
**API Endpoint**: `POST /mobile/auth/register`

**Request Body**:
```json
{
  "name": "John Doe",
  "email": "user@example.com",
  "password": "password123",
  "password_confirmation": "password123",
  "device_name": "iPhone 15 Pro"
}
```

#### Token Refresh
**API Endpoint**: `POST /mobile/auth/refresh`

**Headers**: `Authorization: Bearer {current_token}`

### 2.2 Authentication Implementation

```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.getToken();
    
    if (token != null && !_isAuthEndpoint(options.path)) {
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
      // Try to refresh token
      final refreshed = await _refreshToken();
      
      if (refreshed) {
        // Retry original request
        final clonedRequest = await _dio.request(
          err.requestOptions.path,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
          ),
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        );
        
        handler.resolve(clonedRequest);
        return;
      }
      
      // Refresh failed, logout user
      await _authRepository.logout();
    }
    
    handler.next(err);
  }
}
```

---

## 3. Content API Integration

### 3.1 Exams API

#### Get Exams List
**API Endpoint**: `GET /mobile/exams`

**Query Parameters**:
- `category_id` (optional): Filter by category
- `difficulty` (optional): easy, medium, hard
- `is_free` (optional): true/false
- `search` (optional): Search term
- `page` (default: 1): Page number
- `per_page` (default: 15): Items per page
- `sort` (default: created_at): Sort field
- `order` (default: desc): Sort order

**Implementation**:
```dart
class ExamRemoteDataSource {
  Future<PaginatedResponse<ExamModel>> getExams({
    String? categoryId,
    String? difficulty,
    bool? isFree,
    String? search,
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _dio.get(
      '/exams',
      queryParameters: {
        if (categoryId != null) 'category_id': categoryId,
        if (difficulty != null) 'difficulty': difficulty,
        if (isFree != null) 'is_free': isFree,
        if (search != null) 'search': search,
        'page': page,
        'per_page': perPage,
      },
    );
    
    return PaginatedResponse<ExamModel>.fromJson(
      response.data,
      (json) => ExamModel.fromJson(json),
    );
  }
}
```

**Response Structure**:
```json
{
  "success": true,
  "data": {
    "data": [
      {
        "id": "uuid-1",
        "title": "Flutter Development Basics",
        "description": "Test your knowledge of Flutter fundamentals",
        "category": {
          "id": "cat-1",
          "name": "Mobile Development",
          "icon": "mobile-icon.svg"
        },
        "difficulty": "medium",
        "duration": 60,
        "total_questions": 25,
        "passing_score": 70,
        "is_free": false,
        "price": 9.99,
        "currency": "USD",
        "thumbnail": "https://api.qwiktest.com/storage/thumbnails/exam-1.jpg",
        "tags": ["flutter", "mobile", "dart"],
        "stats": {
          "total_attempts": 1250,
          "average_score": 78.5,
          "pass_rate": 0.82
        },
        "created_at": "2024-01-15T10:30:00Z",
        "updated_at": "2024-01-20T15:45:00Z"
      }
    ],
    "current_page": 1,
    "last_page": 5,
    "per_page": 15,
    "total": 73,
    "from": 1,
    "to": 15
  }
}
```

#### Get Exam Details
**API Endpoint**: `GET /mobile/exams/{id}`

**Response includes**:
- Complete exam information
- Question count and types
- Prerequisites
- Learning objectives
- Related exams

### 3.2 Categories API

#### Get Categories
**API Endpoint**: `GET /mobile/categories`

**Implementation**:
```dart
class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories() async {
    final response = await _dio.get('/categories');
    
    final List<dynamic> data = response.data['data'];
    return data.map((json) => CategoryModel.fromJson(json)).toList();
  }
}
```

**Response**:
```json
{
  "success": true,
  "data": [
    {
      "id": "cat-1",
      "name": "Mobile Development",
      "description": "iOS, Android, and Cross-platform development",
      "icon": "mobile-icon.svg",
      "color": "#6366F1",
      "exam_count": 25,
      "is_popular": true,
      "order": 1
    }
  ]
}
```

### 3.3 Questions API

#### Get Exam Questions
**API Endpoint**: `GET /mobile/exams/{exam_id}/questions`

**Note**: This endpoint is called when starting an exam session.

**Response**:
```json
{
  "success": true,
  "data": {
    "session_id": "session-uuid",
    "questions": [
      {
        "id": "q-1",
        "type": "multiple_choice",
        "question": "What is Flutter?",
        "options": [
          {
            "id": "opt-1",
            "text": "A mobile development framework",
            "is_correct": true
          },
          {
            "id": "opt-2",
            "text": "A programming language",
            "is_correct": false
          }
        ],
        "explanation": "Flutter is Google's UI toolkit for building natively compiled applications.",
        "points": 1,
        "time_limit": 60
      }
    ],
    "total_questions": 25,
    "total_time": 3600,
    "started_at": "2024-01-15T10:30:00Z"
  }
}
```

---

## 4. User Profile Integration

### 4.1 Get User Profile
**API Endpoint**: `GET /mobile/user/profile`

**Implementation**:
```dart
class UserRemoteDataSource {
  Future<UserProfileModel> getUserProfile() async {
    final response = await _dio.get('/user/profile');
    return UserProfileModel.fromJson(response.data['data']);
  }
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "user@example.com",
    "avatar": "https://api.qwiktest.com/storage/avatars/1.jpg",
    "bio": "Mobile developer passionate about learning",
    "location": "San Francisco, CA",
    "website": "https://johndoe.dev",
    "social_links": {
      "twitter": "@johndoe",
      "linkedin": "johndoe",
      "github": "johndoe"
    },
    "stats": {
      "total_exams_taken": 45,
      "total_points": 3250,
      "average_score": 82.5,
      "rank": 156,
      "streak_days": 12,
      "certificates_earned": 8
    },
    "subscription": {
      "status": "premium",
      "plan": "monthly",
      "expires_at": "2024-02-15T10:30:00Z",
      "auto_renew": true
    },
    "preferences": {
      "notifications": {
        "email": true,
        "push": true,
        "exam_reminders": true,
        "achievement_alerts": true
      },
      "privacy": {
        "profile_visibility": "public",
        "show_stats": true,
        "show_activity": false
      }
    },
    "created_at": "2023-06-15T10:30:00Z",
    "updated_at": "2024-01-20T15:45:00Z"
  }
}
```

### 4.2 Update User Profile
**API Endpoint**: `PUT /mobile/user/profile`

**Request Body**:
```json
{
  "name": "John Doe",
  "bio": "Updated bio",
  "location": "New York, NY",
  "website": "https://johndoe.dev",
  "social_links": {
    "twitter": "@johndoe",
    "linkedin": "johndoe"
  }
}
```

### 4.3 Upload Avatar
**API Endpoint**: `POST /mobile/user/avatar`

**Implementation**:
```dart
Future<String> uploadAvatar(File imageFile) async {
  final formData = FormData.fromMap({
    'avatar': await MultipartFile.fromFile(
      imageFile.path,
      filename: 'avatar.jpg',
    ),
  });
  
  final response = await _dio.post(
    '/user/avatar',
    data: formData,
  );
  
  return response.data['data']['avatar_url'];
}
```

---

## 5. Dashboard Integration

### 5.1 Get Dashboard Data
**API Endpoint**: `GET /mobile/dashboard`

**Implementation**:
```dart
class DashboardRemoteDataSource {
  Future<DashboardModel> getDashboardData() async {
    final response = await _dio.get('/dashboard');
    return DashboardModel.fromJson(response.data['data']);
  }
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "user_stats": {
      "total_exams": 45,
      "completed_today": 2,
      "current_streak": 12,
      "total_points": 3250
    },
    "recent_activity": [
      {
        "id": "activity-1",
        "type": "exam_completed",
        "exam": {
          "id": "exam-1",
          "title": "Flutter Basics",
          "thumbnail": "https://api.qwiktest.com/storage/thumbnails/exam-1.jpg"
        },
        "score": 85,
        "completed_at": "2024-01-20T14:30:00Z"
      }
    ],
    "recommended_exams": [
      {
        "id": "exam-2",
        "title": "Advanced Flutter",
        "category": "Mobile Development",
        "difficulty": "hard",
        "thumbnail": "https://api.qwiktest.com/storage/thumbnails/exam-2.jpg",
        "reason": "Based on your Flutter Basics performance"
      }
    ],
    "achievements": [
      {
        "id": "achievement-1",
        "title": "Flutter Expert",
        "description": "Complete 10 Flutter exams with 80%+ score",
        "icon": "flutter-expert.svg",
        "progress": 8,
        "total": 10,
        "unlocked": false
      }
    ],
    "learning_path": {
      "current_path": {
        "id": "path-1",
        "title": "Mobile Development Mastery",
        "progress": 65,
        "next_exam": {
          "id": "exam-3",
          "title": "React Native Fundamentals"
        }
      }
    }
  }
}
```

---

## 6. Exam Session Integration

### 6.1 Start Exam Session
**API Endpoint**: `POST /mobile/exams/{exam_id}/start`

**Implementation**:
```dart
class ExamSessionRemoteDataSource {
  Future<ExamSessionModel> startExamSession(String examId) async {
    final response = await _dio.post('/exams/$examId/start');
    return ExamSessionModel.fromJson(response.data['data']);
  }
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "session_id": "session-uuid",
    "exam_id": "exam-1",
    "started_at": "2024-01-20T10:30:00Z",
    "expires_at": "2024-01-20T11:30:00Z",
    "questions": [
      {
        "id": "q-1",
        "type": "multiple_choice",
        "question": "What is Flutter?",
        "options": [
          {"id": "opt-1", "text": "A mobile framework"},
          {"id": "opt-2", "text": "A programming language"}
        ],
        "time_limit": 60
      }
    ],
    "settings": {
      "shuffle_questions": true,
      "shuffle_options": true,
      "show_results_immediately": false,
      "allow_review": true
    }
  }
}
```

### 6.2 Submit Answer
**API Endpoint**: `POST /mobile/exam-sessions/{session_id}/answers`

**Request Body**:
```json
{
  "question_id": "q-1",
  "selected_options": ["opt-1"],
  "time_spent": 45,
  "answered_at": "2024-01-20T10:31:00Z"
}
```

### 6.3 Submit Exam
**API Endpoint**: `POST /mobile/exam-sessions/{session_id}/submit`

**Response**:
```json
{
  "success": true,
  "data": {
    "session_id": "session-uuid",
    "score": 85,
    "percentage": 85.0,
    "passed": true,
    "total_questions": 25,
    "correct_answers": 21,
    "time_taken": 2340,
    "points_earned": 85,
    "rank": "A",
    "certificate": {
      "id": "cert-1",
      "url": "https://api.qwiktest.com/certificates/cert-1.pdf"
    },
    "detailed_results": [
      {
        "question_id": "q-1",
        "is_correct": true,
        "selected_options": ["opt-1"],
        "correct_options": ["opt-1"],
        "points": 1,
        "explanation": "Flutter is indeed a mobile development framework."
      }
    ],
    "submitted_at": "2024-01-20T11:09:00Z"
  }
}
```

---

## 7. Search Integration

### 7.1 Global Search
**API Endpoint**: `GET /mobile/search`

**Query Parameters**:
- `q`: Search query (required)
- `type`: Filter by type (exams, categories, users)
- `category_id`: Filter by category
- `difficulty`: Filter by difficulty
- `page`: Page number
- `per_page`: Items per page

**Implementation**:
```dart
class SearchRemoteDataSource {
  Future<SearchResultsModel> search({
    required String query,
    String? type,
    String? categoryId,
    String? difficulty,
    int page = 1,
  }) async {
    final response = await _dio.get(
      '/search',
      queryParameters: {
        'q': query,
        if (type != null) 'type': type,
        if (categoryId != null) 'category_id': categoryId,
        if (difficulty != null) 'difficulty': difficulty,
        'page': page,
      },
    );
    
    return SearchResultsModel.fromJson(response.data['data']);
  }
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "query": "flutter",
    "total_results": 45,
    "results": {
      "exams": [
        {
          "id": "exam-1",
          "title": "Flutter Development Basics",
          "category": "Mobile Development",
          "difficulty": "medium",
          "thumbnail": "https://api.qwiktest.com/storage/thumbnails/exam-1.jpg",
          "relevance_score": 0.95
        }
      ],
      "categories": [
        {
          "id": "cat-1",
          "name": "Flutter Development",
          "exam_count": 12,
          "relevance_score": 0.88
        }
      ]
    },
    "suggestions": [
      "flutter widgets",
      "flutter state management",
      "flutter navigation"
    ],
    "filters": {
      "categories": [
        {"id": "cat-1", "name": "Mobile Development", "count": 25}
      ],
      "difficulties": [
        {"level": "easy", "count": 10},
        {"level": "medium", "count": 20},
        {"level": "hard", "count": 15}
      ]
    }
  }
}
```

### 7.2 Search Suggestions
**API Endpoint**: `GET /mobile/search/suggestions`

**Query Parameters**:
- `q`: Partial search query
- `limit`: Maximum suggestions (default: 10)

---

## 8. Notifications Integration

### 8.1 Get Notifications
**API Endpoint**: `GET /mobile/notifications`

**Query Parameters**:
- `page`: Page number
- `per_page`: Items per page
- `type`: Filter by type (exam, achievement, system)
- `read`: Filter by read status (true/false)

**Implementation**:
```dart
class NotificationRemoteDataSource {
  Future<PaginatedResponse<NotificationModel>> getNotifications({
    int page = 1,
    String? type,
    bool? read,
  }) async {
    final response = await _dio.get(
      '/notifications',
      queryParameters: {
        'page': page,
        if (type != null) 'type': type,
        if (read != null) 'read': read,
      },
    );
    
    return PaginatedResponse<NotificationModel>.fromJson(
      response.data,
      (json) => NotificationModel.fromJson(json),
    );
  }
}
```

### 8.2 Mark as Read
**API Endpoint**: `POST /mobile/notifications/{id}/read`

### 8.3 Register Device for Push Notifications
**API Endpoint**: `POST /mobile/notifications/devices`

**Request Body**:
```json
{
  "device_token": "fcm-token-here",
  "platform": "ios",
  "device_info": {
    "model": "iPhone 15 Pro",
    "os_version": "17.2",
    "app_version": "1.0.0"
  }
}
```

---

## 9. Settings Integration

### 9.1 Get App Configuration
**API Endpoint**: `GET /mobile/settings/app-config`

**Response**:
```json
{
  "success": true,
  "data": {
    "app_version": {
      "current": "1.0.0",
      "minimum_supported": "1.0.0",
      "latest": "1.0.1",
      "update_required": false,
      "update_url": "https://apps.apple.com/app/qwiktest"
    },
    "features": {
      "offline_mode": true,
      "dark_mode": true,
      "push_notifications": true,
      "social_sharing": true
    },
    "limits": {
      "max_offline_exams": 10,
      "max_file_upload_size": 5242880,
      "session_timeout": 3600
    },
    "urls": {
      "privacy_policy": "https://qwiktest.com/privacy",
      "terms_of_service": "https://qwiktest.com/terms",
      "support": "https://qwiktest.com/support",
      "feedback": "https://qwiktest.com/feedback"
    }
  }
}
```

### 9.2 Update User Settings
**API Endpoint**: `PUT /mobile/settings/user`

**Request Body**:
```json
{
  "notifications": {
    "email": true,
    "push": true,
    "exam_reminders": true
  },
  "privacy": {
    "profile_visibility": "public",
    "show_stats": true
  },
  "preferences": {
    "theme": "dark",
    "language": "en",
    "timezone": "America/New_York"
  }
}
```

---

## 10. Offline Support Implementation

### 10.1 Offline Data Strategy

```dart
class OfflineRepository {
  Future<List<Exam>> getExams({String? categoryId}) async {
    if (await _networkInfo.isConnected) {
      try {
        // Fetch from remote
        final remoteExams = await _remoteDataSource.getExams(
          categoryId: categoryId,
        );
        
        // Cache the results
        await _localDataSource.cacheExams(remoteExams);
        
        return remoteExams.map((model) => model.toEntity()).toList();
      } catch (e) {
        // Fall back to cached data
        return _getCachedExams(categoryId: categoryId);
      }
    } else {
      // Offline mode - use cached data
      return _getCachedExams(categoryId: categoryId);
    }
  }
  
  Future<List<Exam>> _getCachedExams({String? categoryId}) async {
    final cachedExams = await _localDataSource.getCachedExams(
      categoryId: categoryId,
    );
    
    return cachedExams.map((model) => model.toEntity()).toList();
  }
}
```

### 10.2 Offline Exam Sessions

```dart
class OfflineExamSessionRepository {
  Future<void> saveOfflineSession(ExamSession session) async {
    await _localDataSource.saveExamSession(session);
  }
  
  Future<void> syncPendingSessions() async {
    if (await _networkInfo.isConnected) {
      final pendingSessions = await _localDataSource.getPendingSessions();
      
      for (final session in pendingSessions) {
        try {
          await _remoteDataSource.submitExamSession(session);
          await _localDataSource.markSessionAsSynced(session.id);
        } catch (e) {
          // Keep for next sync attempt
          await _localDataSource.markSessionForRetry(session.id);
        }
      }
    }
  }
}
```

### 10.3 Background Sync

```dart
class BackgroundSyncService {
  static Future<void> performBackgroundSync() async {
    final connectivity = getIt<Connectivity>();
    final syncManager = getIt<SyncManager>();
    
    await for (final result in connectivity.onConnectivityChanged) {
      if (result != ConnectivityResult.none) {
        await syncManager.syncPendingData();
        break;
      }
    }
  }
}
```

---

## 11. Error Handling Strategy

### 11.1 Error Types and Handling

```dart
abstract class Failure extends Equatable {
  const Failure(this.message);
  
  final String message;
  
  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network connection failed']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred']) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Authentication failed']) : super(message);
}
```

### 11.2 Error Interceptor

```dart
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Failure failure;
    
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        failure = const NetworkFailure('Connection timeout');
        break;
        
      case DioExceptionType.badResponse:
        failure = _handleHttpError(err.response!);
        break;
        
      case DioExceptionType.cancel:
        failure = const ServerFailure('Request cancelled');
        break;
        
      default:
        failure = const ServerFailure('Unexpected error occurred');
    }
    
    // Log error for debugging
    _logError(err, failure);
    
    // Convert to custom exception
    handler.next(DioException(
      requestOptions: err.requestOptions,
      error: failure,
      type: err.type,
    ));
  }
  
  Failure _handleHttpError(Response response) {
    switch (response.statusCode) {
      case 400:
        return ServerFailure(_extractErrorMessage(response));
      case 401:
        return const AuthFailure('Authentication required');
      case 403:
        return const AuthFailure('Access forbidden');
      case 404:
        return const ServerFailure('Resource not found');
      case 422:
        return ServerFailure(_extractValidationErrors(response));
      case 500:
        return const ServerFailure('Internal server error');
      default:
        return ServerFailure('HTTP ${response.statusCode}');
    }
  }
}
```

### 11.3 User-Friendly Error Messages

```dart
class ErrorMessageMapper {
  static String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return 'Please check your internet connection and try again.';
      case AuthFailure:
        return 'Please log in again to continue.';
      case ServerFailure:
        return 'Something went wrong. Please try again later.';
      case CacheFailure:
        return 'Unable to load offline data. Please connect to the internet.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}
```

---

## 12. Caching Strategy

### 12.1 Cache Levels

```dart
class CacheManager {
  // Level 1: Memory Cache (fastest)
  final Map<String, dynamic> _memoryCache = {};
  
  // Level 2: Disk Cache (persistent)
  final Box _diskCache;
  
  // Level 3: Database Cache (structured)
  final AppDatabase _database;
  
  Future<T?> get<T>(String key) async {
    // Try memory cache first
    if (_memoryCache.containsKey(key)) {
      return _memoryCache[key] as T;
    }
    
    // Try disk cache
    final diskValue = _diskCache.get(key);
    if (diskValue != null) {
      _memoryCache[key] = diskValue; // Promote to memory
      return diskValue as T;
    }
    
    return null;
  }
  
  Future<void> put<T>(String key, T value, {Duration? ttl}) async {
    // Store in memory
    _memoryCache[key] = value;
    
    // Store on disk with TTL
    await _diskCache.put(key, value);
    
    if (ttl != null) {
      await _diskCache.put('${key}_expires', 
        DateTime.now().add(ttl).millisecondsSinceEpoch);
    }
  }
  
  Future<bool> isExpired(String key) async {
    final expiresAt = _diskCache.get('${key}_expires');
    if (expiresAt == null) return false;
    
    return DateTime.now().millisecondsSinceEpoch > expiresAt;
  }
}
```

### 12.2 Cache Policies

```dart
enum CachePolicy {
  cacheFirst,    // Use cache if available, then network
  networkFirst,  // Use network first, fallback to cache
  cacheOnly,     // Only use cache
  networkOnly,   // Only use network
}

class CacheInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final policy = options.extra['cache_policy'] as CachePolicy?;
    final cacheKey = _generateCacheKey(options);
    
    if (policy == CachePolicy.cacheFirst || policy == CachePolicy.cacheOnly) {
      final cachedResponse = await _cacheManager.get(cacheKey);
      
      if (cachedResponse != null && !await _cacheManager.isExpired(cacheKey)) {
        handler.resolve(Response(
          requestOptions: options,
          data: cachedResponse,
          statusCode: 200,
        ));
        return;
      }
      
      if (policy == CachePolicy.cacheOnly) {
        handler.reject(DioException(
          requestOptions: options,
          error: const CacheFailure('No cached data available'),
        ));
        return;
      }
    }
    
    handler.next(options);
  }
  
  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final policy = response.requestOptions.extra['cache_policy'] as CachePolicy?;
    
    if (policy != CachePolicy.networkOnly && response.statusCode == 200) {
      final cacheKey = _generateCacheKey(response.requestOptions);
      final ttl = response.requestOptions.extra['cache_ttl'] as Duration?;
      
      await _cacheManager.put(cacheKey, response.data, ttl: ttl);
    }
    
    handler.next(response);
  }
}
```

---

## 13. Performance Optimization

### 13.1 Request Optimization

```dart
class OptimizedApiClient {
  // Request deduplication
  final Map<String, Future<Response>> _pendingRequests = {};
  
  Future<Response> request(RequestOptions options) async {
    final key = _generateRequestKey(options);
    
    // Return existing request if in progress
    if (_pendingRequests.containsKey(key)) {
      return _pendingRequests[key]!;
    }
    
    // Create new request
    final future = _dio.request(
      options.path,
      options: Options(
        method: options.method,
        headers: options.headers,
      ),
      data: options.data,
      queryParameters: options.queryParameters,
    );
    
    _pendingRequests[key] = future;
    
    // Clean up after completion
    future.whenComplete(() => _pendingRequests.remove(key));
    
    return future;
  }
}
```

### 13.2 Pagination Optimization

```dart
class PaginatedDataSource<T> {
  final List<T> _items = [];
  int _currentPage = 0;
  bool _hasMore = true;
  bool _isLoading = false;
  
  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;
    
    _isLoading = true;
    
    try {
      final response = await _apiCall(page: _currentPage + 1);
      
      _items.addAll(response.data);
      _currentPage = response.currentPage;
      _hasMore = response.hasMore;
      
    } finally {
      _isLoading = false;
    }
  }
  
  void refresh() {
    _items.clear();
    _currentPage = 0;
    _hasMore = true;
    loadMore();
  }
}
```

---

## 14. Testing Strategy

### 14.1 API Client Testing

```dart
class MockDio extends Mock implements Dio {}

void main() {
  group('ExamRemoteDataSource', () {
    late ExamRemoteDataSource dataSource;
    late MockDio mockDio;
    
    setUp(() {
      mockDio = MockDio();
      dataSource = ExamRemoteDataSource(mockDio);
    });
    
    test('should return list of exams when API call is successful', () async {
      // Arrange
      final responseData = {
        'success': true,
        'data': {
          'data': [examJsonData],
          'current_page': 1,
          'last_page': 1,
        }
      };
      
      when(() => mockDio.get(
        any(),
        queryParameters: any(named: 'queryParameters'),
      )).thenAnswer((_) async => Response(
        data: responseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/exams'),
      ));
      
      // Act
      final result = await dataSource.getExams();
      
      // Assert
      expect(result.data, isA<List<ExamModel>>());
      expect(result.data.length, 1);
      verify(() => mockDio.get('/exams', queryParameters: any(named: 'queryParameters')));
    });
  });
}
```

### 14.2 Integration Testing

```dart
void main() {
  group('API Integration Tests', () {
    late Dio dio;
    
    setUpAll(() {
      dio = Dio(BaseOptions(
        baseUrl: 'https://staging-api.qwiktest.com/api/mobile',
      ));
    });
    
    test('should authenticate user successfully', () async {
      final response = await dio.post('/auth/login', data: {
        'email': 'test@example.com',
        'password': 'password123',
        'device_name': 'Test Device',
      });
      
      expect(response.statusCode, 200);
      expect(response.data['success'], true);
      expect(response.data['data']['token'], isNotNull);
    });
  });
}
```

---

## 15. Security Considerations

### 15.1 Token Security

```dart
class SecureTokenStorage {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  
  final FlutterSecureStorage _secureStorage;
  
  Future<void> storeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _secureStorage.write(key: _tokenKey, value: accessToken),
      _secureStorage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }
  
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }
  
  Future<void> clearTokens() async {
    await Future.wait([
      _secureStorage.delete(key: _tokenKey),
      _secureStorage.delete(key: _refreshTokenKey),
    ]);
  }
}
```

### 15.2 Certificate Pinning

```dart
class SecureApiClient {
  Dio createSecureDio() {
    final dio = Dio();
    
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) {
        // Implement certificate pinning
        return _verifyCertificate(cert, host);
      };
      return client;
    };
    
    return dio;
  }
  
  bool _verifyCertificate(X509Certificate cert, String host) {
    // Verify certificate against pinned certificates
    final pinnedCerts = [
      'sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=', // Production cert
      'sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=', // Backup cert
    ];
    
    final certSha256 = sha256.convert(cert.der).toString();
    return pinnedCerts.contains('sha256/$certSha256');
  }
}
```

---

## 16. Firebase Services Integration

### 16.1 Firebase Cloud Messaging (FCM) Integration

#### 16.1.1 FCM Token Management

```dart
class FCMService {
  static const String _tokenKey = 'fcm_token';
  
  Future<void> initializeFCM() async {
    // Request notification permissions
    final messaging = FirebaseMessaging.instance;
    
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get FCM token
      final token = await messaging.getToken();
      await _sendTokenToBackend(token);
      
      // Listen for token refresh
      messaging.onTokenRefresh.listen(_sendTokenToBackend);
    }
  }
  
  Future<void> _sendTokenToBackend(String? token) async {
    if (token != null) {
      try {
        await _apiClient.post('/user/fcm-token', {
          'token': token,
          'platform': Platform.isIOS ? 'ios' : 'android',
          'app_version': await _getAppVersion(),
        });
        
        await _secureStorage.write(key: _tokenKey, value: token);
      } catch (e) {
        // Handle token registration error
        FirebaseCrashlytics.instance.recordError(e, null);
      }
    }
  }
}
```

#### 16.1.2 Push Notification Handling

**Laravel Backend Endpoint**: `POST /mobile/user/fcm-token`

**Request Body**:
```json
{
  "token": "fcm_token_string",
  "platform": "ios",
  "app_version": "1.0.0"
}
```

**Notification Types**:
- Exam reminders
- New content notifications
- Achievement unlocks
- Study streak reminders
- Premium feature announcements

#### 16.1.3 Notification Categories

```dart
class NotificationHandler {
  static const Map<String, String> notificationCategories = {
    'exam_reminder': 'Exam Reminder',
    'new_content': 'New Content Available',
    'achievement': 'Achievement Unlocked',
    'study_streak': 'Study Streak',
    'premium_feature': 'Premium Feature',
  };
  
  void handleNotificationTap(RemoteMessage message) {
    final category = message.data['category'];
    final targetId = message.data['target_id'];
    
    switch (category) {
      case 'exam_reminder':
        _navigateToExam(targetId);
        break;
      case 'new_content':
        _navigateToContent(targetId);
        break;
      case 'achievement':
        _navigateToAchievements();
        break;
      case 'study_streak':
        _navigateToProgress();
        break;
      case 'premium_feature':
        _navigateToSubscription();
        break;
    }
  }
}
```

### 16.2 Firebase Analytics Integration

#### 16.2.1 User Behavior Tracking

```dart
class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  // User engagement events
  static Future<void> trackUserLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }
  
  static Future<void> trackScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }
  
  // Exam-related events
  static Future<void> trackExamStarted({
    required String examId,
    required String examTitle,
    required String category,
  }) async {
    await _analytics.logEvent(
      name: 'exam_started',
      parameters: {
        'exam_id': examId,
        'exam_title': examTitle,
        'category': category,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
  
  static Future<void> trackExamCompleted({
    required String examId,
    required int score,
    required int totalQuestions,
    required Duration timeTaken,
    required double accuracy,
  }) async {
    await _analytics.logEvent(
      name: 'exam_completed',
      parameters: {
        'exam_id': examId,
        'score': score,
        'total_questions': totalQuestions,
        'time_taken_seconds': timeTaken.inSeconds,
        'accuracy_percentage': (accuracy * 100).round(),
        'success_rate': (score / totalQuestions * 100).round(),
      },
    );
  }
  
  // Learning behavior
  static Future<void> trackStudySessionStarted() async {
    await _analytics.logEvent(name: 'study_session_started');
  }
  
  static Future<void> trackContentViewed({
    required String contentId,
    required String contentType,
    required Duration viewDuration,
  }) async {
    await _analytics.logEvent(
      name: 'content_viewed',
      parameters: {
        'content_id': contentId,
        'content_type': contentType,
        'view_duration_seconds': viewDuration.inSeconds,
      },
    );
  }
  
  // Subscription events
  static Future<void> trackSubscriptionPurchased(String planType) async {
    await _analytics.logPurchase(
      currency: 'USD',
      value: _getPlanValue(planType),
      parameters: {'plan_type': planType},
    );
  }
}
```

#### 16.2.2 Custom Analytics Dashboard Integration

**Laravel Backend Analytics Endpoint**: `POST /mobile/analytics/events`

```dart
class HybridAnalyticsService {
  // Send custom events to both Firebase and Laravel backend
  static Future<void> trackCustomEvent({
    required String eventName,
    required Map<String, dynamic> parameters,
  }) async {
    // Send to Firebase Analytics
    await FirebaseAnalytics.instance.logEvent(
      name: eventName,
      parameters: parameters,
    );
    
    // Send to Laravel backend for custom analytics
    try {
      await _apiClient.post('/analytics/events', {
        'event_name': eventName,
        'parameters': parameters,
        'timestamp': DateTime.now().toIso8601String(),
        'user_id': await _getCurrentUserId(),
        'session_id': await _getSessionId(),
      });
    } catch (e) {
      // Fail silently for analytics
      FirebaseCrashlytics.instance.recordError(e, null);
    }
  }
}
```

### 16.3 Firebase Crashlytics Integration

#### 16.3.1 Crash Reporting Setup

```dart
class CrashReportingService {
  static Future<void> initialize() async {
    // Enable crash collection
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(kReleaseMode);
    
    // Set up Flutter error handling
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    
    // Set up platform error handling
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
  
  static Future<void> recordApiError({
    required DioException error,
    required String endpoint,
    Map<String, dynamic>? additionalData,
  }) async {
    await FirebaseCrashlytics.instance.recordError(
      error,
      error.stackTrace,
      reason: 'API Error: $endpoint',
      information: [
        'Endpoint: $endpoint',
        'Method: ${error.requestOptions.method}',
        'Status Code: ${error.response?.statusCode}',
        'Response Data: ${error.response?.data}',
        if (additionalData != null) 'Additional: $additionalData',
      ],
    );
  }
  
  static Future<void> setUserContext({
    required String userId,
    required String email,
    Map<String, String>? customKeys,
  }) async {
    await FirebaseCrashlytics.instance.setUserIdentifier(userId);
    
    if (customKeys != null) {
      for (final entry in customKeys.entries) {
        await FirebaseCrashlytics.instance.setCustomKey(entry.key, entry.value);
      }
    }
  }
}
```

### 16.4 Firebase Performance Monitoring

#### 16.4.1 API Performance Tracking

```dart
class PerformanceInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Start performance trace for API calls
    final trace = FirebasePerformance.instance.newTrace('api_${_getEndpointName(options.path)}');
    options.extra['performance_trace'] = trace;
    trace.start();
    
    handler.next(options);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final trace = response.requestOptions.extra['performance_trace'] as Trace?;
    
    if (trace != null) {
      trace.setMetric('response_code', response.statusCode ?? 0);
      trace.setMetric('response_size', response.data.toString().length);
      trace.stop();
    }
    
    handler.next(response);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final trace = err.requestOptions.extra['performance_trace'] as Trace?;
    
    if (trace != null) {
      trace.setMetric('error_code', err.response?.statusCode ?? -1);
      trace.setMetric('error_occurred', 1);
      trace.stop();
    }
    
    handler.next(err);
  }
}
```

#### 16.4.2 Screen Performance Tracking

```dart
class ScreenPerformanceTracker {
  static final Map<String, Trace> _screenTraces = {};
  
  static Future<void> startScreenTrace(String screenName) async {
    final trace = FirebasePerformance.instance.newTrace('screen_$screenName');
    _screenTraces[screenName] = trace;
    await trace.start();
  }
  
  static Future<void> stopScreenTrace(String screenName) async {
    final trace = _screenTraces.remove(screenName);
    if (trace != null) {
      await trace.stop();
    }
  }
  
  static Future<void> addScreenMetric(String screenName, String metricName, int value) async {
    final trace = _screenTraces[screenName];
    if (trace != null) {
      trace.setMetric(metricName, value);
    }
  }
}
```

### 16.5 Firebase Configuration

#### 16.5.1 Firebase Options Configuration

```dart
// firebase_options.dart
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web platform not supported');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('Platform not supported');
    }
  }
  
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'your-android-api-key',
    appId: 'your-android-app-id',
    messagingSenderId: 'your-sender-id',
    projectId: 'qwiktest-mobile',
    storageBucket: 'qwiktest-mobile.appspot.com',
  );
  
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'your-ios-api-key',
    appId: 'your-ios-app-id',
    messagingSenderId: 'your-sender-id',
    projectId: 'qwiktest-mobile',
    storageBucket: 'qwiktest-mobile.appspot.com',
    iosBundleId: 'com.qwiktest.mobile',
  );
}
```

#### 16.5.2 Firebase Initialization in Main App

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
  
  // Initialize FCM
  final fcmService = getIt<FCMService>();
  await fcmService.initializeFCM();
  
  runApp(const QwikTestApp());
}
```

---

## 17. Monitoring and Analytics

### 16.1 API Performance Monitoring

```dart
class PerformanceInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['start_time'] = DateTime.now();
    handler.next(options);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['start_time'] as DateTime;
    final duration = DateTime.now().difference(startTime);
    
    // Log performance metrics
    FirebasePerformance.instance
        .newHttpMetric(response.requestOptions.uri.toString(), 
                      HttpMethod.values.byName(response.requestOptions.method.toLowerCase()))
        .then((metric) async {
      metric.responseContentType = response.headers.value('content-type');
      metric.httpResponseCode = response.statusCode;
      metric.responsePayloadSize = response.data.toString().length;
      
      await metric.start();
      await Future.delayed(duration);
      await metric.stop();
    });
    
    handler.next(response);
  }
}
```

### 16.2 Error Tracking

```dart
class ErrorTrackingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Track API errors
    FirebaseCrashlytics.instance.recordError(
      err,
      err.stackTrace,
      reason: 'API Error: ${err.requestOptions.path}',
      information: [
        'Method: ${err.requestOptions.method}',
        'Status Code: ${err.response?.statusCode}',
        'Response: ${err.response?.data}',
      ],
    );
    
    handler.next(err);
  }
}
```

---

## 17. Implementation Checklist

### 17.1 Development Phase

- [ ] Set up Dio client with base configuration
- [ ] Implement authentication interceptor
- [ ] Create error handling interceptor
- [ ] Set up caching interceptor
- [ ] Implement all data sources
- [ ] Create repository implementations
- [ ] Set up offline storage (Hive + Drift)
- [ ] Implement sync manager
- [ ] Add performance monitoring
- [ ] Write unit tests for all components
- [ ] Write integration tests

### 17.2 Testing Phase

- [ ] Test all API endpoints
- [ ] Verify error handling scenarios
- [ ] Test offline functionality
- [ ] Verify data synchronization
- [ ] Test authentication flow
- [ ] Performance testing
- [ ] Security testing
- [ ] Accessibility testing

### 17.3 Production Readiness

- [ ] Configure production API endpoints
- [ ] Set up certificate pinning
- [ ] Enable crash reporting
- [ ] Configure analytics
- [ ] Set up monitoring dashboards
- [ ] Prepare rollback procedures
- [ ] Document troubleshooting guides

---

**Document Version**: 1.0  
**Last Updated**: January 2024  
**Next Review**: March 2024  
**Approved By**: Development Team