import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/hourly_steps_data.dart';

/// A dynamic vertical bar chart widget for displaying hourly steps data
///
/// Features:
/// - Dynamic Y-axis scaling based on maximum steps
/// - Only shows hours with steps (no empty hours)
/// - Smooth animations and interactions
/// - Matches app design system colors
class StepsBarChart extends StatelessWidget {
  /// List of hourly steps data to display
  final List<HourlyStepsData> hourlyData;

  /// Height of the chart
  final double height;

  /// Whether to show animations
  final bool animate;

  const StepsBarChart({
    super.key,
    required this.hourlyData,
    this.height = 145.0,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    // If no data, show a placeholder
    if (hourlyData.isEmpty) {
      return _buildEmptyState();
    }

    return SizedBox(
      height: height,
      width: double.infinity,
      child: BarChart(
        _buildBarChartData(),
        swapAnimationDuration: animate
            ? const Duration(milliseconds: 300)
            : Duration.zero,
        swapAnimationCurve: Curves.easeInOut,
      ),
    );
  }

  /// Build the bar chart data configuration
  BarChartData _buildBarChartData() {
    final maxSteps = HourlyStepsData.getMaxSteps(hourlyData);

    return BarChartData(
      // Configure the chart alignment and spacing
      alignment: BarChartAlignment.spaceBetween,
      maxY: maxSteps.toDouble(),

      // Add margins for better spacing
      groupsSpace: 8, // Space between bar groups
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final data = hourlyData[groupIndex];
            return BarTooltipItem(
              '${data.steps} steps\n${data.label}',
              const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            );
          },
        ),
      ),

      // Configure the bars
      barGroups: _buildBarGroups(),

      // Configure the axes
      titlesData: _buildTitlesData(),

      // Configure the grid
      gridData: _buildGridData(),

      // Configure the border
      borderData: _buildBorderData(),

      // Configure the background
      backgroundColor: Colors.transparent,
    );
  }

  /// Build the bar groups (individual bars)
  List<BarChartGroupData> _buildBarGroups() {
    return hourlyData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;

      return BarChartGroupData(
        x: index, // X position (0, 1, 2, etc.)
        barRods: [
          BarChartRodData(
            toY: data.steps.toDouble(),
            color: _getBarColor(data.steps),
            width: 16, // Slightly narrower bars for better spacing
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(3),
              topRight: Radius.circular(3),
            ),
            // Add gradient for visual appeal
            gradient: _getBarGradient(data.steps),
          ),
        ],
      );
    }).toList();
  }

  /// Build the titles (labels) for axes
  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      // Left side Y-axis (step counts)
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 35, // Reduced from 40
          getTitlesWidget: _getLeftTitles,
        ),
      ),

      // Bottom X-axis (hour labels)
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 25, // Reduced from 30
          getTitlesWidget: _getBottomTitles,
        ),
      ),

      // Hide top and right titles
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  /// Build the grid lines
  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      horizontalInterval: _getGridInterval(),
      verticalInterval: 1,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: const Color(0xFFE5E7EB).withOpacity(0.3),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: const Color(0xFFE5E7EB).withOpacity(0.1),
          strokeWidth: 1,
        );
      },
    );
  }

  /// Build the border configuration
  FlBorderData _buildBorderData() {
    return FlBorderData(
      show: false, // We'll handle borders with grid lines
    );
  }

  /// Get the color for a bar based on step count
  Color _getBarColor(int steps) {
    // Use different shades of blue based on step count
    if (steps < 100) return const Color(0xFF7DD3FC); // Light blue
    if (steps < 500) return const Color(0xFF3B82F6); // Medium blue
    return const Color(0xFF1D4ED8); // Dark blue
  }

  /// Get the gradient for a bar based on step count
  LinearGradient _getBarGradient(int steps) {
    final baseColor = _getBarColor(steps);
    return LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [baseColor.withOpacity(0.3), baseColor],
    );
  }

  /// Get the grid interval for Y-axis
  double _getGridInterval() {
    final maxSteps = HourlyStepsData.getMaxSteps(hourlyData);
    if (maxSteps <= 100) return 25;
    if (maxSteps <= 500) return 100;
    if (maxSteps <= 1000) return 200;
    return 500;
  }

  /// Get the left side titles (Y-axis step counts)
  Widget _getLeftTitles(double value, TitleMeta meta) {
    if (value == meta.max) return const SizedBox.shrink();

    // Only show every other grid line to reduce clutter
    final maxSteps = HourlyStepsData.getMaxSteps(hourlyData);
    final interval = _getGridInterval();
    if (value % interval != 0) return const SizedBox.shrink();

    return Text(
      value.toInt().toString(),
      style: const TextStyle(
        color: Color(0xFF717182),
        fontSize: 9, // Slightly smaller font
        fontWeight: FontWeight.w400,
      ),
    );
  }

  /// Get the bottom titles (X-axis hour labels)
  Widget _getBottomTitles(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index < 0 || index >= hourlyData.length) return const SizedBox.shrink();

    // Only show every other hour label to reduce clutter
    if (index % 2 != 0) return const SizedBox.shrink();

    return Text(
      hourlyData[index].label,
      style: const TextStyle(
        color: Color(0xFF717182),
        fontSize: 9, // Slightly smaller font
        fontWeight: FontWeight.w400,
      ),
    );
  }

  /// Build empty state when no data is available
  Widget _buildEmptyState() {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_walk_outlined,
              color: Color(0xFF9CA3AF),
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              'No steps data yet',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
