import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Widget for displaying loading states in exam-related screens
class ExamLoadingWidget extends StatelessWidget {
  final ExamLoadingType type;
  final int itemCount;
  final EdgeInsets padding;
  final double spacing;

  const ExamLoadingWidget({
    super.key,
    required this.type,
    this.itemCount = 5,
    this.padding = const EdgeInsets.all(16),
    this.spacing = 16,
  });

  /// Factory constructor for list loading
  const ExamLoadingWidget.list({
    super.key,
    this.itemCount = 5,
    this.padding = const EdgeInsets.all(16),
    this.spacing = 16,
  }) : type = ExamLoadingType.list;

  /// Factory constructor for grid loading
  const ExamLoadingWidget.grid({
    super.key,
    this.itemCount = 6,
    this.padding = const EdgeInsets.all(16),
    this.spacing = 16,
  }) : type = ExamLoadingType.grid;

  /// Factory constructor for featured exams loading
  const ExamLoadingWidget.featured({
    super.key,
    this.itemCount = 3,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.spacing = 16,
  }) : type = ExamLoadingType.featured;

  /// Factory constructor for exam detail loading
  const ExamLoadingWidget.detail({
    super.key,
    this.padding = const EdgeInsets.all(16),
  }) : type = ExamLoadingType.detail,
        itemCount = 1,
        spacing = 0;

  /// Factory constructor for search suggestions loading
  const ExamLoadingWidget.searchSuggestions({
    super.key,
    this.itemCount = 5,
    this.padding = const EdgeInsets.all(8),
    this.spacing = 8,
  }) : type = ExamLoadingType.searchSuggestions;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ExamLoadingType.list:
        return _buildListLoading();
      case ExamLoadingType.grid:
        return _buildGridLoading();
      case ExamLoadingType.featured:
        return _buildFeaturedLoading();
      case ExamLoadingType.detail:
        return _buildDetailLoading();
      case ExamLoadingType.searchSuggestions:
        return _buildSearchSuggestionsLoading();
    }
  }

  Widget _buildListLoading() {
    return Padding(
      padding: padding,
      child: Column(
        children: List.generate(
          itemCount,
          (index) => Container(
            margin: EdgeInsets.only(
              bottom: index < itemCount - 1 ? spacing : 0,
            ),
            child: const _ExamCardSkeleton(),
          ),
        ),
      ),
    );
  }

  Widget _buildGridLoading() {
    return Padding(
      padding: padding,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) => const _ExamGridItemSkeleton(),
      ),
    );
  }

  Widget _buildFeaturedLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header skeleton
        Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 140,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.surface.withAlpha((255 * 0.3).round()),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 60,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.surface.withAlpha((255 * 0.3).round()),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Featured items skeleton
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: padding,
            itemCount: itemCount,
            itemBuilder: (context, index) => Container(
              width: 240,
              margin: EdgeInsets.only(
                right: index < itemCount - 1 ? spacing : 0,
              ),
              child: const _ExamCardSkeleton(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailLoading() {
    return Padding(
      padding: padding,
      child: const _ExamDetailSkeleton(),
    );
  }

  Widget _buildSearchSuggestionsLoading() {
    return Padding(
      padding: padding,
      child: Column(
        children: List.generate(
          itemCount,
          (index) => Container(
            margin: EdgeInsets.only(
              bottom: index < itemCount - 1 ? spacing : 0,
            ),
            child: const _SearchSuggestionSkeleton(),
          ),
        ),
      ),
    );
  }
}

/// Skeleton widget for exam card in list view
class _ExamCardSkeleton extends StatelessWidget {
  const _ExamCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Title
            Container(
              width: double.infinity,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            
            // Description
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            
            // Metadata row
            Row(
              children: [
                Container(
                  width: 60,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 50,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 40,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Progress bar
            Container(
              width: double.infinity,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            
            // Action button
            Container(
              width: 100,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton widget for exam grid item
class _ExamGridItemSkeleton extends StatelessWidget {
  const _ExamGridItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 60,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Title
            Container(
              width: double.infinity,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            
            Container(
              width: 120,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Spacer(),
            
            // Metadata
            Row(
              children: [
                Container(
                  width: 40,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 30,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Progress
            Container(
              width: double.infinity,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/// Skeleton widget for exam detail
class _ExamDetailSkeleton extends StatelessWidget {
  const _ExamDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title section
        Container(
          width: double.infinity,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 16),
        
        // Metadata cards
        Row(
          children: [
            Expanded(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Description section
        Container(
          width: 120,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 12),
        
        ...List.generate(
          4,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Container(
              width: index == 3 ? 200 : double.infinity,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Action button
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}

/// Skeleton widget for search suggestions
class _SearchSuggestionSkeleton extends StatelessWidget {
  const _SearchSuggestionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

/// Enum defining different types of loading states
enum ExamLoadingType {
  /// Loading state for exam list view
  list,
  
  /// Loading state for exam grid view
  grid,
  
  /// Loading state for featured exams section
  featured,
  
  /// Loading state for exam detail page
  detail,
  
  /// Loading state for search suggestions
  searchSuggestions,
}