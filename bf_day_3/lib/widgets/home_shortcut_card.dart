import 'package:flutter/material.dart';
import 'package:bubble_ds/bubble_ds.dart';

class HomeShortcutCard extends StatelessWidget {
  final Color headerIconBg;
  final IconData headerIcon;
  final String title;
  final String leftValue;
  final String leftCaption;
  final String rightValue;
  final String rightCaption;
  final String ctaLabel;
  final VoidCallback onTap;

  const HomeShortcutCard({
    super.key,
    required this.headerIconBg,
    required this.headerIcon,
    required this.title,
    required this.leftValue,
    required this.leftCaption,
    required this.rightValue,
    required this.rightCaption,
    required this.ctaLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: onTap,
        child: Ink(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
              side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23),
                  child: SizedBox(
                    height: 52,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: headerIconBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Icon(
                              headerIcon,
                              size: 20,
                              color: BdsColors.onSurfaceText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23),
                  child: Row(
                    children: [
                      Expanded(
                        child: _Metric(value: leftValue, caption: leftCaption),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _Metric(
                          value: rightValue,
                          caption: rightCaption,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23),
                  child: SizedBox(
                    height: 37,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          ctaLabel,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            height: 1.5,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String value;
  final String caption;
  const _Metric({required this.value, required this.caption});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 1.5,
          ),
        ),
        Text(
          caption,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF4A5565),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
