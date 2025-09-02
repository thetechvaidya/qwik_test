import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/performance_trend.dart';

class PerformanceTrendsChart extends StatefulWidget {
  final List<PerformanceTrend> trends;
  final String title;

  const PerformanceTrendsChart({
    Key? key,
    required this.trends,
    this.title = 'Performance Trends',
  }) : super(key: key);

  @override
  State<PerformanceTrendsChart> createState() => _PerformanceTrendsChartState();
}

class _PerformanceTrendsChartState extends State<PerformanceTrendsChart> {
  String selectedPeriod = 'week';
  String selectedMetric = 'score';

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
            _buildFilters(context),
            const SizedBox(height: 20),
            _buildChart(context),
            const SizedBox(height: 16),
            _buildLegend(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.trending_up,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => _showInfoDialog(context),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildFilterChip(
            'Period',
            selectedPeriod,
            ['day', 'week', 'month', 'year'],
            (value) => setState(() => selectedPeriod = value),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildFilterChip(
            'Metric',
            selectedMetric,
            ['score', 'accuracy', 'speed', 'improvement'],
            (value) => setState(() => selectedMetric = value),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    String label,
    String selected,
    List<String> options,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selected,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          items: options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(
                option.toUpperCase(),
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
          onChanged: (value) => onChanged(value!),
        ),
      ],
    );
  }

  Widget _buildChart(BuildContext context) {
    if (widget.trends.isEmpty) {
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
                  if (index >= 0 && index < widget.trends.length) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        _formatDate(widget.trends[index].date),
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
                      '${value.toInt()}%',
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
          maxX: widget.trends.length.toDouble() - 1,
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: _getSpots(),
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

  Widget _buildLegend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _getMetricLabel(selectedMetric),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  List<FlSpot> _getSpots() {
    return widget.trends.asMap().entries.map((entry) {
      final index = entry.key;
      final trend = entry.value;
      double value;
      
      switch (selectedMetric) {
        case 'accuracy':
          value = trend.accuracy;
          break;
        case 'speed':
          value = trend.averageSpeed;
          break;
        case 'improvement':
          value = trend.improvementRate;
          break;
        default:
          value = trend.averageScore;
      }
      
      return FlSpot(index.toDouble(), value);
    }).toList();
  }

  String _formatDate(DateTime date) {
    switch (selectedPeriod) {
      case 'day':
        return '${date.day}/${date.month}';
      case 'week':
        return 'W${_getWeekOfYear(date)}';
      case 'month':
        return '${date.month}/${date.year.toString().substring(2)}';
      case 'year':
        return date.year.toString();
      default:
        return '${date.day}/${date.month}';
    }
  }

  int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).ceil();
  }

  String _getMetricLabel(String metric) {
    switch (metric) {
      case 'accuracy':
        return 'Accuracy Rate (%)';
      case 'speed':
        return 'Average Speed (questions/min)';
      case 'improvement':
        return 'Improvement Rate (%)';
      default:
        return 'Average Score (%)';
    }
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Performance Trends'),
        content: const Text(
          'This chart shows your performance trends over time. '
          'You can filter by different time periods and metrics to '
          'analyze your learning progress.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}