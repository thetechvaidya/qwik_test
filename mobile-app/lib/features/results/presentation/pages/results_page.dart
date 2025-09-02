import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/results_bloc.dart';
import '../widgets/exam_results_list.dart';
import '../widgets/performance_analytics_card.dart';
import '../widgets/study_recommendations_card.dart';
import '../widgets/results_filter_bar.dart';
import '../../domain/entities/exam_result.dart';
import '../../domain/entities/performance_analytics.dart';
import '../../domain/entities/study_recommendation.dart';

class ResultsPage extends StatefulWidget {
  final String userId;

  const ResultsPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    final bloc = context.read<ResultsBloc>();
    bloc.add(LoadExamResults(
      userId: widget.userId,
      limit: 20,
      offset: 0,
    ));
    bloc.add(LoadPerformanceAnalytics(
      userId: widget.userId,
      period: 'month',
    ));
    bloc.add(LoadStudyRecommendations(
      userId: widget.userId,
      limit: 5,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Results & Analytics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Theme.of(context).primaryColor,
          tabs: const [
            Tab(
              icon: Icon(Icons.quiz),
              text: 'Exam Results',
            ),
            Tab(
              icon: Icon(Icons.analytics),
              text: 'Analytics',
            ),
            Tab(
              icon: Icon(Icons.lightbulb),
              text: 'Recommendations',
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshData(),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildExamResultsTab(),
          _buildAnalyticsTab(),
          _buildRecommendationsTab(),
        ],
      ),
    );
  }

  Widget _buildExamResultsTab() {
    return BlocBuilder<ResultsBloc, ResultsState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async => _refreshExamResults(),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Filter Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ResultsFilterBar(
                    onFilterChanged: (filter) => _applyFilter(filter),
                    onSortChanged: (sort) => _applySort(sort),
                  ),
                ),
              ),
              
              // Results List
              if (state is ExamResultsLoaded)
                SliverToBoxAdapter(
                  child: ExamResultsList(
                    examResults: state.examResults,
                    isLoading: state.isRefreshing,
                    onResultTap: (result) => _showResultDetails(result),
                    onLoadMore: () => _loadMoreResults(),
                  ),
                )
              else if (state is ResultsLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (state is ResultsError)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading results',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _refreshExamResults(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnalyticsTab() {
    return BlocBuilder<ResultsBloc, ResultsState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async => _refreshAnalytics(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state is PerformanceAnalyticsLoaded)
                  PerformanceAnalyticsCard(
                    analytics: state.analytics,
                    onPeriodChanged: (period) => _changePeriod(period),
                  )
                else if (state is PerformanceAnalyticsLoading)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                else if (state is ResultsError)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading analytics',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _refreshAnalytics(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecommendationsTab() {
    return BlocBuilder<ResultsBloc, ResultsState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async => _refreshRecommendations(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state is StudyRecommendationsLoaded)
                  StudyRecommendationsCard(
                    recommendations: state.recommendations,
                    onRecommendationTap: (recommendation) =>
                        _handleRecommendation(recommendation),
                  )
                else if (state is StudyRecommendationsLoading)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                else if (state is ResultsError)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading recommendations',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _refreshRecommendations(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _refreshData() {
    context.read<ResultsBloc>().add(RefreshResults(userId: widget.userId));
  }

  void _refreshExamResults() {
    context.read<ResultsBloc>().add(LoadExamResults(
          userId: widget.userId,
          limit: 20,
          offset: 0,
        ));
  }

  void _refreshAnalytics() {
    context.read<ResultsBloc>().add(LoadPerformanceAnalytics(
          userId: widget.userId,
          period: 'month',
        ));
  }

  void _refreshRecommendations() {
    context.read<ResultsBloc>().add(LoadStudyRecommendations(
          userId: widget.userId,
          limit: 5,
        ));
  }

  void _applyFilter(Map<String, dynamic> filter) {
    context.read<ResultsBloc>().add(FilterExamResults(
          userId: widget.userId,
          filter: filter,
        ));
  }

  void _applySort(Map<String, dynamic> sort) {
    context.read<ResultsBloc>().add(SortExamResults(
          userId: widget.userId,
          sort: sort,
        ));
  }

  void _loadMoreResults() {
    final state = context.read<ResultsBloc>().state;
    if (state is ExamResultsLoaded) {
      context.read<ResultsBloc>().add(LoadExamResults(
            userId: widget.userId,
            limit: 20,
            offset: state.examResults.length,
          ));
    }
  }

  void _changePeriod(String period) {
    context.read<ResultsBloc>().add(LoadPerformanceAnalytics(
          userId: widget.userId,
          period: period,
        ));
  }

  void _showResultDetails(ExamResult result) {
    context.read<ResultsBloc>().add(LoadExamAnalysis(
          userId: widget.userId,
          examId: result.examId,
        ));
    
    Navigator.of(context).pushNamed(
      '/exam-result-details',
      arguments: result,
    );
  }

  void _handleRecommendation(StudyRecommendation recommendation) {
    // Navigate to study material or practice based on recommendation
    switch (recommendation.type) {
      case 'practice':
        Navigator.of(context).pushNamed(
          '/practice',
          arguments: {
            'subject': recommendation.subject,
            'topics': recommendation.topics,
          },
        );
        break;
      case 'study':
        Navigator.of(context).pushNamed(
          '/study',
          arguments: {
            'subject': recommendation.subject,
            'topics': recommendation.topics,
          },
        );
        break;
      case 'review':
        Navigator.of(context).pushNamed(
          '/review',
          arguments: {
            'subject': recommendation.subject,
            'topics': recommendation.topics,
          },
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening ${recommendation.title}...'),
          ),
        );
    }
  }
}