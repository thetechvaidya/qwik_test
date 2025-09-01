import 'dart:async';

/// Utility class for managing exam session timer
class ExamTimer {
  Timer? _timer;
  int _remainingSeconds;
  bool _isPaused;
  final void Function(int remainingSeconds) _onTick;
  final void Function() _onExpired;
  final void Function()? _onWarning;
  final void Function()? _onCritical;
  
  final int _warningThreshold; // 5 minutes
  final int _criticalThreshold; // 1 minute
  
  bool _warningTriggered = false;
  bool _criticalTriggered = false;

  ExamTimer({
    required int initialSeconds,
    required void Function(int remainingSeconds) onTick,
    required void Function() onExpired,
    void Function()? onWarning,
    void Function()? onCritical,
    int warningThreshold = 300, // 5 minutes
    int criticalThreshold = 60, // 1 minute
  })
      : _remainingSeconds = initialSeconds,
        _isPaused = false,
        _onTick = onTick,
        _onExpired = onExpired,
        _onWarning = onWarning,
        _onCritical = onCritical,
        _warningThreshold = warningThreshold,
        _criticalThreshold = criticalThreshold;

  /// Start the timer
  void start() {
    if (_timer?.isActive == true) return;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && _remainingSeconds > 0) {
        _remainingSeconds--;
        _onTick(_remainingSeconds);
        _checkThresholds();
      } else if (_remainingSeconds <= 0) {
        timer.cancel();
        _onExpired();
      }
    });
  }

  /// Pause the timer
  void pause() {
    _isPaused = true;
  }

  /// Resume the timer
  void resume() {
    _isPaused = false;
  }

  /// Stop and dispose the timer
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// Add time to the timer
  void addTime(int seconds) {
    _remainingSeconds += seconds;
    _onTick(_remainingSeconds);
  }

  /// Subtract time from the timer
  void subtractTime(int seconds) {
    _remainingSeconds = (_remainingSeconds - seconds).clamp(0, double.infinity).toInt();
    _onTick(_remainingSeconds);
    
    if (_remainingSeconds <= 0) {
      stop();
      _onExpired();
    }
  }

  /// Set remaining time
  void setRemainingTime(int seconds) {
    _remainingSeconds = seconds.clamp(0, double.infinity).toInt();
    _onTick(_remainingSeconds);
    
    if (_remainingSeconds <= 0) {
      stop();
      _onExpired();
    }
  }

  /// Check warning and critical thresholds
  void _checkThresholds() {
    if (!_warningTriggered && _remainingSeconds <= _warningThreshold && _onWarning != null) {
      _warningTriggered = true;
      _onWarning!();
    }
    
    if (!_criticalTriggered && _remainingSeconds <= _criticalThreshold && _onCritical != null) {
      _criticalTriggered = true;
      _onCritical!();
    }
  }

  /// Get remaining time in seconds
  int get remainingSeconds => _remainingSeconds;

  /// Get remaining time formatted as HH:MM:SS or MM:SS
  String get formattedTime {
    final hours = _remainingSeconds ~/ 3600;
    final minutes = (_remainingSeconds % 3600) ~/ 60;
    final seconds = _remainingSeconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Get remaining time as duration
  Duration get remainingDuration => Duration(seconds: _remainingSeconds);

  /// Check if timer is running
  bool get isRunning => _timer?.isActive == true && !_isPaused;

  /// Check if timer is paused
  bool get isPaused => _isPaused;

  /// Check if time is running low (within warning threshold)
  bool get isTimeRunningLow => _remainingSeconds <= _warningThreshold;

  /// Check if time is critical (within critical threshold)
  bool get isTimeCritical => _remainingSeconds <= _criticalThreshold;

  /// Check if timer has expired
  bool get hasExpired => _remainingSeconds <= 0;

  /// Get progress percentage (0.0 to 1.0)
  double getProgress(int totalSeconds) {
    if (totalSeconds <= 0) return 0.0;
    return (totalSeconds - _remainingSeconds) / totalSeconds;
  }

  /// Get remaining percentage (0.0 to 1.0)
  double getRemainingPercentage(int totalSeconds) {
    if (totalSeconds <= 0) return 0.0;
    return _remainingSeconds / totalSeconds;
  }

  /// Dispose resources
  void dispose() {
    stop();
  }
}

/// Extension for Duration formatting
extension DurationExtension on Duration {
  /// Format duration as HH:MM:SS or MM:SS
  String get formattedTime {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Format duration in a human-readable way
  String get humanReadable {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}