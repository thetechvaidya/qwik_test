import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/user_stats_card.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';

class DashboardPage extends StatefulWidget {
  final String userId;

  const DashboardPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    context.read<DashboardBloc>().add(
          LoadDashboardData(userId: widget.userId),
        );
  }

  void _refreshDashboard() {
    context.read<DashboardBloc>().add(
          RefreshDashboardData(userId: widget.userId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: _loadDashboardData,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const LoadingWidget();
          }

          if (state is DashboardError && state.previousData == null) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: _loadDashboardData,
            );
          }

          if (state is DashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () async => _refreshDashboard(),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: true,
                    pinned: true,
                    backgroundColor: Theme.of(context).primaryColor,
                    flexibleSpace: FlexibleSpaceBar(
                      title: const Text(
                        'Dashboard',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      if (state.isRefreshing)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          onPressed: _refreshDashboard,
                        ),
                    ],
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Dashboard Header with Summary
                        DashboardHeader(
                          dashboardData: state.dashboardData,
                          userId: widget.userId,
                        ),
                        const SizedBox(height: 16),
                        
                        // User Stats Card
                        if (state.userStats != null)
                          UserStatsCard(userStats: state.userStats!),
                        const SizedBox(height: 32),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Welcome to your Dashboard'),
          );
        },
      ),
    );
  }
}