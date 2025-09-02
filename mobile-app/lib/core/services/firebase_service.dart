import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';

/// Centralized Firebase service for analytics, crashlytics, and performance monitoring
class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();
  
  FirebaseService._();
  
  late final FirebaseAnalytics _analytics;
  late final FirebaseCrashlytics _crashlytics;
  late final FirebasePerformance _performance;
  
  /// Initialize Firebase services
  Future<void> initialize() async {
    try {
      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;
      _performance = FirebasePerformance.instance;
      
      // Enable crashlytics collection in release mode
      await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
      
      // Enable analytics collection
      await _analytics.setAnalyticsCollectionEnabled(true);
      
      if (kDebugMode) {
        print('Firebase services initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing Firebase services: $e');
      }
    }
  }
  
  /// Set user ID for analytics and crashlytics
  Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
      await _crashlytics.setUserIdentifier(userId);
    } catch (e) {
      if (kDebugMode) {
        print('Error setting user ID: $e');
      }
    }
  }
  
  /// Set user properties for analytics
  Future<void> setUserProperty(String name, String value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      if (kDebugMode) {
        print('Error setting user property: $e');
      }
    }
  }
  
  /// Track screen view
  Future<void> trackScreenView(String screenName, {String? screenClass}) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error tracking screen view: $e');
      }
    }
  }
  
  /// Track custom event
  Future<void> trackEvent(String eventName, {Map<String, Object>? parameters}) async {
    try {
      await _analytics.logEvent(
        name: eventName,
        parameters: parameters,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error tracking event: $e');
      }
    }
  }
  
  /// Track exam started event
  Future<void> trackExamStarted(String examId, String examTitle) async {
    await trackEvent('exam_started', parameters: {
      'exam_id': examId,
      'exam_title': examTitle,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
  
  /// Track exam completed event
  Future<void> trackExamCompleted({
    required String examId,
    required String examTitle,
    required double score,
    required double percentage,
    required bool isPassed,
    required int timeSpent,
  }) async {
    await trackEvent('exam_completed', parameters: {
      'exam_id': examId,
      'exam_title': examTitle,
      'score': score,
      'percentage': percentage,
      'is_passed': isPassed,
      'time_spent_seconds': timeSpent,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
  
  /// Track search performed event
  Future<void> trackSearchPerformed(String query, int resultCount) async {
    await trackEvent('search_performed', parameters: {
      'query': query,
      'result_count': resultCount,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
  
  /// Track achievement unlocked event
  Future<void> trackAchievementUnlocked(String achievementId, String achievementTitle) async {
    await trackEvent('achievement_unlocked', parameters: {
      'achievement_id': achievementId,
      'achievement_title': achievementTitle,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
  
  /// Track dashboard view event
  Future<void> trackDashboardView() async {
    await trackEvent('dashboard_viewed', parameters: {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
  
  /// Track result view event
  Future<void> trackResultView(String examId, double score) async {
    await trackEvent('result_viewed', parameters: {
      'exam_id': examId,
      'score': score,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
  
  /// Track progress view event
  Future<void> trackProgressView() async {
    await trackEvent('progress_viewed', parameters: {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
  
  /// Log non-fatal error to Crashlytics
  Future<void> logError(dynamic exception, StackTrace? stackTrace, {String? reason}) async {
    try {
      await _crashlytics.recordError(
        exception,
        stackTrace,
        reason: reason,
        fatal: false,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error logging to Crashlytics: $e');
      }
    }
  }
  
  /// Log custom message to Crashlytics
  Future<void> logMessage(String message) async {
    try {
      await _crashlytics.log(message);
    } catch (e) {
      if (kDebugMode) {
        print('Error logging message: $e');
      }
    }
  }
  
  /// Create performance trace
  Trace createTrace(String traceName) {
    return _performance.newTrace(traceName);
  }
  
  /// Start HTTP metric
  HttpMetric createHttpMetric(String url, HttpMethod httpMethod) {
    return _performance.newHttpMetric(url, httpMethod);
  }
}