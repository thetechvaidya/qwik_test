import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Widget for displaying empty states in exam-related screens
class ExamEmptyState extends StatelessWidget {
  final ExamEmptyStateType type;
  final String? customTitle;
  final String? customMessage;
  final String? customActionText;
  final VoidCallback? onActionPressed;
  final Widget? customIcon;
  final bool showAction;

  const ExamEmptyState({
    super.key,
    required this.type,
    this.customTitle,
    this.customMessage,
    this.customActionText,
    this.onActionPressed,
    this.customIcon,
    this.showAction = true,
  });

  /// Factory constructor for no exams found state
  const ExamEmptyState.noExams({
    super.key,
    this.customTitle,
    this.customMessage,
    this.customActionText,
    this.onActionPressed,
    this.customIcon,
    this.showAction = true,
  }) : type = ExamEmptyStateType.noExams;

  /// Factory constructor for no search results state
  const ExamEmptyState.noSearchResults({
    super.key,
    this.customTitle,
    this.customMessage,
    this.customActionText,
    this.onActionPressed,
    this.customIcon,
    this.showAction = true,
  }) : type = ExamEmptyStateType.noSearchResults;

  /// Factory constructor for no favorites state
  const ExamEmptyState.noFavorites({
    super.key,
    this.customTitle,
    this.customMessage,
    this.customActionText,
    this.onActionPressed,
    this.customIcon,
    this.showAction = true,
  }) : type = ExamEmptyStateType.noFavorites;

  /// Factory constructor for no history state
  const ExamEmptyState.noHistory({
    super.key,
    this.customTitle,
    this.customMessage,
    this.customActionText,
    this.onActionPressed,
    this.customIcon,
    this.showAction = true,
  }) : type = ExamEmptyStateType.noHistory;

  /// Factory constructor for offline state
  const ExamEmptyState.offline({
    super.key,
    this.customTitle,
    this.customMessage,
    this.customActionText,
    this.onActionPressed,
    this.customIcon,
    this.showAction = true,
  }) : type = ExamEmptyStateType.offline;

  /// Factory constructor for no category exams state
  const ExamEmptyState.noCategoryExams({
    super.key,
    this.customTitle,
    this.customMessage,
    this.customActionText,
    this.onActionPressed,
    this.customIcon,
    this.showAction = true,
  }) : type = ExamEmptyStateType.noCategoryExams;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(context),
            const SizedBox(height: 24),
            _buildTitle(context),
            const SizedBox(height: 12),
            _buildMessage(context),
            if (showAction && (onActionPressed != null || _getDefaultAction() != null)) ..[
              const SizedBox(height: 32),
              _buildActionButton(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    if (customIcon != null) {
      return customIcon!;
    }

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: _getIconBackgroundColor().withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getDefaultIcon(),
        size: 60,
        color: _getIconBackgroundColor(),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      customTitle ?? _getDefaultTitle(),
      style: AppTextStyles.titleLarge.copyWith(
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage(BuildContext context) {
    return Text(
      customMessage ?? _getDefaultMessage(),
      style: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.textSecondary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final actionText = customActionText ?? _getDefaultActionText();
    final action = onActionPressed ?? _getDefaultAction();
    
    if (actionText == null || action == null) {
      return const SizedBox.shrink();
    }

    return ElevatedButton.icon(
      onPressed: action,
      icon: Icon(_getActionIcon()),
      label: Text(actionText),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  IconData _getDefaultIcon() {
    switch (type) {
      case ExamEmptyStateType.noExams:
        return Icons.quiz_outlined;
      case ExamEmptyStateType.noSearchResults:
        return Icons.search_off;
      case ExamEmptyStateType.noFavorites:
        return Icons.favorite_border;
      case ExamEmptyStateType.noHistory:
        return Icons.history;
      case ExamEmptyStateType.offline:
        return Icons.wifi_off;
      case ExamEmptyStateType.noCategoryExams:
        return Icons.category_outlined;
    }
  }

  Color _getIconBackgroundColor() {
    switch (type) {
      case ExamEmptyStateType.noExams:
        return AppColors.primary;
      case ExamEmptyStateType.noSearchResults:
        return AppColors.warning;
      case ExamEmptyStateType.noFavorites:
        return AppColors.error;
      case ExamEmptyStateType.noHistory:
        return AppColors.info;
      case ExamEmptyStateType.offline:
        return AppColors.textSecondary;
      case ExamEmptyStateType.noCategoryExams:
        return AppColors.primary;
    }
  }

  String _getDefaultTitle() {
    switch (type) {
      case ExamEmptyStateType.noExams:
        return 'No Exams Available';
      case ExamEmptyStateType.noSearchResults:
        return 'No Results Found';
      case ExamEmptyStateType.noFavorites:
        return 'No Favorite Exams';
      case ExamEmptyStateType.noHistory:
        return 'No Exam History';
      case ExamEmptyStateType.offline:
        return 'You\'re Offline';
      case ExamEmptyStateType.noCategoryExams:
        return 'No Exams in Category';
    }
  }

  String _getDefaultMessage() {
    switch (type) {
      case ExamEmptyStateType.noExams:
        return 'There are currently no exams available. Check back later or contact support if this seems incorrect.';
      case ExamEmptyStateType.noSearchResults:
        return 'We couldn\'t find any exams matching your search criteria. Try adjusting your filters or search terms.';
      case ExamEmptyStateType.noFavorites:
        return 'You haven\'t added any exams to your favorites yet. Start exploring and save exams you\'d like to take later!';
      case ExamEmptyStateType.noHistory:
        return 'You haven\'t taken any exams yet. Start your learning journey by taking your first exam!';
      case ExamEmptyStateType.offline:
        return 'Please check your internet connection and try again. Some features may not be available offline.';
      case ExamEmptyStateType.noCategoryExams:
        return 'There are no exams available in this category at the moment. Try exploring other categories or check back later.';
    }
  }

  String? _getDefaultActionText() {
    switch (type) {
      case ExamEmptyStateType.noExams:
        return 'Refresh';
      case ExamEmptyStateType.noSearchResults:
        return 'Clear Filters';
      case ExamEmptyStateType.noFavorites:
        return 'Explore Exams';
      case ExamEmptyStateType.noHistory:
        return 'Browse Exams';
      case ExamEmptyStateType.offline:
        return 'Try Again';
      case ExamEmptyStateType.noCategoryExams:
        return 'Browse All Categories';
    }
  }

  IconData _getActionIcon() {
    switch (type) {
      case ExamEmptyStateType.noExams:
        return Icons.refresh;
      case ExamEmptyStateType.noSearchResults:
        return Icons.clear;
      case ExamEmptyStateType.noFavorites:
        return Icons.explore;
      case ExamEmptyStateType.noHistory:
        return Icons.quiz;
      case ExamEmptyStateType.offline:
        return Icons.refresh;
      case ExamEmptyStateType.noCategoryExams:
        return Icons.category;
    }
  }

  VoidCallback? _getDefaultAction() {
    // Default actions can be implemented based on context
    // For now, return null to let the parent handle actions
    return null;
  }
}

/// Enum defining different types of empty states for exams
enum ExamEmptyStateType {
  /// No exams available at all
  noExams,
  
  /// No search results found
  noSearchResults,
  
  /// No favorite exams
  noFavorites,
  
  /// No exam history
  noHistory,
  
  /// Offline state
  offline,
  
  /// No exams in selected category
  noCategoryExams,
}

/// Extension to provide display names for empty state types
extension ExamEmptyStateTypeExtension on ExamEmptyStateType {
  String get displayName {
    switch (this) {
      case ExamEmptyStateType.noExams:
        return 'No Exams';
      case ExamEmptyStateType.noSearchResults:
        return 'No Results';
      case ExamEmptyStateType.noFavorites:
        return 'No Favorites';
      case ExamEmptyStateType.noHistory:
        return 'No History';
      case ExamEmptyStateType.offline:
        return 'Offline';
      case ExamEmptyStateType.noCategoryExams:
        return 'No Category Exams';
    }
  }

  bool get isNetworkRelated {
    return this == ExamEmptyStateType.offline;
  }

  bool get isUserActionRequired {
    return this == ExamEmptyStateType.noFavorites ||
           this == ExamEmptyStateType.noHistory;
  }
}