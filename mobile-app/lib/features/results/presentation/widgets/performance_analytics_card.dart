import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/performance_analytics.dart';

class PerformanceAnalyticsCard extends StatefulWidget {
  final PerformanceAnalytics analytics;
  final Function(String)? onPeriodChanged;

  const PerformanceAnalyticsCard({
    Key? key,
    required this.analytics,
    this.onPeriodChanged,
  }) : super(key: key);

  @override
  State<PerformanceAnalyticsCard> createState() => _PerformanceAnalyticsCardState();
}

class _PerformanceAnalyticsCardState extends State<PerformanceAnalyticsCard> {
  String selectedPeriod = 'month';
  String selectedChart = 'score';

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildSummaryStats(context),
            const SizedBox(height: 24),
            _buildChartControls(context),
            const SizedBox(height: 16),
            _buildChart(context),
            const SizedBox(height: 20),
            _buildSubjectBreakdown(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.analytics,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Performance Analytics',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        DropdownButton<String>(
          value: selectedPeriod,
          underline: const SizedBox(),
          items: const [
            DropdownMenuItem(value: 'week', child: Text('Week')),
            DropdownMenuItem(value: 'month', child: Text('Month')),
            DropdownMenuItem(value: 'quarter', child: Text('Quarter')),
            DropdownMenuItem(value: 'year', child: Text('Year')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => selectedPeriod = value);
              widget.onPeriodChanged?.call(value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildSummaryStats(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Average Score',
                  '${widget.analytics.averageScore.toStringAsFixed(1)}%',
                  Icons.trending_up,
                  _getScoreColor(widget.analytics.averageScore),
                  widget.analytics.scoreImprovement,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Total Exams',
                  widget.analytics.totalExams.toString(),
                  Icons.quiz,
                  Colors.blue,
                  null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Accuracy Rate',
                  '${(widget.analytics.accuracyRate * 100).toStringAsFixed(1)}%',
                  Icons.target,
                  Colors.green,
                  widget.analytics.accuracyImprovement,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Study Time',
                  '${widget.analytics.totalStudyTime}h',
                  Icons.schedule,
                  Colors.orange,
                  null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    double? improvement,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
          textAlign: TextAlign.center,
        ),
        if (improvement != null) ..[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                improvement >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                size: 12,
                color: improvement >= 0 ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 2),
              Text(
                '${improvement.abs().toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: improvement >= 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildChartControls(BuildContext context) {
    return Row(
      children: [
        Text(
          'Chart Type:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChartTypeChip('Score', 'score'),
                const SizedBox(width: 8),
                _buildChartTypeChip('Accuracy', 'accuracy'),
                const SizedBox(width: 8),
                _buildChartTypeChip('Speed', 'speed'),
                const SizedBox(width: 8),
                _buildChartTypeChip('Progress', 'progress'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartTypeChip(String label, String value) {
    final isSelected = selectedChart == value;
    return GestureDetector(
      onTap: () => setState(() => selectedChart = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    if (widget.analytics.performanceHistory.isEmpty) {
      return Container(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No performance data available',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 20,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey[300]!,
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey[300]!,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < widget.analytics.performanceHistory.length) {
                    final date = widget.analytics.performanceHistory.keys.elementAt(index);
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        _formatChartDate(date),
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      '${value.toInt()}${_getChartUnit()}',
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          minX: 0,
          maxX: widget.analytics.performanceHistory.length.toDouble() - 1,
          minY: 0,
          maxY: _getChartMaxY(),
          lineBarsData: [
            LineChartBarData(
              spots: _getChartSpots(),
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.3),
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Theme.of(context).primaryColor,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.2),
                    Theme.of(context).primaryColor.withOpacity(0.05),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectBreakdown(BuildContext context) {
    if (widget.analytics.subjectPerformance.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subject Performance',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ...widget.analytics.subjectPerformance.entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildSubjectItem(context, entry.key, entry.value),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectItem(BuildContext context, String subject, double score) {
    final color = _getSubjectColor(subject);
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            subject,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          '${score.toStringAsFixed(1)}%',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: LinearProgressIndicator(
            value: score / 100,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  List<FlSpot> _getChartSpots() {
    return widget.analytics.performanceHistory.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value.value;
      double value;
      
      switch (selectedChart) {
        case 'accuracy':
          value = data['accuracy'] ?? 0.0;
          break;
        case 'speed':
          value = data['speed'] ?? 0.0;
          break;
        case 'progress':
          value = data['progress'] ?? 0.0;
          break;
        default:
          value = data['score'] ?? 0.0;
      }
      
      return FlSpot(index.toDouble(), value);
    }).toList();
  }

  double _getChartMaxY() {
    switch (selectedChart) {
      case 'speed':
        return 10; // questions per minute
      case 'progress':
        return 100; // percentage
      default:
        return 100; // percentage
    }
  }

  String _getChartUnit() {
    switch (selectedChart) {
      case 'speed':
        return 'q/m';
      default:
        return '%';
    }
  }

  String _formatChartDate(DateTime date) {
    switch (selectedPeriod) {
      case 'week':
        return '${date.day}/${date.month}';
      case 'month':
        return '${date.day}/${date.month}';
      case 'quarter':
        return '${date.month}/${date.year.toString().substring(2)}';
      case 'year':
        return date.year.toString();
      default:
        return '${date.day}/${date.month}';
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.lightGreen;
    if (score >= 70) return Colors.orange;
    if (score >= 60) return Colors.deepOrange;
    return Colors.red;
  }

  Color _getSubjectColor(String subject) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    return colors[subject.hashCode % colors.length];
  }
}