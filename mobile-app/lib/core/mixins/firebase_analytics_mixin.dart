import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../di/service_locator.dart';

/// A mixin that provides Firebase Analytics integration for widgets and pages.
/// 
/// This mixin automatically tracks screen views, provides helper methods for
/// common analytics events, and integrates seamlessly with the existing
/// FirebaseService architecture.
/// 
/// Usage:
/// ```dart
/// class MyPage extends StatefulWidget {
///   @override
///   State<MyPage> createState() => _MyPageState();
/// }
/// 
/// class _MyPageState extends State<MyPage> with FirebaseAnalyticsMixin {
///   @override
///   String get screenName => 'my_page';
///   
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: ElevatedButton(
///         onPressed: () => trackButtonTap('submit_button'),
///         child: Text('Submit'),
///       ),
///     );
///   }
/// }
/// ```
mixin FirebaseAnalyticsMixin<T extends StatefulWidget> on State<T> {
  /// The Firebase service instance
  FirebaseService get _firebaseService => getIt<FirebaseService>();
  
  /// The screen name for analytics tracking.
  /// Override this in your widget to provide a custom screen name.
  String get screenName => runtimeType.toString().toLowerCase().replaceAll('state', '');
  
  /// Additional screen parameters to track with screen views.
  /// Override this to provide custom parameters for the screen.
  Map<String, Object>? get screenParameters => null;
  
  /// Whether to automatically track screen views on initState.
  /// Set to false if you want to manually control screen view tracking.
  bool get autoTrackScreenView => true;
  
  /// Whether to automatically track screen view time.
  /// When enabled, tracks how long users spend on this screen.
  bool get trackScreenTime => true;
  
  DateTime? _screenStartTime;
  
  @override
  void initState() {
    super.initState();
    
    if (autoTrackScreenView) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        trackScreenView();
      });
    }
    
    if (trackScreenTime) {
      _screenStartTime = DateTime.now();
    }
  }
  
  @override
  void dispose() {
    if (trackScreenTime && _screenStartTime != null) {
      final duration = DateTime.now().difference(_screenStartTime!);
      trackScreenTimeSpent(duration);
    }
    super.dispose();
  }
  
  /// Tracks a screen view event
  Future<void> trackScreenView({Map<String, Object>? additionalParameters}) async {
    final parameters = <String, Object>{
      'screen_class': runtimeType.toString(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?screenParameters,
      ...?additionalParameters,
    };
    
    await _firebaseService.trackScreenView(screenName, parameters: parameters);
  }
  
  /// Tracks how long a user spent on this screen
  Future<void> trackScreenTimeSpent(Duration duration) async {
    await _firebaseService.trackEvent('screen_time_spent', parameters: {
      'screen_name': screenName,
      'duration_seconds': duration.inSeconds,
      'duration_minutes': duration.inMinutes,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
  
  /// Tracks a button tap event
  Future<void> trackButtonTap(String buttonName, {Map<String, Object>? additionalParameters}) async {
    await _firebaseService.trackEvent('button_tap', parameters: {
      'button_name': buttonName,
      'screen_name': screenName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?additionalParameters,
    });
  }
  
  /// Tracks a form submission event
  Future<void> trackFormSubmission(String formName, {
    bool? success,
    String? errorMessage,
    Map<String, Object>? additionalParameters,
  }) async {
    await _firebaseService.trackEvent('form_submission', parameters: {
      'form_name': formName,
      'screen_name': screenName,
      'success': success ?? true,
      if (errorMessage != null) 'error_message': errorMessage,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?additionalParameters,
    });
  }
  
  /// Tracks a navigation event
  Future<void> trackNavigation(String destination, {Map<String, Object>? additionalParameters}) async {
    await _firebaseService.trackEvent('navigation', parameters: {
      'from_screen': screenName,
      'to_screen': destination,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?additionalParameters,
    });
  }
  
  /// Tracks a search event
  Future<void> trackSearch(String query, {
    int? resultCount,
    String? category,
    Map<String, Object>? additionalParameters,
  }) async {
    await _firebaseService.trackEvent('search', parameters: {
      'query': query,
      'screen_name': screenName,
      if (resultCount != null) 'result_count': resultCount,
      if (category != null) 'category': category,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?additionalParameters,
    });
  }
  
  /// Tracks a content view event (e.g., viewing an exam, article, etc.)
  Future<void> trackContentView(String contentType, String contentId, {
    String? contentTitle,
    String? category,
    Map<String, Object>? additionalParameters,
  }) async {
    await _firebaseService.trackEvent('content_view', parameters: {
      'content_type': contentType,
      'content_id': contentId,
      'screen_name': screenName,
      if (contentTitle != null) 'content_title': contentTitle,
      if (category != null) 'category': category,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?additionalParameters,
    });
  }
  
  /// Tracks a user interaction event (e.g., swipe, scroll, tap)
  Future<void> trackUserInteraction(String interactionType, {
    String? targetElement,
    Map<String, Object>? additionalParameters,
  }) async {
    await _firebaseService.trackEvent('user_interaction', parameters: {
      'interaction_type': interactionType,
      'screen_name': screenName,
      if (targetElement != null) 'target_element': targetElement,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?additionalParameters,
    });
  }
  
  /// Tracks an error event
  Future<void> trackError(String errorType, String errorMessage, {
    String? errorCode,
    Map<String, Object>? additionalParameters,
  }) async {
    await _firebaseService.trackEvent('error_occurred', parameters: {
      'error_type': errorType,
      'error_message': errorMessage,
      'screen_name': screenName,
      if (errorCode != null) 'error_code': errorCode,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?additionalParameters,
    });
  }
  
  /// Tracks a feature usage event
  Future<void> trackFeatureUsage(String featureName, {
    String? action,
    Map<String, Object>? additionalParameters,
  }) async {
    await _firebaseService.trackEvent('feature_usage', parameters: {
      'feature_name': featureName,
      'screen_name': screenName,
      if (action != null) 'action': action,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?additionalParameters,
    });
  }
  
  /// Sets a user property
  Future<void> setUserProperty(String name, String value) async {
    await _firebaseService.setUserProperty(name, value);
  }
  
  /// Sets the user ID for analytics
  Future<void> setUserId(String userId) async {
    await _firebaseService.setUserId(userId);
  }
  
  /// Tracks a custom event with custom parameters
  Future<void> trackCustomEvent(String eventName, {Map<String, Object>? parameters}) async {
    final eventParameters = {
      'screen_name': screenName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?parameters,
    };
    
    await _firebaseService.trackEvent(eventName, parameters: eventParameters);
  }
}

/// A mixin for StatelessWidget that provides Firebase Analytics integration.
/// 
/// Since StatelessWidget doesn't have lifecycle methods, this mixin provides
/// manual tracking methods that can be called when needed.
/// 
/// Usage:
/// ```dart
/// class MyWidget extends StatelessWidget with FirebaseAnalyticsStatelessMixin {
///   @override
///   String get screenName => 'my_widget';
///   
///   @override
///   Widget build(BuildContext context) {
///     // Manually track screen view when needed
///     WidgetsBinding.instance.addPostFrameCallback((_) {
///       trackScreenView();
///     });
///     
///     return Scaffold(
///       body: ElevatedButton(
///         onPressed: () => trackButtonTap('submit_button'),
///         child: Text('Submit'),
///       ),
///     );
///   }
/// }
/// ```
mixin FirebaseAnalyticsStatelessMixin on StatelessWidget {
  /// The Firebase service instance
  FirebaseService get _firebaseService => getIt<FirebaseService>();
  
  /// The screen name for analytics tracking.
  /// Override this in your widget to provide a custom screen name.
  String get screenName => runtimeType.toString().toLowerCase();
  
  /// Additional screen parameters to track with screen views.
  /// Override this to provide custom parameters for the screen.
  Map<String, Object>? get screenParameters => null;
  
  /// Tracks a screen view event
  Future<void> trackScreenView({Map<String, Object>? additionalParameters}) async {
    final parameters = <String, Object>{
      'screen_class': runtimeType.toString(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?screenParameters,
      ...?additionalParameters,
    };
    
    await _firebaseService.trackScreenView(screenName, parameters: parameters);
  }
  
  /// Tracks a button tap event
  Future<void> trackButtonTap(String buttonName, {Map<String, Object>? additionalParameters}) async {
    await _firebaseService.trackEvent('button_tap', parameters: {
      'button_name': buttonName,
      'screen_name': screenName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?additionalParameters,
    });
  }
  
  /// Tracks a form submission event
  Future<void> trackFormSubmission(String formName, {
    bool? success,
    String? errorMessage,
    Map<String, Object>? additionalParameters,
  }) async {
    await _firebaseService.trackEvent('form_submission', parameters: {
      'form_name': formName,
      'screen_name': screenName,
      'success': success ?? true,
      if (errorMessage != null) 'error_message': errorMessage,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?additionalParameters,
    });
  }
  
  /// Tracks a navigation event
  Future<void> trackNavigation(String destination, {Map<String, Object>? additionalParameters}) async {
    await _firebaseService.trackEvent('navigation', parameters: {
      'from_screen': screenName,
      'to_screen': destination,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?additionalParameters,
    });
  }
  
  /// Tracks a custom event with custom parameters
  Future<void> trackCustomEvent(String eventName, {Map<String, Object>? parameters}) async {
    final eventParameters = {
      'screen_name': screenName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?parameters,
    };
    
    await _firebaseService.trackEvent(eventName, parameters: eventParameters);
  }
  
  /// Sets a user property
  Future<void> setUserProperty(String name, String value) async {
    await _firebaseService.setUserProperty(name, value);
  }
  
  /// Sets the user ID for analytics
  Future<void> setUserId(String userId) async {
    await _firebaseService.setUserId(userId);
  }
}

/// Extension methods for BuildContext to provide easy analytics tracking
/// from anywhere in the widget tree.
extension FirebaseAnalyticsContextExtension on BuildContext {
  /// Gets the Firebase service instance
  FirebaseService get _firebaseService => getIt<FirebaseService>();
  
  /// Tracks a screen view event from context
  Future<void> trackScreenView(String screenName, {Map<String, Object>? parameters}) async {
    final eventParameters = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?parameters,
    };
    
    await _firebaseService.trackScreenView(screenName, parameters: eventParameters);
  }
  
  /// Tracks a button tap event from context
  Future<void> trackButtonTap(String buttonName, {Map<String, Object>? parameters}) async {
    await _firebaseService.trackEvent('button_tap', parameters: {
      'button_name': buttonName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?parameters,
    });
  }
  
  /// Tracks a custom event from context
  Future<void> trackCustomEvent(String eventName, {Map<String, Object>? parameters}) async {
    final eventParameters = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?parameters,
    };
    
    await _firebaseService.trackEvent(eventName, parameters: eventParameters);
  }
}

/// A widget wrapper that automatically tracks analytics for its child.
/// 
/// This is useful for wrapping existing widgets with analytics tracking
/// without modifying their code.
/// 
/// Usage:
/// ```dart
/// AnalyticsWrapper(
///   screenName: 'home_page',
///   child: HomePage(),
/// )
/// ```
class AnalyticsWrapper extends StatefulWidget {
  const AnalyticsWrapper({
    super.key,
    required this.child,
    required this.screenName,
    this.screenParameters,
    this.autoTrackScreenView = true,
    this.trackScreenTime = true,
  });
  
  final Widget child;
  final String screenName;
  final Map<String, Object>? screenParameters;
  final bool autoTrackScreenView;
  final bool trackScreenTime;
  
  @override
  State<AnalyticsWrapper> createState() => _AnalyticsWrapperState();
}

class _AnalyticsWrapperState extends State<AnalyticsWrapper> with FirebaseAnalyticsMixin {
  @override
  String get screenName => widget.screenName;
  
  @override
  Map<String, Object>? get screenParameters => widget.screenParameters;
  
  @override
  bool get autoTrackScreenView => widget.autoTrackScreenView;
  
  @override
  bool get trackScreenTime => widget.trackScreenTime;
  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}