# QwikTest Mobile App - Development Guidelines

## 1. Overview

This document establishes comprehensive development guidelines, coding standards, and best practices for the QwikTest Flutter mobile application. These guidelines ensure code quality, maintainability, and team collaboration efficiency.

### 1.1 Development Principles

- **Clean Architecture**: Maintain clear separation of concerns
- **SOLID Principles**: Follow object-oriented design principles
- **DRY (Don't Repeat Yourself)**: Avoid code duplication
- **KISS (Keep It Simple, Stupid)**: Prefer simple solutions
- **YAGNI (You Aren't Gonna Need It)**: Don't over-engineer
- **Test-Driven Development**: Write tests first when possible

### 1.2 Code Quality Standards

- **Readability**: Code should be self-documenting
- **Consistency**: Follow established patterns throughout the codebase
- **Performance**: Optimize for mobile device constraints
- **Security**: Implement secure coding practices
- **Accessibility**: Ensure app is accessible to all users

---

## 2. Project Structure

### 2.1 Folder Organization

```
lib/
├── core/                     # Core functionality
│   ├── constants/           # App constants
│   ├── errors/              # Error handling
│   ├── network/             # Network configuration
│   ├── storage/             # Local storage
│   ├── theme/               # App theming
│   ├── utils/               # Utility functions
│   └── widgets/             # Reusable widgets
├── features/                # Feature modules
│   ├── authentication/      # Auth feature
│   │   ├── data/           # Data layer
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/         # Domain layer
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/   # Presentation layer
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   ├── dashboard/
│   ├── exams/
│   ├── profile/
│   └── settings/
├── shared/                  # Shared components
│   ├── data/
│   ├── domain/
│   └── presentation/
└── main.dart               # App entry point
```

### 2.2 File Naming Conventions

- **Files**: Use snake_case (e.g., `user_profile_page.dart`)
- **Classes**: Use PascalCase (e.g., `UserProfilePage`)
- **Variables/Functions**: Use camelCase (e.g., `getUserProfile`)
- **Constants**: Use SCREAMING_SNAKE_CASE (e.g., `API_BASE_URL`)
- **Private members**: Prefix with underscore (e.g., `_privateMethod`)

### 2.3 Import Organization

```dart
// 1. Dart core libraries
import 'dart:async';
import 'dart:convert';

// 2. Flutter libraries
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Third-party packages
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

// 4. Internal imports (relative)
import '../../../core/errors/failures.dart';
import '../domain/entities/user.dart';
import 'user_model.dart';
```

---

## 3. Coding Standards

### 3.1 Dart/Flutter Best Practices

#### 3.1.0 Flutter 3.35+ Specific Features

##### Material 3 Design System

```dart
// Use Material 3 theming
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6750A4),
        brightness: Brightness.light,
      ),
      // Enhanced Material 3 components
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6750A4),
        brightness: Brightness.dark,
      ),
    );
  }
}
```

##### Enhanced Widget Performance

```dart
// Use RepaintBoundary for expensive widgets
class OptimizedExamCard extends StatelessWidget {
  final Exam exam;
  
  const OptimizedExamCard({super.key, required this.exam});
  
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card.filled(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exam.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                exam.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

##### Improved Navigation with Go Router

```dart
// Use GoRouter for type-safe navigation
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: '/exam/:examId',
          builder: (context, state) {
            final examId = state.pathParameters['examId']!;
            return ExamPage(examId: examId);
          },
        ),
      ],
    ),
  ],
);

// Usage in widgets
class ExamListItem extends StatelessWidget {
  final Exam exam;
  
  const ExamListItem({super.key, required this.exam});
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(exam.title),
      onTap: () => context.go('/exam/${exam.id}'),
    );
  }
}
```

#### 3.1.1 Class Structure

```dart
class ExampleWidget extends StatefulWidget {
  // 1. Static constants
  static const String routeName = '/example';
  
  // 2. Final fields (constructor parameters)
  final String title;
  final VoidCallback? onPressed;
  
  // 3. Constructor
  const ExampleWidget({
    Key? key,
    required this.title,
    this.onPressed,
  }) : super(key: key);
  
  // 4. Overridden methods
  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  // 1. Private fields
  late final TextEditingController _controller;
  bool _isLoading = false;
  
  // 2. Lifecycle methods
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  // 3. Build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _buildBody(),
    );
  }
  
  // 4. Private helper methods
  Widget _buildBody() {
    return Column(
      children: [
        _buildTextField(),
        _buildSubmitButton(),
      ],
    );
  }
  
  Widget _buildTextField() {
    return TextField(
      controller: _controller,
      decoration: const InputDecoration(
        labelText: 'Enter text',
      ),
    );
  }
  
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleSubmit,
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text('Submit'),
    );
  }
  
  // 5. Event handlers
  Future<void> _handleSubmit() async {
    setState(() => _isLoading = true);
    
    try {
      // Handle submission
      await _submitData();
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  Future<void> _submitData() async {
    // Implementation
  }
  
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
```

#### 3.1.2 Widget Composition

```dart
// ✅ Good: Break down complex widgets
class UserProfileCard extends StatelessWidget {
  final User user;
  
  const UserProfileCard({Key? key, required this.user}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildStats(),
            const SizedBox(height: 12),
            _buildActions(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Row(
      children: [
        UserAvatar(user: user),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user.email,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildStats() {
    return UserStatsRow(stats: user.stats);
  }
  
  Widget _buildActions() {
    return UserActionButtons(user: user);
  }
}

// ❌ Bad: Monolithic widget
class BadUserProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 100+ lines of nested widgets...
          ],
        ),
      ),
    );
  }
}
```

### 3.2 State Management (BLoC Pattern)

#### 3.2.1 BLoC Structure

```dart
// Event
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  
  const LoginRequested({
    required this.email,
    required this.password,
  });
  
  @override
  List<Object> get props => [email, password];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

// State
abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final User user;
  
  const AuthAuthenticated({required this.user});
  
  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  
  const AuthError({required this.message});
  
  @override
  List<Object> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  
  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
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
  
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logoutUseCase(NoParams());
    emit(const AuthUnauthenticated());
  }
}
```

#### 3.2.2 BLoC Usage in Widgets

```dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacementNamed('/dashboard');
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return const LoginForm();
        },
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);
  
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(LoginRequested(
        email: _emailController.text,
        password: _passwordController.text,
      ));
    }
  }
}
```

### 3.3 Error Handling

#### 3.3.1 Custom Exceptions

```dart
// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? code;
  
  const AppException(this.message, [this.code]);
  
  @override
  String toString() => 'AppException: $message';
}

// Specific exceptions
class NetworkException extends AppException {
  const NetworkException([String message = 'Network error occurred'])
      : super(message, 'NETWORK_ERROR');
}

class AuthException extends AppException {
  const AuthException([String message = 'Authentication failed'])
      : super(message, 'AUTH_ERROR');
}

class ValidationException extends AppException {
  final Map<String, String> errors;
  
  const ValidationException(this.errors)
      : super('Validation failed', 'VALIDATION_ERROR');
}

class ServerException extends AppException {
  final int statusCode;
  
  const ServerException(this.statusCode, [String? message])
      : super(message ?? 'Server error occurred', 'SERVER_ERROR');
}
```

#### 3.3.2 Error Handling in Use Cases

```dart
class LoginUseCase {
  final AuthRepository _repository;
  
  LoginUseCase(this._repository);
  
  Future<Either<Failure, User>> call(LoginParams params) async {
    try {
      // Validate input
      if (params.email.isEmpty) {
        return const Left(ValidationFailure('Email is required'));
      }
      
      if (params.password.isEmpty) {
        return const Left(ValidationFailure('Password is required'));
      }
      
      // Call repository
      final user = await _repository.login(
        email: params.email,
        password: params.password,
      );
      
      return Right(user);
      
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
```

### 3.4 Dart 3.6+ Language Features

#### 3.4.1 Records and Pattern Matching

```dart
// Use records for multiple return values
typedef ExamResult = ({int score, String grade, bool passed});

class ExamService {
  ExamResult calculateResult(List<Answer> answers) {
    final score = _calculateScore(answers);
    final grade = _calculateGrade(score);
    final passed = score >= 60;
    
    return (score: score, grade: grade, passed: passed);
  }
  
  // Pattern matching with switch expressions
  String getResultMessage(ExamResult result) {
    return switch (result) {
      (passed: true, grade: 'A') => 'Excellent work!',
      (passed: true, grade: 'B') => 'Good job!',
      (passed: true, grade: 'C') => 'Well done!',
      (passed: false, :final score) => 'Try again! Score: $score',
    };
  }
}
```

#### 3.4.2 Enhanced Enums

```dart
// Enhanced enums with methods and properties
enum ExamDifficulty {
  easy(multiplier: 1.0, color: Colors.green),
  medium(multiplier: 1.5, color: Colors.orange),
  hard(multiplier: 2.0, color: Colors.red);
  
  const ExamDifficulty({
    required this.multiplier,
    required this.color,
  });
  
  final double multiplier;
  final Color color;
  
  int calculatePoints(int basePoints) {
    return (basePoints * multiplier).round();
  }
  
  String get displayName {
    return switch (this) {
      ExamDifficulty.easy => 'Easy',
      ExamDifficulty.medium => 'Medium',
      ExamDifficulty.hard => 'Hard',
    };
  }
}
```

#### 3.4.3 Sealed Classes for State Management

```dart
// Use sealed classes for exhaustive pattern matching
sealed class ExamState {}

final class ExamInitial extends ExamState {}

final class ExamLoading extends ExamState {
  final String? message;
  ExamLoading([this.message]);
}

final class ExamLoaded extends ExamState {
  final List<Exam> exams;
  final bool hasMore;
  
  ExamLoaded(this.exams, {this.hasMore = false});
}

final class ExamError extends ExamState {
  final String message;
  final Exception? exception;
  
  ExamError(this.message, [this.exception]);
}

// Usage in BLoC
class ExamBloc extends Bloc<ExamEvent, ExamState> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamBloc, ExamState>(
      builder: (context, state) {
        return switch (state) {
          ExamInitial() => const Center(child: Text('Welcome')),
          ExamLoading(:final message) => LoadingWidget(message: message),
          ExamLoaded(:final exams, :final hasMore) => ExamList(
            exams: exams,
            hasMore: hasMore,
          ),
          ExamError(:final message) => ErrorWidget(message),
        };
      },
    );
  }
}
```

### 3.5 Testing Guidelines

#### 3.5.1 Unit Tests

```dart
// test/features/auth/domain/usecases/login_usecase_test.dart
void main() {
  group('LoginUseCase', () {
    late LoginUseCase useCase;
    late MockAuthRepository mockRepository;
    
    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = LoginUseCase(mockRepository);
    });
    
    group('call', () {
      const tEmail = 'test@example.com';
      const tPassword = 'password123';
      const tUser = User(
        id: '1',
        name: 'Test User',
        email: tEmail,
      );
      
      test('should return User when login is successful', () async {
        // Arrange
        when(() => mockRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => tUser);
        
        // Act
        final result = await useCase(const LoginParams(
          email: tEmail,
          password: tPassword,
        ));
        
        // Assert
        expect(result, const Right(tUser));
        verify(() => mockRepository.login(
          email: tEmail,
          password: tPassword,
        ));
        verifyNoMoreInteractions(mockRepository);
      });
      
      test('should return AuthFailure when credentials are invalid', () async {
        // Arrange
        when(() => mockRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(const AuthException('Invalid credentials'));
        
        // Act
        final result = await useCase(const LoginParams(
          email: tEmail,
          password: tPassword,
        ));
        
        // Assert
        expect(result, const Left(AuthFailure('Invalid credentials')));
      });
      
      test('should return ValidationFailure when email is empty', () async {
        // Act
        final result = await useCase(const LoginParams(
          email: '',
          password: tPassword,
        ));
        
        // Assert
        expect(result, const Left(ValidationFailure('Email is required')));
        verifyZeroInteractions(mockRepository);
      });
    });
  });
}
```

#### 3.4.2 Widget Tests

```dart
// test/features/auth/presentation/pages/login_page_test.dart
void main() {
  group('LoginPage', () {
    late MockAuthBloc mockAuthBloc;
    
    setUp(() {
      mockAuthBloc = MockAuthBloc();
    });
    
    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: LoginPage(),
        ),
      );
    }
    
    testWidgets('should display login form when state is initial', (tester) async {
      // Arrange
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Assert
      expect(find.byType(LoginForm), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });
    
    testWidgets('should display loading indicator when state is loading', (tester) async {
      // Arrange
      when(() => mockAuthBloc.state).thenReturn(const AuthLoading());
      
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(LoginForm), findsNothing);
    });
    
    testWidgets('should trigger LoginRequested event when login button is pressed', (tester) async {
      // Arrange
      when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
      
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Login'));
      
      // Assert
      verify(() => mockAuthBloc.add(const LoginRequested(
        email: 'test@example.com',
        password: 'password123',
      )));
    });
  });
}
```

---

## 4. Performance Guidelines

### 4.1 Widget Performance

#### 4.1.1 Use const Constructors

```dart
// ✅ Good: Use const constructors
class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Hello'),
        SizedBox(height: 16),
        Text('World'),
      ],
    );
  }
}

// ❌ Bad: Missing const
class BadWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Hello'),
        SizedBox(height: 16),
        Text('World'),
      ],
    );
  }
}
```

#### 4.1.2 Optimize ListView Performance

```dart
// ✅ Good: Use ListView.builder for large lists
class ExamListView extends StatelessWidget {
  final List<Exam> exams;
  
  const ExamListView({Key? key, required this.exams}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: exams.length,
      itemBuilder: (context, index) {
        return ExamListItem(exam: exams[index]);
      },
    );
  }
}

// ❌ Bad: Creating all widgets at once
class BadExamListView extends StatelessWidget {
  final List<Exam> exams;
  
  const BadExamListView({Key? key, required this.exams}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: exams.map((exam) => ExamListItem(exam: exam)).toList(),
    );
  }
}
```

#### 4.1.3 Image Optimization

```dart
class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  
  const OptimizedImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(Icons.error),
      ),
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
    );
  }
}
```

### 4.2 Memory Management

#### 4.2.1 Dispose Resources

```dart
class ResourcefulWidget extends StatefulWidget {
  @override
  State<ResourcefulWidget> createState() => _ResourcefulWidgetState();
}

class _ResourcefulWidgetState extends State<ResourcefulWidget> {
  late final TextEditingController _controller;
  late final AnimationController _animationController;
  StreamSubscription? _subscription;
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _subscription = someStream.listen(_handleData);
    _timer = Timer.periodic(const Duration(seconds: 1), _handleTimer);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    _subscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }
  
  void _handleData(dynamic data) {
    // Handle stream data
  }
  
  void _handleTimer(Timer timer) {
    // Handle timer tick
  }
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

---

## 5. Security Guidelines

### 5.1 Data Protection

#### 5.1.1 Secure Storage

```dart
class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: IOSAccessibility.first_unlock_this_device,
    ),
  );
  
  static Future<void> storeToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
  
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
  
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }
  
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
```

#### 5.1.2 Input Validation

```dart
class ValidationUtils {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, and number';
    }
    
    return null;
  }
  
  static String sanitizeInput(String input) {
    return input
        .replaceAll(RegExp(r'[<>"\'\/]'), '')
        .trim();
  }
}
```

### 5.2 Network Security

#### 5.2.1 Certificate Pinning

```dart
class SecureHttpClient {
  static Dio createSecureDio() {
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
  
  static bool _verifyCertificate(X509Certificate cert, String host) {
    // Verify against pinned certificates
    const pinnedCertificates = [
      'sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
      'sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=',
    ];
    
    final certSha256 = sha256.convert(cert.der).toString();
    return pinnedCertificates.contains('sha256/$certSha256');
  }
}
```

---

## 6. Accessibility Guidelines

### 6.1 Semantic Labels

```dart
class AccessibleButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  
  const AccessibleButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.semanticLabel,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? text,
      button: true,
      enabled: onPressed != null,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
```

### 6.2 Focus Management

```dart
class AccessibleForm extends StatefulWidget {
  @override
  State<AccessibleForm> createState() => _AccessibleFormState();
}

class _AccessibleFormState extends State<AccessibleForm> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _submitFocusNode = FocusNode();
  
  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _submitFocusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          focusNode: _emailFocusNode,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email address',
          ),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
        ),
        TextFormField(
          focusNode: _passwordFocusNode,
          decoration: const InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
          ),
          obscureText: true,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_submitFocusNode);
          },
        ),
        ElevatedButton(
          focusNode: _submitFocusNode,
          onPressed: _handleSubmit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
  
  void _handleSubmit() {
    // Handle form submission
  }
}
```

---

## 7. Code Review Guidelines

### 7.1 Review Checklist

#### 7.1.1 Code Quality
- [ ] Code follows established naming conventions
- [ ] Functions and classes have single responsibility
- [ ] Code is properly documented with comments
- [ ] No hardcoded values (use constants)
- [ ] Error handling is implemented
- [ ] Resources are properly disposed

#### 7.1.2 Performance
- [ ] Widgets use const constructors where possible
- [ ] Large lists use ListView.builder
- [ ] Images are optimized and cached
- [ ] Unnecessary rebuilds are avoided
- [ ] Memory leaks are prevented

#### 7.1.3 Security
- [ ] User input is validated and sanitized
- [ ] Sensitive data is stored securely
- [ ] Network requests use HTTPS
- [ ] Authentication tokens are handled securely

#### 7.1.4 Testing
- [ ] Unit tests cover business logic
- [ ] Widget tests cover UI components
- [ ] Integration tests cover critical flows
- [ ] Test coverage is adequate (>80%)

### 7.2 Review Process

1. **Self Review**: Developer reviews their own code before creating PR
2. **Automated Checks**: CI/CD pipeline runs tests and linting
3. **Peer Review**: At least one team member reviews the code
4. **Testing**: QA team tests the feature
5. **Approval**: Tech lead approves the changes
6. **Merge**: Code is merged to main branch

---

## 8. Git Workflow

### 8.1 Branch Naming

- **Feature branches**: `feature/auth-login-page`
- **Bug fixes**: `bugfix/exam-timer-issue`
- **Hotfixes**: `hotfix/critical-crash-fix`
- **Release branches**: `release/v1.2.0`

### 8.2 Commit Messages

```
type(scope): description

[optional body]

[optional footer]
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples**:
```
feat(auth): add secure authentication

Implement secure authentication for iOS and Android.
Includes fallback to PIN/password when primary auth is not available.

Closes #123
```

```
fix(exam): resolve timer not stopping on submission

The exam timer was continuing to run after submission, causing
incorrect time calculations in results.

Fixes #456
```

### 8.3 Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Widget tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Screenshots
(If applicable)

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings introduced
```

---

## 9. Documentation Standards

### 9.1 Code Documentation

```dart
/// Service for managing user authentication.
/// 
/// This service handles login, logout, token refresh, and user session
/// management. It integrates with the backend API and local secure storage.
/// 
/// Example usage:
/// ```dart
/// final authService = AuthService();
/// final user = await authService.login('email@example.com', 'password');
/// ```
class AuthService {
  /// The HTTP client used for API requests.
  final Dio _dio;
  
  /// Secure storage for authentication tokens.
  final FlutterSecureStorage _secureStorage;
  
  /// Creates an [AuthService] with the provided dependencies.
  /// 
  /// The [dio] client should be configured with the base URL and
  /// appropriate interceptors.
  AuthService({
    required Dio dio,
    required FlutterSecureStorage secureStorage,
  }) : _dio = dio,
       _secureStorage = secureStorage;
  
  /// Authenticates a user with email and password.
  /// 
  /// Returns the authenticated [User] on success.
  /// Throws [AuthException] if credentials are invalid.
  /// Throws [NetworkException] if network request fails.
  /// 
  /// Parameters:
  /// - [email]: User's email address
  /// - [password]: User's password
  /// 
  /// Example:
  /// ```dart
  /// try {
  ///   final user = await authService.login('user@example.com', 'password123');
  ///   print('Welcome ${user.name}!');
  /// } on AuthException catch (e) {
  ///   print('Login failed: ${e.message}');
  /// }
  /// ```
  Future<User> login(String email, String password) async {
    // Implementation
  }
}
```

### 9.2 README Structure

```markdown
# QwikTest Mobile App

A Flutter mobile application for online exam taking and learning.

## Features

- User authentication with secure login
- Offline exam taking capability
- Real-time progress tracking
- Social learning features
- Dark mode support

## Getting Started

### Prerequisites

- Flutter SDK (>=3.35.0)
- Dart SDK (>=3.6.0)
- Android Studio / Xcode
- Git

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/company/qwiktest-mobile.git
   cd qwiktest-mobile
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/           # Core functionality
├── features/       # Feature modules
├── shared/         # Shared components
└── main.dart       # App entry point
```

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```

---

## 10. Continuous Integration

### 10.1 GitHub Actions Workflow

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.35.0'
        
    - name: Install dependencies
      run: flutter pub get
      
    - name: Verify formatting
      run: dart format --output=none --set-exit-if-changed .
      
    - name: Analyze project source
      run: dart analyze
      
    - name: Run tests
      run: flutter test --coverage
      
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        file: coverage/lcov.info
        
  build:
    needs: test
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        
    - name: Install dependencies
      run: flutter pub get
      
    - name: Build APK
      run: flutter build apk --release
      
    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: release-apk
        path: build/app/outputs/flutter-apk/app-release.apk
```

### 10.2 Quality Gates

- **Code Coverage**: Minimum 80%
- **Linting**: Zero warnings/errors
- **Tests**: All tests must pass
- **Build**: Successful build for all platforms
- **Security**: No high/critical vulnerabilities

---

## 11. Deployment Guidelines

### 11.1 Environment Configuration

```dart
// lib/core/config/app_config.dart
class AppConfig {
  static const String _environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );
  
  static bool get isDevelopment => _environment == 'development';
  static bool get isStaging => _environment == 'staging';
  static bool get isProduction => _environment == 'production';
  
  static String get apiBaseUrl {
    switch (_environment) {
      case 'production':
        return 'https://api.qwiktest.com';
      case 'staging':
        return 'https://staging-api.qwiktest.com';
      default:
        return 'https://dev-api.qwiktest.com';
    }
  }
  
  static String get appName {
    switch (_environment) {
      case 'production':
        return 'QwikTest';
      case 'staging':
        return 'QwikTest Staging';
      default:
        return 'QwikTest Dev';
    }
  }
}
```

### 11.2 Build Commands

```bash
# Development build
flutter build apk --debug --dart-define=ENVIRONMENT=development

# Staging build
flutter build apk --release --dart-define=ENVIRONMENT=staging

# Production build
flutter build apk --release --dart-define=ENVIRONMENT=production
flutter build ios --release --dart-define=ENVIRONMENT=production
```

---

**Document Version**: 1.0  
**Last Updated**: January 2024  
**Next Review**: March 2024  
**Approved By**: Development Team