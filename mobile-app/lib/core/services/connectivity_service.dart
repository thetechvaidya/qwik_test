import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Service for monitoring network connectivity with stream-based updates
class ConnectivityService {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  final StreamController<bool> _connectivityController = StreamController<bool>.broadcast();
  
  bool _isConnected = false;
  bool _isInitialized = false;

  ConnectivityService(this._connectivity);

  /// Stream of connectivity changes (true = connected, false = disconnected)
  Stream<bool> get connectionStream => _connectivityController.stream;

  /// Current connection status
  bool get isConnected => _isConnected;

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Initialize the connectivity service and start monitoring
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Check initial connectivity status
      await _updateConnectivityStatus();
      
      // Start listening to connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _onConnectivityChanged,
        onError: (error) {
          debugPrint('ConnectivityService error: $error');
        },
      );
      
      _isInitialized = true;
      debugPrint('ConnectivityService initialized. Initial status: $_isConnected');
    } catch (e) {
      debugPrint('Failed to initialize ConnectivityService: $e');
      rethrow;
    }
  }

  /// Wait for connection to be available
  Future<void> waitForConnection({Duration? timeout}) async {
    if (_isConnected) return;
    
    final completer = Completer<void>();
    late StreamSubscription<bool> subscription;
    
    subscription = connectionStream.listen((isConnected) {
      if (isConnected) {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });
    
    if (timeout != null) {
      Timer(timeout, () {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.completeError(TimeoutException('Connection timeout', timeout));
        }
      });
    }
    
    return completer.future;
  }

  /// Force check current connectivity status
  Future<bool> checkConnectivity() async {
    await _updateConnectivityStatus();
    return _isConnected;
  }

  /// Handle connectivity changes
  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final wasConnected = _isConnected;
    _isConnected = _hasValidConnection(results);
    
    if (wasConnected != _isConnected) {
      debugPrint('Connectivity changed: $_isConnected');
      _connectivityController.add(_isConnected);
    }
  }

  /// Update connectivity status
  Future<void> _updateConnectivityStatus() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final wasConnected = _isConnected;
      _isConnected = _hasValidConnection(results);
      
      if (wasConnected != _isConnected && _isInitialized) {
        _connectivityController.add(_isConnected);
      }
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      _isConnected = false;
    }
  }

  /// Check if connectivity results indicate a valid connection
  bool _hasValidConnection(List<ConnectivityResult> results) {
    return results.isNotEmpty && 
           !results.every((result) => result == ConnectivityResult.none);
  }

  /// Get detailed connectivity information
  Future<Map<String, dynamic>> getConnectivityDetails() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return {
        'isConnected': _hasValidConnection(results),
        'connectionTypes': results.map((r) => r.name).toList(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'isConnected': false,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivityController.close();
    _isInitialized = false;
    debugPrint('ConnectivityService disposed');
  }
}

/// Exception thrown when waiting for connection times out
class TimeoutException implements Exception {
  final String message;
  final Duration timeout;
  
  const TimeoutException(this.message, this.timeout);
  
  @override
  String toString() => 'TimeoutException: $message (${timeout.inSeconds}s)';
}