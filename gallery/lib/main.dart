import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:bf_design_system/bf_design_system.dart';

void main() => runApp(const Gallery());

class Gallery extends StatelessWidget {
  const Gallery({super.key});
  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: [
        WidgetbookFolder(name: 'Tokens', children: [
          WidgetbookComponent(name: 'Colors', useCases: [
            WidgetbookUseCase(name: 'Swatches', builder: (context) {
              final colors = Theme.of(context).extension<BFColors>()!;
              final swatches = [
                (colors.brand, 'brand'),
                (colors.brandOn, 'brandOn'),
                (colors.bg, 'bg'),
                (colors.textPrimary, 'textPrimary'),
                (colors.textSecondary, 'textSecondary'),
                (colors.success, 'success'),
                (colors.warning, 'warning'),
                (colors.error, 'error'),
              ];
              return GridView.count(
                crossAxisCount: 3,
                children: [
                  for (final item in swatches)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: item.$1,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(item.$2),
                        ],
                      ),
                    ),
                ],
              );
            }),
          ]),
        ]),
        WidgetbookFolder(name: 'Components', children: [
          WidgetbookComponent(name: 'BFPrimaryButton', useCases: [
            WidgetbookUseCase(
              name: 'Default',
              builder: (context) => Center(
                child: BFPrimaryButton(label: 'Primary', onPressed: () {}),
              ),
            ),
            WidgetbookUseCase(
              name: 'Long label',
              builder: (context) => Center(
                child: BFPrimaryButton(label: 'Primary action with long label', onPressed: () {}),
              ),
            ),
          ]),
        ]),
      ],
      appBuilder: (context, child) => MaterialApp(
        theme: BfTheme.light(),
        darkTheme: BfTheme.dark(),
        themeMode: ThemeMode.system,
        home: Scaffold(body: child),
      ),
    );
  }
}
