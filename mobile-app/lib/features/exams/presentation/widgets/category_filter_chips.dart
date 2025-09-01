import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Widget for displaying category filter chips horizontally
class CategoryFilterChips extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategoryId;
  final Function(String?) onCategorySelected;
  final bool showAllOption;
  final String allOptionText;
  final EdgeInsets padding;
  final double chipSpacing;

  const CategoryFilterChips({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    this.showAllOption = true,
    this.allOptionText = 'All',
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.chipSpacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty && !showAllOption) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: _getItemCount(),
        itemBuilder: (context, index) {
          if (showAllOption && index == 0) {
            return _buildAllChip(context);
          }
          
          final categoryIndex = showAllOption ? index - 1 : index;
          final category = categories[categoryIndex];
          
          return Container(
            margin: EdgeInsets.only(
              right: index < _getItemCount() - 1 ? chipSpacing : 0,
            ),
            child: _CategoryFilterChip(
              category: category,
              isSelected: selectedCategoryId == category.id,
              onTap: () => onCategorySelected(category.id),
            ),
          );
        },
      ),
    );
  }

  int _getItemCount() {
    return categories.length + (showAllOption ? 1 : 0);
  }

  Widget _buildAllChip(BuildContext context) {
    final isSelected = selectedCategoryId == null;
    
    return Container(
      margin: EdgeInsets.only(right: chipSpacing),
      child: FilterChip(
        label: Text(
          allOptionText,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => onCategorySelected(null),
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.outline,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

class _CategoryFilterChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryFilterChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (category.icon != null) ..[
            Icon(
              _getCategoryIcon(),
              size: 16,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            category.name,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          if (category.examCount > 0) ..[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected 
                    ? Colors.white.withOpacity(0.2)
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                category.examCount.toString(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: isSelected ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primary,
      checkmarkColor: Colors.white,
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.outline,
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  IconData _getCategoryIcon() {
    // Map category names or IDs to appropriate icons
    final iconName = category.icon?.toLowerCase() ?? category.name.toLowerCase();
    
    switch (iconName) {
      case 'programming':
      case 'code':
      case 'development':
        return Icons.code;
      case 'mathematics':
      case 'math':
      case 'algebra':
        return Icons.calculate;
      case 'science':
      case 'physics':
      case 'chemistry':
        return Icons.science;
      case 'language':
      case 'english':
      case 'literature':
        return Icons.translate;
      case 'history':
        return Icons.history_edu;
      case 'geography':
        return Icons.public;
      case 'business':
      case 'management':
        return Icons.business;
      case 'technology':
      case 'it':
      case 'computer':
        return Icons.computer;
      case 'design':
      case 'art':
        return Icons.palette;
      case 'music':
        return Icons.music_note;
      case 'sports':
      case 'fitness':
        return Icons.sports;
      case 'health':
      case 'medical':
      case 'medicine':
        return Icons.local_hospital;
      case 'law':
      case 'legal':
        return Icons.gavel;
      case 'finance':
      case 'accounting':
        return Icons.account_balance;
      case 'marketing':
        return Icons.campaign;
      case 'engineering':
        return Icons.engineering;
      case 'architecture':
        return Icons.architecture;
      case 'psychology':
        return Icons.psychology;
      case 'education':
      case 'teaching':
        return Icons.school;
      case 'cooking':
      case 'culinary':
        return Icons.restaurant;
      case 'travel':
      case 'tourism':
        return Icons.flight;
      case 'photography':
        return Icons.camera_alt;
      case 'writing':
      case 'journalism':
        return Icons.edit;
      case 'gaming':
      case 'games':
        return Icons.sports_esports;
      case 'environment':
      case 'ecology':
        return Icons.eco;
      case 'agriculture':
      case 'farming':
        return Icons.agriculture;
      case 'automotive':
      case 'cars':
        return Icons.directions_car;
      case 'aviation':
      case 'flying':
        return Icons.flight_takeoff;
      case 'maritime':
      case 'shipping':
        return Icons.directions_boat;
      case 'construction':
      case 'building':
        return Icons.construction;
      case 'retail':
      case 'sales':
        return Icons.shopping_cart;
      case 'logistics':
      case 'supply chain':
        return Icons.local_shipping;
      case 'security':
      case 'safety':
        return Icons.security;
      case 'quality':
      case 'qa':
        return Icons.verified;
      case 'project management':
      case 'pm':
        return Icons.assignment;
      case 'data':
      case 'analytics':
        return Icons.analytics;
      case 'ai':
      case 'artificial intelligence':
      case 'machine learning':
        return Icons.smart_toy;
      case 'blockchain':
      case 'crypto':
        return Icons.currency_bitcoin;
      case 'cloud':
      case 'aws':
      case 'azure':
        return Icons.cloud;
      case 'mobile':
      case 'app development':
        return Icons.phone_android;
      case 'web':
      case 'web development':
        return Icons.web;
      case 'database':
      case 'sql':
        return Icons.storage;
      case 'network':
      case 'networking':
        return Icons.network_check;
      case 'cybersecurity':
      case 'security':
        return Icons.shield;
      case 'devops':
        return Icons.settings;
      case 'testing':
      case 'qa testing':
        return Icons.bug_report;
      case 'ui/ux':
      case 'design':
        return Icons.design_services;
      default:
        return Icons.category;
    }
  }
}

/// Extension to provide additional functionality for category filtering
extension CategoryFilterChipsExtension on List<Category> {
  /// Get categories sorted by exam count (descending) and name
  List<Category> get sortedForFilter {
    final sorted = List<Category>.from(this);
    sorted.sort((a, b) {
      // First sort by exam count (descending)
      final examCountComparison = b.examCount.compareTo(a.examCount);
      if (examCountComparison != 0) {
        return examCountComparison;
      }
      // Then sort by name (ascending)
      return a.name.compareTo(b.name);
    });
    return sorted;
  }

  /// Get only categories that have exams
  List<Category> get withExams {
    return where((category) => category.examCount > 0).toList();
  }

  /// Get top N categories by exam count
  List<Category> getTopCategories(int count) {
    return sortedForFilter.take(count).toList();
  }
}