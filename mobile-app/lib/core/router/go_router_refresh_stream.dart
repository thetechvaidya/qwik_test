import 'dart:async';
import 'package:flutter/foundation.dart';

/// A [ChangeNotifier] that listens to a [Stream] and notifies listeners
/// when the stream emits new values. This is useful for making [GoRouter]
/// reactive to state changes from BLoCs or other stream-based state management.
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _subscription;

  /// Creates a [GoRouterRefreshStream] that listens to the provided [stream].
  /// 
  /// The [stream] should emit values whenever the router should be refreshed
  /// (e.g., when authentication state changes).
  GoRouterRefreshStream(Stream stream) {
    _subscription = stream.listen((_) {
      // Notify GoRouter to refresh/re-evaluate routes
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}