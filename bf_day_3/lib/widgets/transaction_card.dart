import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bf_design_system/bf_design_system.dart';
import '../modals/eligible_expenses_sheet.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

/// Transaction status enum per spec
enum TransactionStatus { approved, pending, processing, denied }

/// Transaction model used by the card (kept simple and replaceable)
class TransactionItem {
  final String company;
  final double amount; // negative for debits
  final DateTime date;
  final TransactionStatus status;

  const TransactionItem({
    required this.company,
    required this.amount,
    required this.date,
    required this.status,
  });
}

/// Pixel-precise iOS-friendly Transaction Card
class TransactionCard extends StatelessWidget {
  /// Transactions to render. If null, a default demo list is shown.
  final List<TransactionItem>? transactions;

  /// Called when Upload receipt button tapped
  final VoidCallback? onUpload;

  /// Called when Load more tapped
  final VoidCallback? onLoadMore;

  const TransactionCard({
    super.key,
    this.transactions,
    this.onUpload,
    this.onLoadMore,
  });

  // Colors per spec
  static const Color primaryText = Color(0xFF101828);
  static const Color secondaryText = Color(0xFF717182);
  static const Color darkPrimary = Color(0xFF0F1C14);
  static const Color approvedBg = Color(0xFFDCFCE7);
  static const Color approvedText = Color(0xFF016630);
  static const Color pendingBg = Color(0xFFFEF9C2);
  static const Color pendingText = Color(0xFF894B00);
  static const Color processingBg = Color(0xFFDBEAFE);
  static const Color processingText = Color(0xFF193CB8);
  static const Color deniedBg = Color(0xFFD4183D);
  static const Color deniedText = Color(0xFFFFFFFF);
  static const Color dividerColor = Color.fromRGBO(0, 0, 0, 0.1);
  static const Color borderColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    // Merge demo transactions with any LSA credit events from AppState
    final credits = context.select<AppState, List<TransactionItem>>((app) {
      return app.lsaCredits
          .map(
            (e) => TransactionItem(
              company: 'BF redemption',
              amount: e.amount, // positive credit
              date: e.date,
              status: TransactionStatus.approved,
            ),
          )
          .toList(growable: false);
    });
    final baseList = transactions ?? _demoTransactions;
    final list = [...credits, ...baseList]
      ..sort((a, b) => b.date.compareTo(a.date));

    // Constrain to 384 max width; wrap content height
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 384),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(16, 24, 40, 0.03),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildUploadButton(context),
              const SizedBox(height: 12),
              _buildViewEligibleButton(context),
              const SizedBox(height: 12),
              _buildList(context, list),
              const SizedBox(height: 16),
              _buildLoadMoreButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            'Transactions',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              height: 28 / 18,
              color: primaryText,
            ),
          ),
        ),
        // No action button in header; moved below Upload button
      ],
    );
  }

  Widget _buildViewEligibleButton(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
          minimumSize: const Size(0, 40),
        ),
        onPressed: () {
          showBFModal(
            context: context,
            title: 'Eligible Expenses',
            child: const BFModalContent(
              padding: EdgeInsets.all(24),
              child: EligibleExpensesSheet(),
            ),
            isScrollControlled: true,
            useRootNavigator: true,
            extraTopPadding: 16,
          );
        },
        child: Text(
          'View eligible expenses',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: darkPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
          elevation: 0,
        ),
        onPressed: onUpload ?? () {},
        child: Text(
          'Upload receipt',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<TransactionItem> list) {
    final useBuilder = list.length > 10;
    final listWidget = useBuilder
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) => _buildItem(
              context,
              list[index],
              isLast: index == list.length - 1,
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < list.length; i++)
                _buildItem(context, list[i], isLast: i == list.length - 1),
            ],
          );
    return listWidget;
  }

  Widget _buildItem(
    BuildContext context,
    TransactionItem item, {
    required bool isLast,
  }) {
    return Semantics(
      label:
          'Transaction from ${item.company} for ${_formatCurrency(item.amount)} on ${_formatDate(item.date)} status ${_statusLabel(item.status)}',
      button: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row 1
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.company,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 24 / 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _formatCurrency(item.amount),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    height: 28 / 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // Row 2
            Row(
              children: [
                Expanded(
                  child: Text(
                    _formatDate(item.date),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 20 / 14,
                      color: secondaryText,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildStatusBadge(item.status),
              ],
            ),

            if (!isLast)
              const Divider(height: 12, thickness: 1, color: dividerColor),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(TransactionStatus status) {
    late Color bg;
    late Color fg;
    late String label;
    switch (status) {
      case TransactionStatus.approved:
        bg = approvedBg;
        fg = approvedText;
        label = 'Approved';
        break;
      case TransactionStatus.pending:
        bg = pendingBg;
        fg = pendingText;
        label = 'Pending';
        break;
      case TransactionStatus.processing:
        bg = processingBg;
        fg = processingText;
        label = 'Processing';
        break;
      case TransactionStatus.denied:
        bg = deniedBg;
        fg = deniedText;
        label = 'Denied';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 9),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: fg,
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton(BuildContext context) {
    return SizedBox(
      height: 40,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: const BorderSide(color: darkPrimary, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
        ),
        onPressed: onLoadMore ?? () {},
        child: Text(
          'Load more transactions',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: darkPrimary,
          ),
        ),
      ),
    );
  }

  static String _formatCurrency(double amount) {
    final abs = amount.abs().toStringAsFixed(2);
    return amount < 0 ? '-\$$abs' : '+\$$abs';
  }

  static String _formatDate(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    final yyyy = date.year.toString();
    return '$mm/$dd/$yyyy';
  }

  static String _statusLabel(TransactionStatus s) {
    switch (s) {
      case TransactionStatus.approved:
        return 'Approved';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.processing:
        return 'Processing';
      case TransactionStatus.denied:
        return 'Denied';
    }
  }

  // Demo dataset per spec
  static final List<TransactionItem> _demoTransactions = [
    TransactionItem(
      company: 'Pharmacy Co',
      amount: -25.00,
      date: DateTime(2024, 12, 15),
      status: TransactionStatus.approved,
    ),
    TransactionItem(
      company: 'Wellness Gym',
      amount: -75.00,
      date: DateTime(2024, 12, 10),
      status: TransactionStatus.pending,
    ),
    TransactionItem(
      company: 'Vision Center',
      amount: -120.00,
      date: DateTime(2024, 12, 8),
      status: TransactionStatus.approved,
    ),
    TransactionItem(
      company: 'Dental Care Plus',
      amount: -180.00,
      date: DateTime(2024, 12, 5),
      status: TransactionStatus.processing,
    ),
    TransactionItem(
      company: 'Health Mart',
      amount: -50.00,
      date: DateTime(2024, 12, 1),
      status: TransactionStatus.denied,
    ),
  ];
}
