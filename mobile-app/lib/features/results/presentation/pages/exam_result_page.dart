import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/results_bloc.dart';
import '../bloc/results_event.dart';
import '../bloc/results_state.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class ExamResultPage extends StatefulWidget {
  final String examId;

  const ExamResultPage({Key? key, required this.examId}) : super(key: key);

  @override
  State<ExamResultPage> createState() => _ExamResultPageState();
}

class _ExamResultPageState extends State<ExamResultPage> {
  @override
  void initState() {
    super.initState();
    _loadExamAnalysis();
  }

  void _loadExamAnalysis() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<ResultsBloc>().add(
        LoadExamAnalysis(
          examId: widget.examId,
          userId: authState.user.id,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Result'),
        elevation: 0,
      ),
      body: BlocBuilder<ResultsBloc, ResultsState>(
        builder: (context, state) {
          if (state is ExamAnalysisLoading) {
            return const LoadingWidget();
          } else if (state is ExamAnalysisLoaded) {
            return _buildResultContent(state);
          } else if (state is ExamAnalysisError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: _loadExamAnalysis,
            );
          }
          return const Center(
            child: Text('No exam result data available'),
          );
        },
      ),
    );
  }

  Widget _buildResultContent(ExamAnalysisLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Score Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Your Score',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${state.analysis['score'] ?? 0}%',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: _getScoreColor(state.analysis['score'] ?? 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Analysis Details
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analysis',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _buildAnalysisItem(
                    'Total Questions',
                    '${state.analysis['totalQuestions'] ?? 0}',
                  ),
                  _buildAnalysisItem(
                    'Correct Answers',
                    '${state.analysis['correctAnswers'] ?? 0}',
                  ),
                  _buildAnalysisItem(
                    'Time Taken',
                    '${state.analysis['timeTaken'] ?? 0} minutes',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(num score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}