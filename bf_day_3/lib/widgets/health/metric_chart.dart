import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

/// Placeholder chart container to be replaced with fl_chart widgets.
class MetricChartPlaceholder extends StatelessWidget {
  final String label;

  const MetricChartPlaceholder({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(label),
    );
  }
}

/// Simple static bar chart for steps (demo data).
class StepsBarChart extends StatelessWidget {
  const StepsBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final bars = <double>[1.2, 3.2, 4.5, 3.8, 5.0, 4.2, 4.6];
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(show: false),
        barGroups: [
          for (int i = 0; i < bars.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: bars[i],
                  width: 12,
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Simple static line chart for heart rate (demo data).
class HeartRateLineChart extends StatelessWidget {
  const HeartRateLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    final points = <Offset>[
      const Offset(0, 62),
      const Offset(10, 66),
      const Offset(20, 70),
      const Offset(30, 68),
      const Offset(40, 72),
      const Offset(50, 65),
      const Offset(60, 67),
      const Offset(70, 71),
      const Offset(80, 69),
    ];
    return SizedBox(
      width: 80,
      height: 50,
      child: CustomPaint(
        painter: _SparklinePainter(
          points: points,
          gradient: const LinearGradient(
            colors: [Color(0xFFFF8A80), Color(0xFFEF4444)],
          ),
        ),
      ),
    );
  }
}

/// Simple static bar chart for active energy (demo data).
class ActiveEnergyBarChart extends StatelessWidget {
  const ActiveEnergyBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final bars = <double>[200, 320, 450, 380, 500, 420, 460];
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(show: false),
        barGroups: [
          for (int i = 0; i < bars.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: bars[i],
                  width: 12,
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<Offset> points;
  final Gradient gradient;
  _SparklinePainter({required this.points, required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    // Normalize points to canvas size
    final minX = points.first.dx;
    final maxX = points.last.dx;
    double minY = points.first.dy;
    double maxY = points.first.dy;
    for (final p in points) {
      if (p.dy < minY) minY = p.dy;
      if (p.dy > maxY) maxY = p.dy;
    }
    final scaleX = size.width / (maxX - minX);
    final scaleY = size.height / (maxY - minY == 0 ? 1 : maxY - minY);
    final path = Path();
    Offset toCanvas(Offset p) =>
        Offset((p.dx - minX) * scaleX, size.height - (p.dy - minY) * scaleY);

    final smooth = <Offset>[for (final p in points) toCanvas(p)];
    path.moveTo(smooth.first.dx, smooth.first.dy);
    for (int i = 1; i < smooth.length; i++) {
      final prev = smooth[i - 1];
      final curr = smooth[i];
      final ctrl1 = Offset(prev.dx + (curr.dx - prev.dx) * 0.5, prev.dy);
      final ctrl2 = Offset(prev.dx + (curr.dx - prev.dx) * 0.5, curr.dy);
      path.cubicTo(ctrl1.dx, ctrl1.dy, ctrl2.dx, ctrl2.dy, curr.dx, curr.dy);
    }

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(Offset.zero & size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.gradient != gradient;
}

/// Animated circular progress ring with gradient stroke and center text.
class ProgressRing extends StatefulWidget {
  final double targetPercent; // 0..1
  final List<Color> gradientColors;
  const ProgressRing({
    super.key,
    required this.targetPercent,
    required this.gradientColors,
  });

  @override
  State<ProgressRing> createState() => _ProgressRingState();
}

class _ProgressRingState extends State<ProgressRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          final progress =
              (widget.targetPercent.clamp(0.0, 1.0)) * _animation.value;
          return CustomPaint(
            painter: _ProgressRingPainter(
              progress: progress,
              gradientColors: widget.gradientColors,
            ),
            child: Center(
              child: Text(
                '${(progress * 100).round()}%',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress; // 0..1
  final List<Color> gradientColors;
  _ProgressRingPainter({required this.progress, required this.gradientColors});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 8.0;
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = Colors.black.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweep = progress * 2 * math.pi;
    final startAngle = -math.pi / 2; // top

    // Background circle
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      2 * math.pi,
      false,
      bgPaint,
    );

    // Gradient progress
    final gradient = SweepGradient(
      colors: gradientColors,
      startAngle: 0,
      endAngle: 2 * math.pi,
    );
    final fgPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweep,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.gradientColors != gradientColors;
  }
}
