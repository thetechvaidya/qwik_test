import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/presentation/widgets/loading_widget.dart';
import '../../../../core/presentation/widgets/error_widget.dart';
import '../../domain/entities/search_result.dart';
import '../bloc/search_bloc.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/search_result_card.dart';
import '../widgets/search_filters.dart';
import '../widgets/search_history_widget.dart';

/// Dedicated search page for unified search across exams, quizzes, and categories
class SearchPage extends StatefulWidget {
  final String? initialQuery;
  final String? initialType;
  final String? initialCategoryId;

  const SearchPage({
    super.key,
    this.initialQuery,
    this.initialType,
    this.initialCategoryId,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  String? _selectedType;
  String? _selectedCategoryId;
  String? _selectedDifficulty;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _scrollController = ScrollController();
    _selectedType = widget.initialType;
    _selectedCategoryId = widget.initialCategoryId;
    
    // Setup scroll listener for pagination
    _scrollController.addListener(_onScroll);
    
    // Perform initial search if query is provided
    if (widget.initialQuery?.isNotEmpty == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _performSearch(widget.initialQuery!);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final state = context.read<SearchBloc>().state;
      if (state is SearchLoaded && state.hasMorePages && !state.isLoadingMore) {
        context.read<SearchBloc>().add(LoadMoreSearchResultsEvent());
      }
    }
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    
    context.read<SearchBloc>().add(
      PerformSearchEvent(
        query: query,
        type: _selectedType,
        categoryId: _selectedCategoryId,
        difficulty: _selectedDifficulty,
      ),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<SearchBloc>().add(const ClearSearchEvent());
  }

  void _applyFilters({
    String? type,
    String? categoryId,
    String? difficulty,
  }) {
    setState(() {
      _selectedType = type;
      _selectedCategoryId = categoryId;
      _selectedDifficulty = difficulty;
      _showFilters = false;
    });
    
    if (_searchController.text.isNotEmpty) {
      _performSearch(_searchController.text);
    }
  }

  void _onSearchResultTap(SearchResult result) {
    // Navigate based on result type
    switch (result.type) {
      case 'exam':
        context.push(AppRouter.examDetail.replaceAll(':examId', result.id));
        break;
      case 'quiz':
        // Navigate to quiz detail if implemented
        context.push('/quizzes/${result.id}'); // TODO: Add AppRouter constant for quizzes
        break;
      case 'category':
        // Navigate to category exams
        context.push('${AppRouter.exams}?categoryId=${result.id}');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SearchBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                _showFilters ? Icons.filter_list : Icons.filter_list_outlined,
              ),
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((255 * 0.05).round()),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SearchBarWidget(
                controller: _searchController,
                onSearch: _performSearch,
                onClear: _clearSearch,
                hintText: 'Search exams, quizzes, categories...',
              ),
            ),
            
            // Filters
            if (_showFilters)
              SearchFilters(
                selectedType: _selectedType,
                selectedCategoryId: _selectedCategoryId,
                selectedDifficulty: _selectedDifficulty,
                onFiltersChanged: _applyFilters,
              ),
            
            // Search Results
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return _buildInitialState();
                  } else if (state is SearchLoading) {
                    return const LoadingWidget();
                  } else if (state is SearchLoaded) {
                    return _buildSearchResults(state);
                  } else if (state is SearchError) {
                    return CustomErrorWidget(
                      message: state.message,
                      onRetry: () {
                        if (_searchController.text.isNotEmpty) {
                          _performSearch(_searchController.text);
                        }
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search History
          SearchHistoryWidget(
            onHistoryTap: (query) {
              _searchController.text = query;
              _performSearch(query);
            },
          ),
          
          const SizedBox(height: 24),
          
          // Search Tips
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Search Tips',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('• Search for exams, quizzes, or categories'),
                  const Text('• Use filters to narrow down results'),
                  const Text('• Try searching by topic or difficulty'),
                  const Text('• Recent searches are saved for quick access'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(SearchLoaded state) {
    if (state.results.isEmpty) {
      return _buildEmptyResults();
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (_searchController.text.isNotEmpty) {
          _performSearch(_searchController.text);
        }
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: state.results.length + (state.hasMorePages ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.results.length) {
            // Loading indicator for pagination
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          final result = state.results[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SearchResultCard(
              result: result,
              onTap: () => _onSearchResultTap(result),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search terms or filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedType = null;
                  _selectedCategoryId = null;
                  _selectedDifficulty = null;
                });
                if (_searchController.text.isNotEmpty) {
                  _performSearch(_searchController.text);
                }
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }
}