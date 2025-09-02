import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:get_it/get_it.dart';

import 'package:qwiktest_mobile/core/mixins/firebase_analytics_mixin.dart';
import 'package:qwiktest_mobile/core/services/firebase_service.dart';

import 'firebase_analytics_mixin_test.mocks.dart';

// Generate mocks
@GenerateMocks([FirebaseService])
void main() {
  late MockFirebaseService mockFirebaseService;
  late GetIt getIt;

  setUp(() {
    mockFirebaseService = MockFirebaseService();
    getIt = GetIt.instance;
    
    // Reset GetIt and register mock service
    getIt.reset();
    getIt.registerSingleton<FirebaseService>(mockFirebaseService);
  });

  tearDown(() {
    getIt.reset();
  });

  group('FirebaseAnalyticsMixin', () {
    late TestStatefulWidget testWidget;
    late WidgetTester tester;

    setUp(() {
      testWidget = TestStatefulWidget();
    });

    testWidgets('should track screen view on initState', (WidgetTester tester) async {
      // Arrange
      when(mockFirebaseService.trackScreenView(
        any,
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(MaterialApp(home: testWidget));
      await tester.pumpAndSettle();

      // Assert
      verify(mockFirebaseService.trackScreenView(
        'test_screen',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['screen_class'], 'screen_class', '_TestStatefulWidgetState')
              .having((m) => m['timestamp'], 'timestamp', isA<int>())
              .having((m) => m['test_param'], 'test_param', 'test_value'),
          named: 'parameters',
        ),
      )).called(1);
    });

    testWidgets('should track screen time on dispose', (WidgetTester tester) async {
      // Arrange
      when(mockFirebaseService.trackScreenView(
        any,
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});
      
      when(mockFirebaseService.trackEvent(
        any,
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(MaterialApp(home: testWidget));
      await tester.pumpAndSettle();
      
      // Simulate some time passing
      await tester.pump(const Duration(seconds: 2));
      
      // Navigate away to trigger dispose
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));
      await tester.pumpAndSettle();

      // Assert
      verify(mockFirebaseService.trackEvent(
        'screen_time',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['screen_name'], 'screen_name', 'test_screen')
              .having((m) => m['time_spent_seconds'], 'time_spent_seconds', isA<int>()),
          named: 'parameters',
        ),
      )).called(1);
    });

    testWidgets('should track button tap events', (WidgetTester tester) async {
      // Arrange
      when(mockFirebaseService.trackScreenView(
        any,
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});
      
      when(mockFirebaseService.trackEvent(
        any,
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(MaterialApp(home: testWidget));
      await tester.pumpAndSettle();
      
      // Find and tap the button
      final button = find.byKey(const Key('test_button'));
      expect(button, findsOneWidget);
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Assert
      verify(mockFirebaseService.trackEvent(
        'button_tap',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['button_id'], 'button_id', 'test_button')
              .having((m) => m['screen_name'], 'screen_name', 'test_screen'),
          named: 'parameters',
        ),
      )).called(1);
    });

    test('should track form submission with success', () async {
      // Arrange
      final state = TestStatefulWidgetState();
      when(mockFirebaseService.trackEvent(
        any,
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});

      // Act
      await state.trackFormSubmission(
        'test_form',
        success: true,
        additionalParameters: {'field_count': 3},
      );

      // Assert
      verify(mockFirebaseService.trackEvent(
        'form_submission',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['form_name'], 'form_name', 'test_form')
              .having((m) => m['success'], 'success', true)
              .having((m) => m['field_count'], 'field_count', 3),
          named: 'parameters',
        ),
      )).called(1);
    });

    test('should track form submission with error', () async {
      // Arrange
      final state = TestStatefulWidgetState();
      when(mockFirebaseService.trackEvent(
        any,
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});

      // Act
      await state.trackFormSubmission(
        'test_form',
        success: false,
        errorMessage: 'Validation failed',
      );

      // Assert
      verify(mockFirebaseService.trackEvent(
        'form_submission',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['form_name'], 'form_name', 'test_form')
              .having((m) => m['success'], 'success', false)
              .having((m) => m['error_message'], 'error_message', 'Validation failed'),
          named: 'parameters',
        ),
      )).called(1);
    });

    test('should track navigation events', () async {
      // Arrange
      final state = TestStatefulWidgetState();
      when(mockFirebaseService.trackEvent(
        any,
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});

      // Act
      await state.trackNavigation(
        'settings_page',
        method: 'button',
        additionalParameters: {'source': 'main_menu'},
      );

      // Assert
      verify(mockFirebaseService.trackEvent(
        'navigation',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['destination'], 'destination', 'settings_page')
              .having((m) => m['method'], 'method', 'button')
              .having((m) => m['source'], 'source', 'main_menu'),
          named: 'parameters',
        ),
      )).called(1);
    });

    test('should track search events', () async {
      // Arrange
      final state = TestStatefulWidgetState();
      when(mockFirebaseService.trackEvent(
        any,
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});

      // Act
      await state.trackSearch(
        'flutter analytics',
        resultCount: 15,
        category: 'tutorials',
      );

      // Assert
      verify(mockFirebaseService.trackEvent(
        'search',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['query'], 'query', 'flutter analytics')
              .having((m) => m['result_count'], 'result_count', 15)
              .having((m) => m['category'], 'category', 'tutorials'),
          named: 'parameters',
        ),
      )).called(1);
    });

    test('should track content view events', () async {
      // Arrange
      final state = TestStatefulWidgetState();
      when(mockFirebaseService.trackEvent(
        any,
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});

      // Act
      await state.trackContentView(
        'article',
        'article_123',
        contentTitle: 'Firebase Analytics Guide',
        category: 'tutorial',
      );

      // Assert
      verify(mockFirebaseService.trackEvent(
        'content_view',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['content_type'], 'content_type', 'article')
              .having((m) => m['content_id'], 'content_id', 'article_123')
              .having((m) => m['content_title'], 'content_title', 'Firebase Analytics Guide')
              .having((m) => m['category'], 'category', 'tutorial'),
          named: 'parameters',
        ),
      )).called(1);
    });

    test('should track error events', () async {
      // Arrange
      final state = TestStatefulWidgetState();
      when(mockFirebaseService.trackEvent(
        any,
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});

      // Act
      await state.trackError(
        'api_error',
        'Failed to load data',
        errorCode: '500',
      );

      // Assert
      verify(mockFirebaseService.trackEvent(
        'error_occurred',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['error_type'], 'error_type', 'api_error')
              .having((m) => m['error_message'], 'error_message', 'Failed to load data')
              .having((m) => m['error_code'], 'error_code', '500'),
          named: 'parameters',
        ),
      )).called(1);
    });

    test('should set user properties', () async {
      // Arrange
      final state = TestStatefulWidgetState();
      when(mockFirebaseService.setUserProperty(
        any,
        any,
      )).thenAnswer((_) async {});

      // Act
      await state.setUserProperty('subscription_type', 'premium');

      // Assert
      verify(mockFirebaseService.setUserProperty(
        'subscription_type',
        'premium',
      )).called(1);
    });
  });

  group('FirebaseAnalyticsStatelessMixin', () {
    test('should track screen view manually', () async {
      // Arrange
      final widget = TestStatelessWidget();
      when(mockFirebaseService.trackScreenView(
        any,
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});

      // Act
      await widget.trackScreenView();

      // Assert
      verify(mockFirebaseService.trackScreenView(
        'test_stateless_screen',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['screen_class'], 'screen_class', 'TestStatelessWidget')
              .having((m) => m['stateless_param'], 'stateless_param', 'stateless_value'),
          named: 'parameters',
        ),
      )).called(1);
    });

    test('should track custom events', () async {
      // Arrange
      final widget = TestStatelessWidget();
      when(mockFirebaseService.trackEvent(
        any,
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});

      // Act
      await widget.trackCustomEvent('custom_action', parameters: {
        'action_type': 'demo',
        'value': 42,
      });

      // Assert
      verify(mockFirebaseService.trackEvent(
        'custom_action',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['action_type'], 'action_type', 'demo')
              .having((m) => m['value'], 'value', 42)
              .having((m) => m['screen_name'], 'screen_name', 'test_stateless_screen'),
          named: 'parameters',
        ),
      )).called(1);
    });
  });

  group('AnalyticsWrapper', () {
    testWidgets('should track screen view automatically', (WidgetTester tester) async {
      // Arrange
      when(mockFirebaseService.trackScreenView(
        any,
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: AnalyticsWrapper(
            screenName: 'wrapped_screen',
            screenParameters: {'wrapper_test': true},
            child: const Scaffold(
              body: Text('Wrapped Content'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      verify(mockFirebaseService.trackScreenView(
        'wrapped_screen',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['wrapper_test'], 'wrapper_test', true)
              .having((m) => m['screen_class'], 'screen_class', '_AnalyticsWrapperState'),
          named: 'parameters',
        ),
      )).called(1);
    });

    testWidgets('should track screen time on dispose', (WidgetTester tester) async {
      // Arrange
      when(mockFirebaseService.trackScreenView(
        any,
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});
      
      when(mockFirebaseService.trackEvent(
        any,
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: AnalyticsWrapper(
            screenName: 'wrapped_screen',
            child: const Scaffold(body: Text('Content')),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      // Navigate away to trigger dispose
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));
      await tester.pumpAndSettle();

      // Assert
      verify(mockFirebaseService.trackEvent(
        'screen_time',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['screen_name'], 'screen_name', 'wrapped_screen'),
          named: 'parameters',
        ),
      )).called(1);
    });
  });

  group('BuildContext Extensions', () {
    testWidgets('should track events via context extension', (WidgetTester tester) async {
      // Arrange
      when(mockFirebaseService.trackEvent(
        any,
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});

      late BuildContext capturedContext;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const Scaffold(body: Text('Test'));
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await capturedContext.trackButtonTap('context_button');

      // Assert
      verify(mockFirebaseService.trackEvent(
        'button_tap',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['button_id'], 'button_id', 'context_button'),
          named: 'parameters',
        ),
      )).called(1);
    });

    testWidgets('should track screen view via context extension', (WidgetTester tester) async {
      // Arrange
      when(mockFirebaseService.trackScreenView(
        any,
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});

      late BuildContext capturedContext;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const Scaffold(body: Text('Test'));
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await capturedContext.trackScreenView('context_screen', parameters: {
        'manual_tracking': true,
      });

      // Assert
      verify(mockFirebaseService.trackScreenView(
        'context_screen',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['manual_tracking'], 'manual_tracking', true),
          named: 'parameters',
        ),
      )).called(1);
    });
  });
}

// Test widgets for testing the mixin
class TestStatefulWidget extends StatefulWidget {
  const TestStatefulWidget({super.key});

  @override
  State<TestStatefulWidget> createState() => TestStatefulWidgetState();
}

class TestStatefulWidgetState extends State<TestStatefulWidget>
    with FirebaseAnalyticsMixin {
  @override
  String get screenName => 'test_screen';

  @override
  Map<String, Object>? get screenParameters => {
    'test_param': 'test_value',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          key: const Key('test_button'),
          onPressed: () async {
            await trackButtonTap('test_button');
          },
          child: const Text('Test Button'),
        ),
      ),
    );
  }
}

class TestStatelessWidget extends StatelessWidget
    with FirebaseAnalyticsStatelessMixin {
  const TestStatelessWidget({super.key});

  @override
  String get screenName => 'test_stateless_screen';

  @override
  Map<String, Object>? get screenParameters => {
    'stateless_param': 'stateless_value',
  };

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Test Stateless Widget'),
      ),
    );
  }
}