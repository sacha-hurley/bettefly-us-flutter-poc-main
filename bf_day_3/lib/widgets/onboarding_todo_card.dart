import 'package:flutter/material.dart';

// Design tokens per spec
class OnboardingColors {
  static const Color surfaceContainer = Color(0xFFFFFFFF);
  static const Color onSurfaceText = Color(0xFF0F1C14);
  static const Color onSurfaceTextVariant = Color(0xFF6F7772);
  static const Color outlineSubtle = Color(0xFFDBDDDC);
  static const Color iconSuccess = Color(0xFF00BF5D);
  static const Color dividerLight = Color(0xFFF5F6F6);
}

class OnboardingTextStyles {
  static const TextStyle titleBold = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.5,
    color: OnboardingColors.onSurfaceText,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.42,
  );
}

class OnboardingSpacing {
  static const double spacing02 = 8;
  static const double spacing04 = 16;
  static const double spacing06 = 24;
  static const double radius08 = 32;
}

/// Onboarding To-do Card
/// Pixel-perfect implementation per spec. Contains:
/// - Header with circular progress + titles
/// - Three task rows with specified states
/// - Exact dimensions, spacing, and colors
class OnboardingTodoCard extends StatefulWidget {
  const OnboardingTodoCard({super.key});

  @override
  State<OnboardingTodoCard> createState() => _OnboardingTodoCardState();
}

class _OnboardingTodoCardState extends State<OnboardingTodoCard> {
  // Three tasks to drive progress and leading status icons
  bool task1Completed = true; // Completed example
  bool task2Completed = false; // Incomplete
  bool task3Completed = false; // Incomplete

  @override
  Widget build(BuildContext context) {
    // Base card sized 327x300 with padding 24 and radius 32, border 0.5
    return Semantics(
      label: 'Onboarding, primeros pasos',
      container: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 327, maxWidth: 327),
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: ShapeDecoration(
              color: OnboardingColors.surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(OnboardingSpacing.radius08),
                side: const BorderSide(
                  color: OnboardingColors.outlineSubtle,
                  width: 0.5,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(OnboardingSpacing.spacing06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProgressHeader(
                    completed:
                        (task1Completed ? 1 : 0) +
                        (task2Completed ? 1 : 0) +
                        (task3Completed ? 1 : 0),
                    total: 3,
                  ),
                  const SizedBox(height: 13),
                  // Task 1 - Completed
                  _TaskRow(
                    height: 64,
                    paddingV: 12,
                    leading: const _CompletedStatusIcon(),
                    label: 'Completa tu encuesta de salud',
                    labelStyle: OnboardingTextStyles.bodyMedium.copyWith(
                      color: OnboardingColors.onSurfaceTextVariant,
                    ),
                    trailing: null,
                    onTap: () =>
                        setState(() => task1Completed = !task1Completed),
                  ),
                  const _DividerLine(),
                  // Task 2 - Incomplete
                  _TaskRow(
                    height: 64,
                    paddingV: 12,
                    leading: const _IncompleteStatusIcon(),
                    label: 'Descubre la cobertura de tu seguro',
                    labelStyle: OnboardingTextStyles.bodyMedium.copyWith(
                      color: OnboardingColors.onSurfaceText,
                    ),
                    trailing: null,
                    onTap: () =>
                        setState(() => task2Completed = !task2Completed),
                  ),
                  const _DividerLine(),
                  // Task 3 - Incomplete
                  _TaskRow(
                    height: 64,
                    paddingV: 12,
                    leading: const _IncompleteStatusIcon(),
                    label: 'Sincroniza tus dispositivos',
                    labelStyle: OnboardingTextStyles.bodyMedium.copyWith(
                      color: OnboardingColors.onSurfaceText,
                    ),
                    trailing: null,
                    onTap: () =>
                        setState(() => task3Completed = !task3Completed),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.completed, required this.total});
  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final double percent = total == 0 ? 0 : completed / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Primeros pasos', style: OnboardingTextStyles.titleBold),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: OnboardingColors.dividerLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percent.clamp(0.0, 1.0),
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: OnboardingColors.iconSuccess,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$completed/$total',
              style: OnboardingTextStyles.labelLarge.copyWith(
                color: OnboardingColors.onSurfaceTextVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.height,
    required this.paddingV,
    required this.leading,
    required this.label,
    required this.labelStyle,
    this.trailing,
    this.onTap,
  });

  final double height;
  final double paddingV;
  final Widget leading;
  final String label;
  final TextStyle labelStyle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: height),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: paddingV),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Center(child: leading),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: labelStyle,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Center(child: trailing),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      color: OnboardingColors.dividerLight,
      width: double.infinity,
    );
  }
}

class _CompletedStatusIcon extends StatelessWidget {
  const _CompletedStatusIcon();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: OnboardingColors.iconSuccess,
      ),
      width: 24,
      height: 24,
      child: const Center(
        child: Icon(Icons.check, size: 14, color: Colors.white),
      ),
    );
  }
}

class _IncompleteStatusIcon extends StatelessWidget {
  const _IncompleteStatusIcon();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(color: OnboardingColors.outlineSubtle, width: 1),
      ),
    );
  }
}

// Circular progress removed per updated spec (using horizontal bar)
