# Firebase Analytics Mixin

A comprehensive Flutter mixin that provides easy integration of Firebase Analytics into your widgets with automatic screen tracking, event logging, and user property management.

## Features

- 🚀 **Automatic Screen View Tracking**: Automatically tracks screen views when widgets are initialized
- ⏱️ **Screen Time Measurement**: Measures and tracks how long users spend on each screen
- 🎯 **Event Tracking**: Helper methods for common analytics events (button taps, form submissions, navigation, etc.)
- 👤 **User Properties**: Easy management of user properties for segmentation
- 🔧 **Flexible Integration**: Works with both StatefulWidget and StatelessWidget
- 📦 **Context Extensions**: Track events from anywhere using BuildContext extensions
- 🎁 **Wrapper Widget**: Add analytics to existing widgets without code modification

## Installation

Ensure you have Firebase Analytics configured in your Flutter project:

```yaml
dependencies:
  firebase_analytics: ^10.7.4
  firebase_core: ^2.24.2
```

## Quick Start

### 1. StatefulWidget Integration

```dart
import 'package:flutter/material.dart';
import 'firebase_analytics_mixin.dart';

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with FirebaseAnalyticsMixin {
  @override
  String get screenName => 'my_page';
  
  @override
  Map<String, Object>? get screenParameters => {
    'page_type': 'main',
    'feature_enabled': true,
  };
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Page')),
      body: ElevatedButton(
        onPressed: () async {
          await trackButtonTap('submit_button');
          // Handle button press
        },
        child: Text('Submit'),
      ),
    );
  }
}
```

### 2. StatelessWidget Integration

```dart
class MyStatelessPage extends StatelessWidget with FirebaseAnalyticsStatelessMixin {
  @override
  String get screenName => 'my_stateless_page';
  
  @override
  Widget build(BuildContext context) {
    // Manual screen view tracking for StatelessWidget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      trackScreenView();
    });
    
    return Scaffold(
      body: ElevatedButton(
        onPressed: () => trackButtonTap('action_button'),
        child: Text('Action'),
      ),
    );
  }
}
```

### 3. Using AnalyticsWrapper

```dart
AnalyticsWrapper(
  screenName: 'wrapped_page',
  screenParameters: {'auto_tracking': true},
  child: ExistingWidget(),
)
```

### 4. Context Extensions

```dart
// Track events from anywhere
await context.trackButtonTap('quick_action');
await context.trackScreenView('manual_view');
```

## Available Methods

### Screen Tracking

```dart
// Automatic (StatefulWidget with mixin)
// Screen views are tracked automatically on initState

// Manual
await trackScreenView();
await context.trackScreenView('screen_name', parameters: {...});
```

### Event Tracking

```dart
// Button interactions
await trackButtonTap('button_id', additionalParameters: {...});

// Form submissions
await trackFormSubmission('form_name', 
  success: true, 
  errorMessage: null,
  additionalParameters: {...}
);

// Navigation
await trackNavigation('destination_screen', 
  method: 'button',
  additionalParameters: {...}
);

// Search
await trackSearch('query', 
  resultCount: 10,
  category: 'products'
);

// Content views
await trackContentView('article', 'article_123',
  contentTitle: 'How to Use Analytics',
  category: 'tutorial'
);

// Feature usage
await trackFeatureUsage('export_data', 
  action: 'pdf_export',
  additionalParameters: {...}
);

// User interactions
await trackUserInteraction('swipe', 
  targetElement: 'product_card',
  additionalParameters: {...}
);

// Errors
await trackError('api_error', 'Failed to load data');

// Custom events
await trackCustomEvent('custom_action', parameters: {...});
```

### User Properties

```dart
// Set user properties
await setUserProperty('subscription_type', 'premium');
await setUserProperty('user_level', 'advanced');
```

## Configuration

### Required Overrides

When using the mixin, you must override:

```dart
@override
String get screenName => 'your_screen_name';
```

### Optional Overrides

```dart
// Additional screen parameters
@override
Map<String, Object>? get screenParameters => {
  'feature_flag': 'new_ui',
  'user_segment': 'premium',
};

// Custom screen class (defaults to widget's runtimeType)
@override
String? get screenClass => 'CustomScreenClass';
```

## Best Practices

### 1. Screen Naming Convention

Use consistent, descriptive screen names:

```dart
// Good
'home_dashboard'
'user_profile_edit'
'product_detail_view'

// Avoid
'page1'
'screen'
'widget'
```

### 2. Event Parameters

Include relevant context in event parameters:

```dart
await trackButtonTap('purchase_button', additionalParameters: {
  'product_id': 'abc123',
  'price': 29.99,
  'currency': 'USD',
  'category': 'electronics',
});
```

### 3. Error Tracking

Always track errors with context:

```dart
try {
  // Some operation
} catch (e) {
  await trackError('operation_failed', e.toString());
  // Handle error
}
```

### 4. User Properties

Set user properties for segmentation:

```dart
// On login
await setUserProperty('user_type', 'premium');
await setUserProperty('registration_date', '2024-01-15');

// On feature usage
await setUserProperty('has_used_export', 'true');
```

## Integration with Existing FirebaseService

The mixin integrates seamlessly with your existing `FirebaseService`:

```dart
// The mixin uses your existing service
final firebaseService = getIt<FirebaseService>();
await firebaseService.trackScreenView(screenName, screenClass, parameters);
```

## Performance Considerations

- Screen time tracking uses minimal resources
- Events are queued and batched by Firebase SDK
- Debug mode checks prevent tracking in development
- All tracking calls are non-blocking

## Debugging

Enable debug logging in your `FirebaseService` to see analytics events:

```dart
// In debug mode, events are logged to console
if (kDebugMode) {
  print('Analytics: $eventName with $parameters');
}
```

## Examples

See `firebase_analytics_mixin_example.dart` for comprehensive usage examples including:

- Form tracking with validation
- Search functionality
- Navigation tracking
- Error handling
- Content viewing
- Feature usage tracking

## Migration Guide

### From Manual Tracking

Before:
```dart
class MyPage extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'my_page',
      screenClass: 'MyPage',
    );
  }
}
```

After:
```dart
class _MyPageState extends State<MyPage> with FirebaseAnalyticsMixin {
  @override
  String get screenName => 'my_page';
  
  // Screen view tracking is automatic!
}
```

### From Direct Firebase Calls

Before:
```dart
FirebaseAnalytics.instance.logEvent(
  name: 'button_tap',
  parameters: {'button_id': 'submit'},
);
```

After:
```dart
await trackButtonTap('submit');
```

## Troubleshooting

### Common Issues

1. **Events not appearing in Firebase Console**
   - Check if you're in debug mode (events may be filtered)
   - Verify Firebase configuration
   - Wait up to 24 hours for data to appear

2. **Screen views not tracking**
   - Ensure you've overridden `screenName`
   - For StatelessWidget, call `trackScreenView()` manually
   - Check if `FirebaseService` is properly initialized

3. **Build errors**
   - Ensure you're importing the mixin correctly
   - Verify Firebase dependencies are installed
   - Check that `getIt<FirebaseService>()` is available

### Debug Checklist

- [ ] Firebase project configured
- [ ] Analytics enabled in Firebase Console
- [ ] `FirebaseService` registered with GetIt
- [ ] Screen name overridden
- [ ] Mixin imported correctly
- [ ] App running on physical device (recommended for testing)

## Contributing

When contributing to this mixin:

1. Follow existing code patterns
2. Add comprehensive documentation
3. Include usage examples
4. Test on both Android and iOS
5. Ensure backward compatibility

## License

This mixin is part of your Flutter project and follows your project's license terms.