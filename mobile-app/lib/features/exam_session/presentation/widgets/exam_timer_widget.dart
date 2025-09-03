import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Widget for displaying exam timer with visual indicators
class ExamTimerWidget extends StatelessWidget {
  final Duration timeRemaining;
  final Duration totalDuration;
  final bool isWarning;
  final bool isCritical;
  final bool showProgress;

  const ExamTimerWidget({
    super.key,
    required this.timeRemaining,
    required this.totalDuration,
    this.isWarning = false,
    this.isCritical = false,
    this.showProgress = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getBorderColor(),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Timer icon
          Icon(
            _getTimerIcon(),
            size: 20,
            color: _getTextColor(),
          ),
          
          const SizedBox(width: 8),
          
          // Time display
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatDuration(timeRemaining),
                style: AppTextStyles.titleSmall.copyWith(
                  color: _getTextColor(),
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              
              if (showProgress)
                Text(
                  'Time Remaining',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: _getTextColor().withAlpha((255 * 0.8).round()),
                  ),
                ),
            ],
          ),
          
          // Progress indicator (if enabled)
          if (showProgress && totalDuration.inSeconds > 0) ...[
            const SizedBox(width: 12),
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                value: _getProgressValue(),
                strokeWidth: 3,
                backgroundColor: _getTextColor().withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isCritical) {
      return AppColors.errorContainer;
    } else if (isWarning) {
      return AppColors.warningContainer;
    } else {
      return AppColors.primaryContainer;
    }
  }

  Color _getBorderColor() {
    if (isCritical) {
      return AppColors.error;
    } else if (isWarning) {
      return AppColors.warning;
    } else {
      return AppColors.primary;
    }
  }

  Color _getTextColor() {
    if (isCritical) {
      return AppColors.onErrorContainer;
    } else if (isWarning) {
      return AppColors.onWarningContainer;
    } else {
      return AppColors.onPrimaryContainer;
    }
  }

  IconData _getTimerIcon() {
    if (isCritical) {
      return Icons.timer_off;
    } else if (isWarning) {
      return Icons.timer;
    } else {
      return Icons.access_time;
    }
  }

  double _getProgressValue() {
    if (totalDuration.inSeconds == 0) return 0.0;
    final elapsed = totalDuration.inSeconds - timeRemaining.inSeconds;
    return elapsed / totalDuration.inSeconds;
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}

/// Compact version of the timer widget for smaller spaces
class CompactExamTimerWidget extends StatelessWidget {
  final Duration timeRemaining;
  final bool isWarning;
  final bool isCritical;

  const CompactExamTimerWidget({
    super.key,
    required this.timeRemaining,
    this.isWarning = false,
    this.isCritical = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getTimerIcon(),
            size: 16,
            color: _getTextColor(),
          ),
          const SizedBox(width: 4),
          Text(
            _formatDuration(timeRemaining),
            style: AppTextStyles.bodySmall.copyWith(
              color: _getTextColor(),
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isCritical) {
      return AppColors.error.withAlpha((255 * 0.1).round());
    } else if (isWarning) {
      return AppColors.warning.withAlpha((255 * 0.1).round());
    } else {
      return AppColors.primary.withAlpha((255 * 0.1).round());
    }
  }

  Color _getTextColor() {
    if (isCritical) {
      return AppColors.error;
    } else if (isWarning) {
      return AppColors.warning;
    } else {
      return AppColors.primary;
    }
  }

  IconData _getTimerIcon() {
    if (isCritical) {
      return Icons.timer_off;
    } else if (isWarning) {
      return Icons.timer;
    } else {
      return Icons.access_time;
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}