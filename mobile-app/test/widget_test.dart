import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:get_it/get_it.dart';

import 'package:qwiktest_mobile/core/mixins/firebase_analytics_mixin.dart';
import 'package:qwiktest_mobile/core/services/firebase_service.dart';

import 'core/mixins/firebase_analytics_mixin_test.mocks.dart';

// Generate mocks for widget tests
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
    
    // Setup default mock responses
    when(mockFirebaseService.trackScreenView(
      any,
      parameters: anyNamed('parameters'),
    )).thenAnswer((_) async {});
    
    when(mockFirebaseService.trackEvent(
      any,
      parameters: anyNamed('parameters'),
    )).thenAnswer((_) async {});
    
    when(mockFirebaseService.setUserProperty(
      any,
      any,
    )).thenAnswer((_) async {});
  });

  tearDown(() {
    getIt.reset();
  });

  group('Firebase Analytics Mixin Widget Integration Tests', () {
    testWidgets('Complete user flow with analytics tracking', (WidgetTester tester) async {
      // Build the test app with analytics-enabled widgets
      await tester.pumpWidget(
        MaterialApp(
          home: const AnalyticsTestApp(),
          routes: {
            '/details': (context) => const DetailsPage(),
            '/settings': (context) => const SettingsPage(),
          },
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial screen view tracking
      verify(mockFirebaseService.trackScreenView(
        'home_page',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['screen_class'], 'screen_class', '_AnalyticsTestAppState')
              .having((m) => m['page_type'], 'page_type', 'main'),
          named: 'parameters',
        ),
      )).called(1);

      // Test form interaction
      final nameField = find.byKey(const Key('name_field'));
      await tester.enterText(nameField, 'John Doe');
      await tester.pumpAndSettle();

      // Test button tap tracking
      final submitButton = find.byKey(const Key('submit_button'));
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Verify form submission tracking
      verify(mockFirebaseService.trackEvent(
        'form_submission',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['form_name'], 'form_name', 'user_form')
              .having((m) => m['success'], 'success', true),
          named: 'parameters',
        ),
      )).called(1);

      // Test navigation tracking
      final detailsButton = find.byKey(const Key('details_button'));
      await tester.tap(detailsButton);
      await tester.pumpAndSettle();

      // Verify navigation tracking
      verify(mockFirebaseService.trackEvent(
        'navigation',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['destination'], 'destination', '/details')
              .having((m) => m['method'], 'method', 'button'),
          named: 'parameters',
        ),
      )).called(1);

      // Verify new screen view tracking
      verify(mockFirebaseService.trackScreenView(
        'details_page',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['screen_class'], 'screen_class', '_DetailsPageState'),
          named: 'parameters',
        ),
      )).called(1);
    });

    testWidgets('AnalyticsWrapper integration test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AnalyticsWrapper(
            screenName: 'wrapped_content',
            screenParameters: {
              'wrapper_version': '1.0',
              'auto_tracking': true,
            },
            child: const SimpleContentWidget(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify wrapper screen tracking
      verify(mockFirebaseService.trackScreenView(
        'wrapped_content',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['wrapper_version'], 'wrapper_version', '1.0')
              .having((m) => m['auto_tracking'], 'auto_tracking', true),
          named: 'parameters',
        ),
      )).called(1);

      // Test interaction within wrapped widget
      final actionButton = find.byKey(const Key('action_button'));
      await tester.tap(actionButton);
      await tester.pumpAndSettle();

      // Navigate away to test screen time tracking
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));
      await tester.pumpAndSettle();

      // Verify screen time tracking
      verify(mockFirebaseService.trackEvent(
        'screen_time',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['screen_name'], 'screen_name', 'wrapped_content'),
          named: 'parameters',
        ),
      )).called(1);
    });

    testWidgets('Context extension methods test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ContextExtensionTestWidget(),
        ),
      );
      await tester.pumpAndSettle();

      // Test context extension button tap
      final contextButton = find.byKey(const Key('context_button'));
      await tester.tap(contextButton);
      await tester.pumpAndSettle();

      // Verify context extension tracking
      verify(mockFirebaseService.trackEvent(
        'button_tap',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['button_id'], 'button_id', 'context_test'),
          named: 'parameters',
        ),
      )).called(1);

      // Test manual screen view via context
      final screenViewButton = find.byKey(const Key('screen_view_button'));
      await tester.tap(screenViewButton);
      await tester.pumpAndSettle();

      // Verify manual screen view tracking
      verify(mockFirebaseService.trackScreenView(
        'manual_screen',
        parameters: argThat(
          isA<Map<String, Object>>()
              .having((m) => m['triggered_manually'], 'triggered_manually', true),
          named: 'parameters',
        ),
      )).called(1);
    });

    testWidgets('Error handling and edge cases', (WidgetTester tester) async {
      // Setup mock to throw exception
      when(mockFirebaseService.trackEvent(
        'error_test',
        parameters: anyNamed('parameters'),
      )).thenThrow(Exception('Analytics error'));

      await tester.pumpWidget(
        const MaterialApp(
          home: ErrorTestWidget(),
        ),
      );
      await tester.pumpAndSettle();

      // Test error handling
      final errorButton = find.byKey(const Key('error_button'));
      await tester.tap(errorButton);
      await tester.pumpAndSettle();

      // Verify error was attempted to be tracked
      verify(mockFirebaseService.trackEvent(
        'error_test',
        parameters: anyNamed('parameters'),
      )).called(1);

      // Widget should still function normally despite analytics error
      expect(find.text('Error Test Widget'), findsOneWidget);
    });

    testWidgets('Multiple widgets with different screen names', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PageView(
            children: const [
              FirstAnalyticsPage(),
              SecondAnalyticsPage(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify first page tracking
      verify(mockFirebaseService.trackScreenView(
        'first_page',
        parameters: anyNamed('parameters'),
      )).called(1);

      // Swipe to second page
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      // Verify second page tracking
      verify(mockFirebaseService.trackScreenView(
        'second_page',
        parameters: anyNamed('parameters'),
      )).called(1);
    });
  });
}

// Test widgets for integration testing
class AnalyticsTestApp extends StatefulWidget {
  const AnalyticsTestApp({super.key});

  @override
  State<AnalyticsTestApp> createState() => _AnalyticsTestAppState();
}

class _AnalyticsTestAppState extends State<AnalyticsTestApp>
    with FirebaseAnalyticsMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  String get screenName => 'home_page';

  @override
  Map<String, Object>? get screenParameters => {
    'page_type': 'main',
    'has_form': true,
  };

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const Key('name_field'),
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                key: const Key('submit_button'),
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                key: const Key('details_button'),
                onPressed: () async {
                  await trackNavigation('/details', additionalParameters: {'method': 'button'});
                  Navigator.pushNamed(context, '/details');
                },
                child: const Text('Go to Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await trackFormSubmission(
        'user_form',
        success: true,
        additionalParameters: {
          'field_count': 1,
          'has_name': _nameController.text.isNotEmpty,
        },
      );
      
      await setUserProperty('has_submitted_form', 'true');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted!')),
      );
    } else {
      await trackFormSubmission(
        'user_form',
        success: false,
        errorMessage: 'validation_failed',
      );
    }
  }
}

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with FirebaseAnalyticsMixin {
  @override
  String get screenName => 'details_page';

  @override
  Map<String, Object>? get screenParameters => {
    'page_type': 'detail',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: const Center(
        child: Text('Details Page Content'),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with FirebaseAnalyticsMixin {
  @override
  String get screenName => 'settings_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(
        child: Text('Settings Page Content'),
      ),
    );
  }
}

class SimpleContentWidget extends StatelessWidget {
  const SimpleContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          key: const Key('action_button'),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Action performed')),
            );
          },
          child: const Text('Perform Action'),
        ),
      ),
    );
  }
}

class ContextExtensionTestWidget extends StatelessWidget {
  const ContextExtensionTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              key: const Key('context_button'),
              onPressed: () async {
                await context.trackButtonTap('context_test');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Context tracking!')),
                );
              },
              child: const Text('Track via Context'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              key: const Key('screen_view_button'),
              onPressed: () async {
                await context.trackScreenView('manual_screen', parameters: {
                  'triggered_manually': true,
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Manual screen view!')),
                );
              },
              child: const Text('Manual Screen View'),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorTestWidget extends StatelessWidget with FirebaseAnalyticsStatelessMixin {
  const ErrorTestWidget({super.key});

  @override
  String get screenName => 'error_test';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Error Test Widget'),
            ElevatedButton(
              key: const Key('error_button'),
              onPressed: () async {
                try {
                  await trackCustomEvent('error_test', parameters: {
                    'test_type': 'error_handling',
                  });
                } catch (e) {
                  // Handle analytics error gracefully
                  debugPrint('Analytics error: $e');
                }
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error test completed')),
                );
              },
              child: const Text('Trigger Error Test'),
            ),
          ],
        ),
      ),
    );
  }
}

class FirstAnalyticsPage extends StatefulWidget {
  const FirstAnalyticsPage({super.key});

  @override
  State<FirstAnalyticsPage> createState() => _FirstAnalyticsPageState();
}

class _FirstAnalyticsPageState extends State<FirstAnalyticsPage>
    with FirebaseAnalyticsMixin {
  @override
  String get screenName => 'first_page';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('First Page'),
      ),
    );
  }
}

class SecondAnalyticsPage extends StatefulWidget {
  const SecondAnalyticsPage({super.key});

  @override
  State<SecondAnalyticsPage> createState() => _SecondAnalyticsPageState();
}

class _SecondAnalyticsPageState extends State<SecondAnalyticsPage>
    with FirebaseAnalyticsMixin {
  @override
  String get screenName => 'second_page';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Second Page'),
      ),
    );
  }
}