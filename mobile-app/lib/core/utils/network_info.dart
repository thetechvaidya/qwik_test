import 'package:connectivity_plus/connectivity_plus.dart';

/// Network information utility
class NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfo(this._connectivity);

  /// Check if device is connected to internet
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.mobile) ||
           result.contains(ConnectivityResult.wifi) ||
           result.contains(ConnectivityResult.ethernet);
  }

  /// Get current connectivity status
  Future<List<ConnectivityResult>> get connectivityResult async {
    return await _connectivity.checkConnectivity();
  }

  /// Stream of connectivity changes
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }

  /// Check if connected to WiFi
  Future<bool> get isConnectedToWiFi async {
    final result = await _connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.wifi);
  }

  /// Check if connected to mobile data
  Future<bool> get isConnectedToMobile async {
    final result = await _connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.mobile);
  }

  /// Get connectivity type as string
  Future<String> get connectivityType async {
    final result = await _connectivity.checkConnectivity();
    
    if (result.contains(ConnectivityResult.wifi)) {
      return 'WiFi';
    } else if (result.contains(ConnectivityResult.mobile)) {
      return 'Mobile Data';
    } else if (result.contains(ConnectivityResult.ethernet)) {
      return 'Ethernet';
    } else {
      return 'No Connection';
    }
  }
}