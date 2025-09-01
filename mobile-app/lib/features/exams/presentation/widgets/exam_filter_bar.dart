import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/exam_state.dart';
import '../../domain/entities/exam.dart';

/// Filter bar widget for exam filtering and sorting options
class ExamFilterBar extends StatelessWidget {
  final ExamFilters filters;
  final ExamSorting sorting;
  final Function(ExamFilters) onFiltersChanged;
  final Function(ExamSorting) onSortChanged;
  final bool showSortButton;
  final bool isCompact;

  const ExamFilterBar({
    super.key,
    required this.filters,
    required this.sorting,
    required this.onFiltersChanged,
    required this.onSortChanged,
    this.showSortButton = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isCompact ? 8 : 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter chips row
          _buildFilterChips(context),
          
          // Sort and view options
          if (showSortButton && !isCompact) ..[
            const SizedBox(height: 8),
            _buildSortRow(context),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Difficulty filter
          _buildFilterChip(
            context: context,
            label: filters.difficulty?.displayName ?? 'Difficulty',
            isSelected: filters.difficulty != null,
            onTap: () => _showDifficultyFilter(context),
            icon: Icons.signal_cellular_alt,
          ),
          
          const SizedBox(width: 8),
          
          // Exam type filter
          _buildFilterChip(
            context: context,
            label: filters.examType?.displayName ?? 'Type',
            isSelected: filters.examType != null,
            onTap: () => _showExamTypeFilter(context),
            icon: Icons.quiz_outlined,
          ),
          
          const SizedBox(width: 8),
          
          // Duration filter
          _buildFilterChip(
            context: context,
            label: _getDurationFilterLabel(),
            isSelected: filters.minDuration != null || filters.maxDuration != null,
            onTap: () => _showDurationFilter(context),
            icon: Icons.access_time,
          ),
          
          const SizedBox(width: 8),
          
          // Active status filter
          _buildFilterChip(
            context: context,
            label: filters.isActive == true ? 'Active' : 
                   filters.isActive == false ? 'Inactive' : 'Status',
            isSelected: filters.isActive != null,
            onTap: () => _showStatusFilter(context),
            icon: Icons.toggle_on,
          ),
          
          // Clear filters button
          if (filters.hasFilters) ..[
            const SizedBox(width: 8),
            _buildClearFiltersButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildSortRow(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.sort,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          'Sort by: ${sorting.getDisplayName()}',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            onSortChanged(sorting.toggleOrder());
          },
          child: Icon(
            sorting.sortOrder == SortOrder.ascending
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            size: 16,
            color: AppColors.primary,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => _showSortBottomSheet(context),
          child: Text(
            'Change',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ..[
              Icon(
                icon,
                size: 14,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            if (isSelected) ..[
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 14,
                color: AppColors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildClearFiltersButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onFiltersChanged(filters.clear());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.clear,
              size: 14,
              color: AppColors.error,
            ),
            const SizedBox(width: 4),
            Text(
              'Clear',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDurationFilterLabel() {
    if (filters.minDuration != null && filters.maxDuration != null) {
      return '${filters.minDuration}-${filters.maxDuration}min';
    } else if (filters.minDuration != null) {
      return '>${filters.minDuration}min';
    } else if (filters.maxDuration != null) {
      return '<${filters.maxDuration}min';
    }
    return 'Duration';
  }

  void _showDifficultyFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _DifficultyFilterBottomSheet(
        selectedDifficulty: filters.difficulty,
        onDifficultySelected: (difficulty) {
          onFiltersChanged(filters.copyWith(difficulty: difficulty));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showExamTypeFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _ExamTypeFilterBottomSheet(
        selectedType: filters.examType,
        onTypeSelected: (type) {
          onFiltersChanged(filters.copyWith(examType: type));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showDurationFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _DurationFilterBottomSheet(
        minDuration: filters.minDuration,
        maxDuration: filters.maxDuration,
        onDurationSelected: (min, max) {
          onFiltersChanged(filters.copyWith(
            minDuration: min,
            maxDuration: max,
          ));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showStatusFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _StatusFilterBottomSheet(
        selectedStatus: filters.isActive,
        onStatusSelected: (isActive) {
          onFiltersChanged(filters.copyWith(isActive: isActive));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _SortBottomSheet(
        currentSorting: sorting,
        onSortChanged: (newSorting) {
          onSortChanged(newSorting);
          Navigator.pop(context);
        },
      ),
    );
  }
}

// Bottom sheet widgets for different filter types
class _DifficultyFilterBottomSheet extends StatelessWidget {
  final ExamDifficulty? selectedDifficulty;
  final Function(ExamDifficulty?) onDifficultySelected;

  const _DifficultyFilterBottomSheet({
    required this.selectedDifficulty,
    required this.onDifficultySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Difficulty',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 16),
          ...ExamDifficulty.values.map((difficulty) => 
            ListTile(
              title: Text(difficulty.displayName),
              trailing: selectedDifficulty == difficulty
                  ? Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () => onDifficultySelected(difficulty),
            ),
          ),
          ListTile(
            title: const Text('All Difficulties'),
            trailing: selectedDifficulty == null
                ? Icon(Icons.check, color: AppColors.primary)
                : null,
            onTap: () => onDifficultySelected(null),
          ),
        ],
      ),
    );
  }
}

class _ExamTypeFilterBottomSheet extends StatelessWidget {
  final ExamType? selectedType;
  final Function(ExamType?) onTypeSelected;

  const _ExamTypeFilterBottomSheet({
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Exam Type',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 16),
          ...ExamType.values.map((type) => 
            ListTile(
              title: Text(type.displayName),
              trailing: selectedType == type
                  ? Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () => onTypeSelected(type),
            ),
          ),
          ListTile(
            title: const Text('All Types'),
            trailing: selectedType == null
                ? Icon(Icons.check, color: AppColors.primary)
                : null,
            onTap: () => onTypeSelected(null),
          ),
        ],
      ),
    );
  }
}

class _DurationFilterBottomSheet extends StatelessWidget {
  final int? minDuration;
  final int? maxDuration;
  final Function(int?, int?) onDurationSelected;

  const _DurationFilterBottomSheet({
    required this.minDuration,
    required this.maxDuration,
    required this.onDurationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Duration Range',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 16),
          // Predefined duration ranges
          ..._getDurationRanges().map((range) => 
            ListTile(
              title: Text(range['label'] as String),
              trailing: _isRangeSelected(range)
                  ? Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () => onDurationSelected(
                range['min'] as int?,
                range['max'] as int?,
              ),
            ),
          ),
          ListTile(
            title: const Text('Any Duration'),
            trailing: minDuration == null && maxDuration == null
                ? Icon(Icons.check, color: AppColors.primary)
                : null,
            onTap: () => onDurationSelected(null, null),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getDurationRanges() {
    return [
      {'label': 'Quick (< 30 min)', 'min': null, 'max': 30},
      {'label': 'Short (30-60 min)', 'min': 30, 'max': 60},
      {'label': 'Medium (1-2 hours)', 'min': 60, 'max': 120},
      {'label': 'Long (2+ hours)', 'min': 120, 'max': null},
    ];
  }

  bool _isRangeSelected(Map<String, dynamic> range) {
    return minDuration == range['min'] && maxDuration == range['max'];
  }
}

class _StatusFilterBottomSheet extends StatelessWidget {
  final bool? selectedStatus;
  final Function(bool?) onStatusSelected;

  const _StatusFilterBottomSheet({
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Status',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Active'),
            trailing: selectedStatus == true
                ? Icon(Icons.check, color: AppColors.primary)
                : null,
            onTap: () => onStatusSelected(true),
          ),
          ListTile(
            title: const Text('Inactive'),
            trailing: selectedStatus == false
                ? Icon(Icons.check, color: AppColors.primary)
                : null,
            onTap: () => onStatusSelected(false),
          ),
          ListTile(
            title: const Text('All'),
            trailing: selectedStatus == null
                ? Icon(Icons.check, color: AppColors.primary)
                : null,
            onTap: () => onStatusSelected(null),
          ),
        ],
      ),
    );
  }
}

class _SortBottomSheet extends StatelessWidget {
  final ExamSorting currentSorting;
  final Function(ExamSorting) onSortChanged;

  const _SortBottomSheet({
    required this.currentSorting,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sort Options',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 16),
          ...SortOption.availableOptions.map((option) => 
            ListTile(
              title: Text(option.displayName),
              leading: Icon(option.icon),
              trailing: currentSorting.sortBy == option.value
                  ? Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () => onSortChanged(ExamSorting(
                sortBy: option.value,
                sortOrder: currentSorting.sortOrder,
              )),
            ),
          ),
        ],
      ),
    );
  }
}