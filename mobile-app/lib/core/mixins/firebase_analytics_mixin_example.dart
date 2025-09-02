import 'package:flutter/material.dart';
import 'firebase_analytics_mixin.dart';

/// Example usage of FirebaseAnalyticsMixin with StatefulWidget
/// 
/// This demonstrates how to integrate Firebase Analytics tracking
/// into a typical app page with automatic screen view tracking
/// and manual event tracking for user interactions.
class ExamplePageWithAnalytics extends StatefulWidget {
  const ExamplePageWithAnalytics({super.key});
  
  @override
  State<ExamplePageWithAnalytics> createState() => _ExamplePageWithAnalyticsState();
}

class _ExamplePageWithAnalyticsState extends State<ExamplePageWithAnalytics> 
    with FirebaseAnalyticsMixin {
  
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  
  /// Override the screen name for analytics
  @override
  String get screenName => 'example_page';
  
  /// Add custom screen parameters
  @override
  Map<String, Object>? get screenParameters => {
    'page_type': 'example',
    'feature_flag': 'analytics_demo',
  };
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              // Track search button tap
              await trackButtonTap('search_button');
              _showSearchDialog();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Firebase Analytics Demo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onChanged: (value) {
                  // Track user interaction
                  trackUserInteraction('text_input', targetElement: 'name_field');
                },
              ),
              const SizedBox(height: 16),
              
              // Email field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onChanged: (value) {
                  // Track user interaction
                  trackUserInteraction('text_input', targetElement: 'email_field');
                },
              ),
              const SizedBox(height: 24),
              
              // Submit button
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit Form'),
              ),
              const SizedBox(height: 16),
              
              // Feature buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        await trackFeatureUsage('content_view', action: 'view_tutorial');
                        _viewContent('tutorial');
                      },
                      child: const Text('View Tutorial'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        await trackFeatureUsage('content_view', action: 'view_help');
                        _viewContent('help');
                      },
                      child: const Text('Help'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Navigation button
              ElevatedButton.icon(
                onPressed: () async {
                  await trackNavigation('settings_page');
                  Navigator.pushNamed(context, '/settings');
                },
                icon: const Icon(Icons.settings),
                label: const Text('Go to Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _submitForm() async {
    try {
      if (_formKey.currentState!.validate()) {
        // Track successful form submission
        await trackFormSubmission('user_info_form', 
          success: true,
          additionalParameters: {
            'has_name': _nameController.text.isNotEmpty,
            'has_email': _emailController.text.isNotEmpty,
          },
        );
        
        // Set user properties
        await setUserProperty('has_completed_form', 'true');
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form submitted successfully!')),
        );
        
        // Clear form
        _nameController.clear();
        _emailController.clear();
      } else {
        // Track failed form submission
        await trackFormSubmission('user_info_form', 
          success: false,
          errorMessage: 'validation_failed',
        );
      }
    } catch (e) {
      // Track error
      await trackError('form_submission_error', e.toString());
      
      // Track failed form submission
      await trackFormSubmission('user_info_form', 
        success: false,
        errorMessage: 'submission_error',
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter search query...',
          ),
          onSubmitted: (query) async {
            Navigator.pop(context);
            // Track search event
            await trackSearch(query, 
              resultCount: 5, // Mock result count
              category: 'general',
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
  
  void _viewContent(String contentType) async {
    // Track content view
    await trackContentView(
      contentType,
      '${contentType}_001',
      contentTitle: contentType == 'tutorial' ? 'Getting Started' : 'Help Guide',
      category: 'educational',
    );
    
    // Navigate to content (mock)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing $contentType content')),
    );
  }
}

/// Example usage of FirebaseAnalyticsStatelessMixin
/// 
/// This demonstrates how to add analytics to a StatelessWidget
/// with manual tracking calls.
class ExampleStatelessWidget extends StatelessWidget 
    with FirebaseAnalyticsStatelessMixin {
  
  const ExampleStatelessWidget({super.key});
  
  @override
  String get screenName => 'example_stateless';
  
  @override
  Map<String, Object>? get screenParameters => {
    'widget_type': 'stateless',
    'demo_mode': true,
  };
  
  @override
  Widget build(BuildContext context) {
    // Manually track screen view since StatelessWidget doesn't have lifecycle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      trackScreenView();
    });
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateless Analytics Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Stateless Widget with Analytics',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await trackButtonTap('demo_button');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Button tapped!')),
                );
              },
              child: const Text('Track Button Tap'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () async {
                await trackCustomEvent('custom_action', parameters: {
                  'action_type': 'demo',
                  'widget_source': 'stateless_example',
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Custom event tracked!')),
                );
              },
              child: const Text('Track Custom Event'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example using AnalyticsWrapper for existing widgets
/// 
/// This shows how to add analytics to widgets without modifying their code.
class ExampleWithWrapper extends StatelessWidget {
  const ExampleWithWrapper({super.key});
  
  @override
  Widget build(BuildContext context) {
    return AnalyticsWrapper(
      screenName: 'wrapped_example',
      screenParameters: {
        'wrapper_demo': true,
        'auto_tracking': true,
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wrapped Widget Example'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'This widget is wrapped with AnalyticsWrapper',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Screen views and timing are tracked automatically!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Example using context extension methods
/// 
/// This demonstrates how to use the BuildContext extension
/// for quick analytics tracking from anywhere.
class ExampleWithContextExtension extends StatelessWidget {
  const ExampleWithContextExtension({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Context Extension Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Using Context Extension Methods',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Use context extension to track events
                await context.trackButtonTap('context_button');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tracked via context extension!')),
                );
              },
              child: const Text('Track via Context'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () async {
                // Track screen view manually
                await context.trackScreenView('manual_screen_view', parameters: {
                  'triggered_by': 'button_press',
                  'timestamp': DateTime.now().millisecondsSinceEpoch,
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Manual screen view tracked!')),
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