import 'package:flutter/material.dart';
import 'package:bubble_ds/bubble_ds.dart';
import '../benefits/repository.dart';
import '../benefits/models.dart';

class EligibleExpensesSheet extends StatefulWidget {
  const EligibleExpensesSheet({super.key});

  @override
  State<EligibleExpensesSheet> createState() => _EligibleExpensesSheetState();
}

class _EligibleExpensesSheetState extends State<EligibleExpensesSheet> {
  final TextEditingController _controller = TextEditingController();
  List<EligibleExpense> _results = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _controller.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onQueryChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final data = await BenefitsRepository().fetchEligibleExpenses();
    if (!mounted) return;
    setState(() {
      _results = data;
      _loading = false;
    });
  }

  Future<void> _onQueryChanged() async {
    final q = _controller.text;
    final data = await BenefitsRepository().searchEligibleExpenses(q);
    if (!mounted) return;
    setState(() {
      _results = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search expenses (e.g., gym, therapy, OTC)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: const BorderSide(),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _results.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final e = _results[index];
                return ListTile(
                  title: Text(e.title),
                  subtitle: Text(e.description),
                  trailing: Text(
                    e.code,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: BdsColors.onSurfaceTextVariant,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
