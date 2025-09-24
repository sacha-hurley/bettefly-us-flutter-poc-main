import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../modals/redeem_modal.dart';
import '../modals/redeem_amount_modal.dart';
import '../widgets/notification_host.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../services/currency_service.dart';

/// BetterFliesCard - Premium currency card with gradient background
///
/// Displays the current BetterFlies balance with header, large amount,
/// masked card details, and two placeholder actions.
class BetterFliesCard extends StatelessWidget {
  final int currencyCount;

  const BetterFliesCard({super.key, required this.currencyCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(32.0)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32.0),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            // Image background (replaces gradient)
            Positioned.fill(
              child: Image.asset(
                'assets/images/wavy_gradient_warm.png',
                fit: BoxFit.cover,
              ),
            ),

            // Dark vignette on the top for depth (kept for contrast)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      const Color(0xFF000000).withOpacity(0.65),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with title and butterfly icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Available Betterflies',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 1.56,
                        ),
                      ),
                      SizedBox(
                        width: 24,
                        height: 20,
                        child: SvgPicture.asset(
                          'assets/icons/betteflies-graphic.svg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Large currency amount
                  Text(
                    '$currencyCount',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Card details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '**** **** **** 1234',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 1.43,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Acme Benefits',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              height: 1.33,
                            ),
                          ),
                          Text(
                            'Expires 12/26',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF1A1A1A),
                              height: 1.33,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 17),

                  // Action buttons with separator
                  Column(
                    children: [
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: const Color(0xFF262626),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            // Open RedeemModal; when Continue is pressed, replace with RedeemAmountModal
                            showGeneralDialog<void>(
                              context: context,
                              barrierLabel: 'Redeem Betterflies',
                              barrierDismissible: false,
                              barrierColor: Colors.black87,
                              pageBuilder: (ctx, a1, a2) {
                                return Center(
                                  child: RedeemModal(
                                    onContinue: () {
                                      // Replace the current dialog route to preserve overlay
                                      Navigator.of(ctx).pushReplacement(
                                        PageRouteBuilder(
                                          opaque: false,
                                          barrierColor: Colors.black87,
                                          barrierDismissible: false,
                                          pageBuilder: (c, _, __) => Center(
                                            child: RedeemAmountModal(
                                              currentBalance: currencyCount,
                                              onBack: () {
                                                // Go back to first modal without losing overlay
                                                Navigator.of(c).pushReplacement(
                                                  PageRouteBuilder(
                                                    opaque: false,
                                                    barrierColor:
                                                        Colors.black87,
                                                    barrierDismissible: false,
                                                    pageBuilder: (c2, __, ___) => Center(
                                                      child: RedeemModal(
                                                        onContinue: () {
                                                          Navigator.of(
                                                            c2,
                                                          ).pushReplacement(
                                                            PageRouteBuilder(
                                                              opaque: false,
                                                              barrierColor:
                                                                  Colors
                                                                      .black87,
                                                              barrierDismissible:
                                                                  false,
                                                              pageBuilder: (c3, ____, _____) => Center(
                                                                child: RedeemAmountModal(
                                                                  currentBalance:
                                                                      currencyCount,
                                                                  onBack: () =>
                                                                      Navigator.of(
                                                                        c3,
                                                                      ).pop(),
                                                                  onClose: () =>
                                                                      Navigator.of(
                                                                        c3,
                                                                      ).pop(),
                                                                  onCancel: () =>
                                                                      Navigator.of(
                                                                        c3,
                                                                      ).pop(),
                                                                  onConfirm: (bf, dollars) async {
                                                                    await CurrencyService().spendBetterFlies(
                                                                      amount:
                                                                          bf,
                                                                      description:
                                                                          'Redeemed to LSA',
                                                                    );
                                                                    context
                                                                        .read<
                                                                          AppState
                                                                        >()
                                                                        .creditLsa(
                                                                          dollars,
                                                                        );
                                                                    Navigator.of(
                                                                      c3,
                                                                    ).pop();
                                                                    NotificationHost.showToast(
                                                                      context,
                                                                      message:
                                                                          '\$${dollars.toStringAsFixed(2)} has been added to your LSA account',
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        onCancel: () =>
                                                            Navigator.of(
                                                              c2,
                                                            ).pop(),
                                                        onClose: () =>
                                                            Navigator.of(
                                                              c2,
                                                            ).pop(),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              onClose: () =>
                                                  Navigator.of(c).pop(),
                                              onCancel: () =>
                                                  Navigator.of(c).pop(),
                                              onConfirm: (bf, dollars) async {
                                                // Spend BetterFlies and credit LSA, then close and toast
                                                await CurrencyService()
                                                    .spendBetterFlies(
                                                      amount: bf,
                                                      description:
                                                          'Redeemed to LSA',
                                                    );
                                                context
                                                    .read<AppState>()
                                                    .creditLsa(dollars);
                                                // Close the entire flow
                                                Navigator.of(c).pop();
                                                // Show toast using the global NotificationHost
                                                NotificationHost.showToast(
                                                  context,
                                                  message:
                                                      '\$${dollars.toStringAsFixed(2)} has been added to your LSA account',
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    onCancel: () => Navigator.of(ctx).pop(),
                                    onClose: () => Navigator.of(ctx).pop(),
                                  ),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F1C14),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            alignment: Alignment.center,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: const Text(
                            'Redeem Betterflies',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0F1C14),
                            side: const BorderSide(
                              color: Color(0xFF0F1C14),
                              width: 1,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: const Text(
                            'Learn more',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
