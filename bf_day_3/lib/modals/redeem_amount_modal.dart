import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../currency/exchange_rate.dart';

/// RedeemAmountModal – follow-up modal to select BetterFlies amount with
/// real-time conversion to LSA Credit. Designed to be shown via a DialogRoute
/// with a persistent dark overlay to match the first redeem modal.
class RedeemAmountModal extends StatefulWidget {
  final int currentBalance;
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final VoidCallback? onCancel;
  final Function(int betterFlies, double dollarAmount)? onConfirm;

  const RedeemAmountModal({
    super.key,
    required this.currentBalance,
    this.onBack,
    this.onClose,
    this.onCancel,
    this.onConfirm,
  });

  @override
  State<RedeemAmountModal> createState() => _RedeemAmountModalState();
}

class _RedeemAmountModalState extends State<RedeemAmountModal> {
  // Controllers and state
  final TextEditingController _amountController = TextEditingController();

  // Defaults per spec
  int selectedAmount = 100; // Default to 100 BFs
  double calculatedDollars = 1.0; // 100 BFs = $1.00
  bool termsAgreed = false;
  bool redemptionDetailsVisible = false;
  int? selectedQuickAmount; // Track selected quick button

  // Color tokens per spec
  static const Color primaryText = Color(0xFF101828);
  static const Color secondaryText = Color(0xFF4A5565);
  static const Color tertiaryText = Color(0xFF717182);
  static const Color balanceBlue = Color(0xFF2B7FFF);
  static const Color primaryButton = Color(0xFF0F1C14);
  // static const Color dividerColor = Color(0xFFDBDDDC); // Unused; keep spec reference without warning

  // Conversion Card
  static const Color conversionBackground = Color.fromRGBO(242, 242, 235, 0.5);
  static const Color detailsBackground = Color.fromRGBO(242, 242, 235, 0.3);
  static const Color conversionText = Color(0xFF74746A);

  // Quick Amount Button
  static const Color quickButtonBackground = Color(0xFFF9F9F5);
  static const Color quickButtonBorder = Color(0xFFE6E6DE);
  static const Color quickButtonText = Color(0xFF0B0B04);

  // Input
  static const Color inputPlaceholder = Color(0xFF6F7772);
  static const Color inputBorder = Color(0xFFDBDDDC);

  @override
  void initState() {
    super.initState();
    _amountController.text = '100';
    _amountController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    super.dispose();
  }

  // Business logic: real-time conversion calculation
  void _onAmountChanged() {
    final text = _amountController.text;
    if (text.isEmpty) {
      setState(() {
        selectedAmount = 0;
        calculatedDollars = 0.0;
      });
      return;
    }

    final int amount = int.tryParse(text) ?? 0;
    setState(() {
      selectedAmount = amount;
      // Use single source of truth conversion
      calculatedDollars = bfsToUsd(amount);
      selectedQuickAmount = null; // Clear quick selection when typing
    });
  }

  // Quick amount handler
  void _onQuickAmountSelected(int amount) {
    setState(() {
      selectedAmount = amount;
      selectedQuickAmount = amount;
      // Use single source of truth conversion
      calculatedDollars = bfsToUsd(amount);
      _amountController.text = amount.toString();
    });
  }

  // Validation
  bool _isValidAmount() {
    return selectedAmount >= 100 && selectedAmount <= widget.currentBalance;
  }

  bool _canConfirm() {
    return _isValidAmount() && termsAgreed && selectedAmount > 0;
  }

  String _formatDollarAmount(double amount) => amount.toStringAsFixed(2);

  InputDecoration _buildInputDecoration() {
    final bool hasError = selectedAmount > 0 && !_isValidAmount();
    return InputDecoration(
      hintText: 'Enter amount',
      hintStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: inputPlaceholder,
        height: 1.5,
      ),
      isDense: true,
      contentPadding: EdgeInsets.zero,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: inputBorder, width: 1),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: inputBorder, width: 1),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1),
      ),
      errorText: hasError
          ? 'Amount must be between 100 and ${widget.currentBalance}'
          : null,
      errorStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.red,
        height: 16 / 12,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        backgroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 384,
            maxHeight: MediaQuery.of(context).size.height - 48,
          ),
          child: Semantics(
            namesRoute: true,
            label: 'Select amount to redeem dialog',
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        // Back button
                        InkWell(
                          onTap: widget.onBack,
                          borderRadius: BorderRadius.circular(14),
                          child: const SizedBox(
                            width: 28,
                            height: 28,
                            child: Center(
                              child: Icon(
                                Icons.chevron_left,
                                size: 24,
                                color: primaryText,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Select amount to redeem',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: primaryText,
                              height: 28 / 18,
                            ),
                          ),
                        ),
                        // Close button 28x28, radius 10
                        _CloseButton(
                          onTap:
                              widget.onClose ??
                              () => Navigator.of(context).maybePop(),
                        ),
                      ],
                    ),
                  ),

                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Current balance row
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Current balance',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: tertiaryText,
                                    height: 20 / 14,
                                  ),
                                ),
                              ),
                              Text(
                                '${_formatNumber(widget.currentBalance)} BFs',
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: balanceBlue,
                                  height: 20 / 14,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Amount selection label
                          const Text(
                            'Select your amount',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: secondaryText,
                              height: 20 / 14,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Quick amount grid 2x2 (8px gap)
                          _QuickAmountGrid(
                            amounts: _buildQuickAmounts(),
                            selectedAmount: selectedQuickAmount,
                            onSelected: _onQuickAmountSelected,
                          ),

                          const SizedBox(height: 16),

                          // Custom input field (numeric only)
                          TextField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: false,
                              decimal: false,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: inputPlaceholder,
                              height: 1.5,
                            ),
                            decoration: _buildInputDecoration(),
                          ),

                          const SizedBox(height: 16),

                          // Conversion section
                          const Text(
                            'You will receive',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: secondaryText,
                              height: 20 / 14,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Container(
                            decoration: BoxDecoration(
                              color: conversionBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.info_outline,
                                      size: 16,
                                      color: conversionText,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Conversion',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: conversionText,
                                        height: 20 / 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '= \$${_formatDollarAmount(calculatedDollars)} LSA Credit',
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: conversionText,
                                    height: 28 / 20,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '1,000 BetterFlies = \$${(1000 / kBfsPerDollar).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: conversionText,
                                    height: 16 / 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Redemption details (collapsible)
                          TextButton(
                            onPressed: () => setState(
                              () => redemptionDetailsVisible =
                                  !redemptionDetailsVisible,
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: conversionText,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              redemptionDetailsVisible
                                  ? 'Hide redemption details'
                                  : 'Show redemption details',
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: conversionText,
                                height: 20 / 14,
                              ),
                            ),
                          ),

                          if (redemptionDetailsVisible) ...[
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: detailsBackground,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: const Text(
                                'Redeemed credits will be added to your LSA account within 24 hours. Minimum redemption amount is 100 BetterFlies. All transactions are final.',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: conversionText,
                                  height: 22.75 / 14,
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 16),

                          // Terms agreement
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 28,
                                height: 18,
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    checkboxTheme: CheckboxThemeData(
                                      side: const BorderSide(
                                        color: Color(0xFF0F1C14),
                                        width: 1.5,
                                      ),
                                      fillColor:
                                          WidgetStateProperty.resolveWith<
                                            Color?
                                          >((states) {
                                            if (states.contains(
                                              WidgetState.selected,
                                            )) {
                                              return const Color(0xFF0F1C14);
                                            }
                                            return Colors.white;
                                          }),
                                      checkColor:
                                          const WidgetStatePropertyAll<Color>(
                                            Colors.white,
                                          ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                  child: Checkbox(
                                    value: termsAgreed,
                                    onChanged: (bool? v) => setState(
                                      () => termsAgreed = v ?? false,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [_TermsText()],
                                ),
                              ),
                            ],
                          ),
                          // Extra space at bottom inside scroll so divider isn't too tight
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),

                  // Actions
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(height: 1, color: const Color(0xFF262626)),
                        const SizedBox(height: 17),

                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: _canConfirm()
                                ? () => widget.onConfirm?.call(
                                    selectedAmount,
                                    calculatedDollars,
                                  )
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryButton,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade400,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                            child: Text(
                              'Confirm (\$${_formatDollarAmount(calculatedDollars)})',
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        SizedBox(
                          height: 40,
                          child: OutlinedButton(
                            onPressed:
                                widget.onCancel ??
                                () => Navigator.of(context).maybePop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primaryButton,
                              side: const BorderSide(
                                color: primaryButton,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<int> _buildQuickAmounts() {
    final int max = widget.currentBalance;
    // Required buttons: 100, 200, 500, and Max(balance)
    final List<int> base = [100, 200, 500, max];
    // Ensure values are within 100..max and unique, keeping order
    final seen = <int>{};
    final list = <int>[];
    for (final v in base) {
      if (v >= 100 && v <= max && !seen.contains(v)) {
        seen.add(v);
        list.add(v);
      }
    }
    return list;
  }

  String _formatNumber(int value) {
    final String s = value.toString();
    final StringBuffer buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final int idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) {
        buf.write(',');
      }
    }
    return buf.toString();
  }
}

class _QuickAmountGrid extends StatelessWidget {
  final List<int> amounts;
  final int? selectedAmount;
  final ValueChanged<int> onSelected;

  const _QuickAmountGrid({
    required this.amounts,
    required this.selectedAmount,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Build a 2x2 grid (or fewer if balance < required amounts)
    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth = (constraints.maxWidth - 8) / 2;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: amounts.take(4).map((amount) {
            final bool isSelected = selectedAmount == amount;
            return SizedBox(
              width: itemWidth,
              height: 48,
              child: OutlinedButton(
                onPressed: () => onSelected(amount),
                style: OutlinedButton.styleFrom(
                  backgroundColor: isSelected
                      ? const Color(0xFFEDEDE7)
                      : _RedeemAmountModalState.quickButtonBackground,
                  side: BorderSide(
                    color: isSelected
                        ? _RedeemAmountModalState.primaryButton
                        : _RedeemAmountModalState.quickButtonBorder,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  amount == amounts.last
                      ? 'Max (${_formatNumber(amount)})'
                      : _formatNumber(amount),
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _RedeemAmountModalState.quickButtonText,
                    height: 20 / 14,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  String _formatNumber(int value) {
    final String s = value.toString();
    final StringBuffer buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final int idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) {
        buf.write(',');
      }
    }
    return buf.toString();
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Close dialog',
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.center,
          child: const Icon(Icons.close, size: 16, color: Color(0xFF101828)),
        ),
      ),
    );
  }
}

class _TermsText extends StatelessWidget {
  const _TermsText();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: const [
        Text(
          'I agree to the ',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF0B0B04),
            height: 22.75 / 14,
          ),
        ),
        Text(
          'Terms of Service',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0B0B04),
            height: 22.75 / 14,
            decoration: TextDecoration.underline,
          ),
        ),
        Text(
          ' for currency redemption',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF0B0B04),
            height: 22.75 / 14,
          ),
        ),
      ],
    );
  }
}
