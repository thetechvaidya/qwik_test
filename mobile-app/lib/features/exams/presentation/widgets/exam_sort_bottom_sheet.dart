import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/exam_state.dart';

/// Bottom sheet widget for exam sorting options
class ExamSortBottomSheet extends StatefulWidget {
  final ExamSorting currentSorting;
  final Function(ExamSorting) onSortChanged;

  const ExamSortBottomSheet({
    super.key,
    required this.currentSorting,
    required this.onSortChanged,
  });

  @override
  State<ExamSortBottomSheet> createState() => _ExamSortBottomSheetState();
}

class _ExamSortBottomSheetState extends State<ExamSortBottomSheet> {
  late String selectedSortBy;
  late String selectedSortOrder;

  @override
  void initState() {
    super.initState();
    selectedSortBy = widget.currentSorting.sortBy;
    selectedSortOrder = widget.currentSorting.sortOrder;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppColors.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sort Options',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedSortBy = 'title';
                      selectedSortOrder = 'asc';
                    });
                  },
                  child: Text(
                    'Reset',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Sort options
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildSectionHeader('Sort By'),
                const SizedBox(height: 8),
                ...SortOption.availableOptions.map((option) => 
                  _buildSortOption(option),
                ),
                
                const SizedBox(height: 24),
                _buildSectionHeader('Order'),
                const SizedBox(height: 8),
                _buildOrderOption(
                  title: 'Ascending',
                  subtitle: _getOrderSubtitle('asc'),
                  icon: Icons.arrow_upward,
                  order: 'asc',
                ),
                _buildOrderOption(
                  title: 'Descending',
                  subtitle: _getOrderSubtitle('desc'),
                  icon: Icons.arrow_downward,
                  order: 'desc',
                ),
              ],
            ),
          ),
          
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _hasChanges() ? _applySorting : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.titleSmall.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildSortOption(SortOption option) {
    final isSelected = selectedSortBy == option.value;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedSortBy = option.value;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.primary.withOpacity(0.1) 
                : Colors.transparent,
            border: Border.all(
              color: isSelected 
                  ? AppColors.primary 
                  : AppColors.outline.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                _iconFor(option.icon),
                color: isSelected 
                    ? AppColors.primary 
                    : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.displayName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: isSelected 
                            ? FontWeight.w600 
                            : FontWeight.normal,
                        color: isSelected 
                            ? AppColors.primary 
                            : AppColors.textPrimary,
                      ),
                    ),
                    if (_getSortOptionDescription(option.value) != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        _getSortOptionDescription(option.value)!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required String order,
  }) {
    final isSelected = selectedSortOrder == order;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedSortOrder = order;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.primary.withOpacity(0.1) 
                : Colors.transparent,
            border: Border.all(
              color: isSelected 
                  ? AppColors.primary 
                  : AppColors.outline.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected 
                    ? AppColors.primary 
                    : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: isSelected 
                            ? FontWeight.w600 
                            : FontWeight.normal,
                        color: isSelected 
                            ? AppColors.primary 
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String iconName) {
    switch (iconName) {
      case 'calendar_today':
        return Icons.calendar_today;
      case 'sort_by_alpha':
        return Icons.sort_by_alpha;
      case 'trending_up':
        return Icons.trending_up;
      case 'timer':
        return Icons.timer;
      case 'quiz':
        return Icons.quiz;
      case 'star':
        return Icons.star;
      default:
        return Icons.help_outline;
    }
  }

  String? _getSortOptionDescription(String sortBy) {
    switch (sortBy) {
      case 'title':
        return 'Sort alphabetically by exam title';
      case 'createdAt':
        return 'Sort by when the exam was created';
      case 'difficulty':
        return 'Sort by difficulty level';
      case 'duration':
        return 'Sort by exam duration';
      case 'totalQuestions':
        return 'Sort by number of questions';
      case 'popularity':
        return 'Sort by exam popularity';
      default:
        return null;
    }
  }

  String _getOrderSubtitle(String order) {
    final isAscending = order == 'asc';
    final sortOption = SortOption.availableOptions
        .firstWhere((option) => option.value == selectedSortBy);
    
    switch (selectedSortBy) {
      case 'title':
        return isAscending ? 'A to Z' : 'Z to A';
      case 'createdAt':
        return isAscending ? 'Oldest first' : 'Newest first';
      case 'difficulty':
        return isAscending ? 'Easiest first' : 'Hardest first';
      case 'duration':
        return isAscending ? 'Shortest first' : 'Longest first';
      case 'totalQuestions':
        return isAscending ? 'Fewest first' : 'Most first';
      case 'popularity':
        return isAscending ? 'Lowest first' : 'Highest first';
      default:
        return isAscending ? 'Low to high' : 'High to low';
    }
  }

  bool _hasChanges() {
    return selectedSortBy != widget.currentSorting.sortBy ||
           selectedSortOrder != widget.currentSorting.sortOrder;
  }

  void _applySorting() {
    final newSorting = ExamSorting(
      sortBy: selectedSortBy,
      sortOrder: selectedSortOrder,
    );
    widget.onSortChanged(newSorting);
  }
}