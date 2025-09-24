import 'package:flutter/material.dart';

/// RedeemModal – Centered dialog for selecting a benefit and continuing
/// Follows pixel specs from design:
/// - Modal max width: 384
/// - Card radius: 32
/// - Close button: 28x28, radius 10
/// - Section paddings: 24; actions top padding 17 with divider (#E5E7EB)
/// - Benefit card: bg #EFF6FF, border #BEDBFF, radius 16, padding 16
/// - Buttons: height 40, radius 32; primary bg #0F1C14
class RedeemModal extends StatefulWidget {
  final VoidCallback? onContinue;
  final VoidCallback? onCancel;
  final VoidCallback? onClose;

  const RedeemModal({super.key, this.onContinue, this.onCancel, this.onClose});

  @override
  State<RedeemModal> createState() => _RedeemModalState();
}

class _RedeemModalState extends State<RedeemModal> {
  // Single option is selected by default (radio checked)
  bool _selected = true;

  // Color tokens per spec
  static const Color _primaryText = Color(0xFF101828);
  static const Color _secondaryText = Color(0xFF4A5565);
  static const Color _tertiaryText = Color(0xFF6A7282);
  static const Color _primaryButton = Color(0xFF0F1C14);
  static const Color _dividerColor = Color(0xFFE5E7EB);
  static const Color _benefitCardBackground = Color(0xFFEFF6FF);
  static const Color _benefitCardBorder = Color(0xFFBEDBFF);

  @override
  Widget build(BuildContext context) {
    // Use Dialog for built-in animations and focus trapping
    return SafeArea(
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        backgroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 384),
          child: Semantics(
            namesRoute: true,
            label: 'Redeem Betterflies dialog',
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Redeem Betterflies',
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: _primaryText,
                              height: 28 / 18,
                            ),
                          ),
                        ),
                        _CloseButton(onTap: _handleClose),
                      ],
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Choose your benefit',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: _secondaryText,
                            height: 20 / 14,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Benefit Card
                        Container(
                          decoration: BoxDecoration(
                            color: _benefitCardBackground,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _benefitCardBorder),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Left text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    // Title
                                    Text(
                                      'LSA Benefit Card',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: _primaryText,
                                        height: 14 / 14,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    // Amount available
                                    Text(
                                      '\$45.00 available',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: _secondaryText,
                                        height: 20 / 14,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    // Remaining this year
                                    Text(
                                      '\$1,755.00 remaining this year',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: _tertiaryText,
                                        height: 16 / 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Right radio – fixed 24x24
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: InkResponse(
                                  onTap: () => setState(() => _selected = true),
                                  child: Icon(
                                    _selected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_unchecked,
                                    size: 24,
                                    color: _primaryButton,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Actions with divider and specific top spacing (17)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(height: 1, color: _dividerColor),
                        const SizedBox(height: 17),

                        // Continue
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: _handleContinue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryButton,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Cancel
                        SizedBox(
                          height: 40,
                          child: OutlinedButton(
                            onPressed: _handleCancel,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _primaryButton,
                              side: const BorderSide(
                                color: _primaryButton,
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

  void _handleContinue() {
    // Parent is responsible for advancing to the next modal while preserving
    // the dark overlay. We do not pop here to avoid overlay flicker.
    widget.onContinue?.call();
  }

  void _handleCancel() {
    try {
      widget.onCancel?.call();
    } finally {
      Navigator.of(context).maybePop();
    }
  }

  void _handleClose() {
    try {
      widget.onClose?.call();
    } finally {
      Navigator.of(context).maybePop();
    }
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
