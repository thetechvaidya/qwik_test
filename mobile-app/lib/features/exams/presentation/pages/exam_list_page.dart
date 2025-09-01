import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../bloc/exam_bloc.dart';
import '../bloc/exam_event.dart';
import '../bloc/exam_state.dart';
import '../widgets/exam_card.dart';
import '../widgets/exam_grid_item.dart';
import '../widgets/exam_search_bar.dart';
import '../widgets/exam_filter_bar.dart';
import '../widgets/exam_sort_bottom_sheet.dart';
import '../widgets/featured_exams_section.dart';
import '../widgets/category_filter_chips.dart';

/// Main page for displaying exam listings with search, filters, and pagination
class ExamListPage extends StatefulWidget {
  const ExamListPage({super.key});

  @override
  State<ExamListPage> createState() => _ExamListPageState();
}

class _ExamListPageState extends State<ExamListPage> {
  late ScrollController _scrollController;
  late TextEditingController _searchController;
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    
    // Setup scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ExamBloc>().add(const LoadMoreExamsEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ExamBloc>()
        ..add(const LoadExamsEvent())
        ..add(const LoadCategoriesEvent())
        ..add(const LoadFeaturedExamsEvent()),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: BlocBuilder<ExamBloc, ExamState>(
          builder: (context, state) {
            if (state is ExamInitial || (state is ExamLoading && !state.isLoadingMore)) {
              return const LoadingWidget();
            }
            
            if (state is ExamError && state.previousState == null) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () => context.read<ExamBloc>().add(const RetryLoadingEvent()),
              );
            }
            
            if (state is ExamLoaded) {
              return _buildContent(context, state);
            }
            
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: _isSearchExpanded
          ? ExamSearchBar(
              controller: _searchController,
              onSearch: (query) {
                if (query.isNotEmpty) {
                  context.read<ExamBloc>().add(SearchExamsEvent(query: query));
                } else {
                  context.read<ExamBloc>().add(const ClearSearchEvent());
                }
              },
              onClear: () {
                _searchController.clear();
                context.read<ExamBloc>().add(const ClearSearchEvent());
                setState(() {
                  _isSearchExpanded = false;
                });
              },
            )
          : const Text('Exams'),
      actions: [
        if (!_isSearchExpanded)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearchExpanded = true;
              });
            },
          ),
        BlocBuilder<ExamBloc, ExamState>(
          builder: (context, state) {
            if (state is ExamLoaded) {
              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) => _handleMenuAction(context, value, state),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'sort',
                    child: Row(
                      children: const [
                        Icon(Icons.sort),
                        SizedBox(width: 8),
                        Text('Sort'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'view_mode',
                    child: Row(
                      children: [
                        Icon(state.viewMode == ExamViewMode.list
                            ? Icons.grid_view
                            : Icons.list),
                        const SizedBox(width: 8),
                        Text(state.viewMode == ExamViewMode.list
                            ? 'Grid View'
                            : 'List View'),
                      ],
                    ),
                  ),
                  if (state.hasFilters)
                    const PopupMenuItem(
                      value: 'clear_filters',
                      child: Row(
                        children: [
                          Icon(Icons.clear_all),
                          SizedBox(width: 8),
                          Text('Clear Filters'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'refresh',
                    child: Row(
                      children: [
                        Icon(Icons.refresh),
                        SizedBox(width: 8),
                        Text('Refresh'),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, ExamLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ExamBloc>().add(const RefreshExamsEvent());
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Featured exams section (only show when not searching)
          if (!state.isSearching && state.featuredExams.isNotEmpty)
            SliverToBoxAdapter(
              child: FeaturedExamsSection(
                exams: state.featuredExams,
                onExamTap: (exam) => _navigateToExamDetail(context, exam.id),
              ),
            ),
          
          // Categories filter chips
          if (state.categories.isNotEmpty)
            SliverToBoxAdapter(
              child: CategoryFilterChips(
                categories: state.categories,
                selectedCategoryId: state.filters.categoryId,
                onCategorySelected: (categoryId) {
                  context.read<ExamBloc>().add(ApplyFiltersEvent(
                    categoryId: categoryId,
                    difficulty: state.filters.difficulty,
                    examType: state.filters.examType,
                    isActive: state.filters.isActive,
                  ));
                },
              ),
            ),
          
          // Filter bar
          SliverToBoxAdapter(
            child: ExamFilterBar(
              filters: state.filters,
              sorting: state.sorting,
              onFiltersChanged: (filters) {
                context.read<ExamBloc>().add(ApplyFiltersEvent(
                  categoryId: filters.categoryId,
                  difficulty: filters.difficulty,
                  examType: filters.examType,
                  isActive: filters.isActive,
                ));
              },
              onSortChanged: (sorting) {
                context.read<ExamBloc>().add(ChangeSortingEvent(
                  sortBy: sorting.sortBy,
                  sortOrder: sorting.sortOrder,
                ));
              },
            ),
          ),
          
          // Search results or exam list
          _buildExamList(context, state),
          
          // Loading more indicator
          if (state.paginationState.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExamList(BuildContext context, ExamLoaded state) {
    final exams = state.currentExams;
    
    if (exams.isEmpty) {
      return SliverFillRemaining(
        child: EmptyStateWidget(
          icon: state.isSearching ? Icons.search_off : Icons.quiz_outlined,
          title: state.isSearching ? 'No search results' : 'No exams available',
          message: state.isSearching
              ? 'Try adjusting your search terms or filters'
              : 'Check back later for new exams',
          actionText: state.hasFilters ? 'Clear Filters' : null,
          onAction: state.hasFilters
              ? () => context.read<ExamBloc>().add(const ClearFiltersEvent())
              : null,
        ),
      );
    }
    
    if (state.viewMode == ExamViewMode.grid) {
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final exam = exams[index];
            return ExamGridItem(
              exam: exam,
              onTap: () => _navigateToExamDetail(context, exam.id),
              onFavoriteToggle: (isFavorite) {
                context.read<ExamBloc>().add(ToggleExamFavoriteEvent(
                  examId: exam.id,
                  isFavorite: isFavorite,
                ));
              },
            );
          },
          childCount: exams.length,
        ),
      );
    }
    
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final exam = exams[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExamCard(
              exam: exam,
              onTap: () => _navigateToExamDetail(context, exam.id),
              onStart: () {
                context.read<ExamBloc>().add(StartExamEvent(examId: exam.id));
              },
              onResume: () {
                context.read<ExamBloc>().add(ResumeExamEvent(examId: exam.id));
              },
              onFavoriteToggle: (isFavorite) {
                context.read<ExamBloc>().add(ToggleExamFavoriteEvent(
                  examId: exam.id,
                  isFavorite: isFavorite,
                ));
              },
            ),
          );
        },
        childCount: exams.length,
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action, ExamLoaded state) {
    switch (action) {
      case 'sort':
        _showSortBottomSheet(context, state);
        break;
      case 'view_mode':
        final newViewMode = state.viewMode == ExamViewMode.list
            ? ExamViewMode.grid
            : ExamViewMode.list;
        context.read<ExamBloc>().add(ChangeViewModeEvent(viewMode: newViewMode));
        break;
      case 'clear_filters':
        context.read<ExamBloc>().add(const ClearFiltersEvent());
        break;
      case 'refresh':
        context.read<ExamBloc>().add(const RefreshExamsEvent());
        break;
    }
  }

  void _showSortBottomSheet(BuildContext context, ExamLoaded state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ExamSortBottomSheet(
        currentSorting: state.sorting,
        onSortChanged: (sorting) {
          context.read<ExamBloc>().add(ChangeSortingEvent(
            sortBy: sorting.sortBy,
            sortOrder: sorting.sortOrder,
          ));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _navigateToExamDetail(BuildContext context, String examId) {
    // Navigate to exam detail page
    // Implementation depends on your navigation strategy
    Navigator.pushNamed(
      context,
      '/exam-detail',
      arguments: {'examId': examId},
    );
  }
}