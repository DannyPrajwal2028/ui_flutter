import 'package:flutter/material.dart';
import '../models/wallet_models.dart';
import '../theme/app_theme.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionTile({super.key, required this.transaction});

  IconData _getIcon(String code) {
    switch (code) {
      case 'movie':
        return Icons.movie_outlined;
      case 'payments':
        return Icons.account_balance_outlined;
      case 'restaurant':
        return Icons.restaurant_outlined;
      case 'shopping_bag':
        return Icons.shopping_bag_outlined;
      case 'call_received':
        return Icons.arrow_downward_rounded;
      case 'receipt_long':
        return Icons.receipt_long_outlined;
      case 'account_balance_wallet':
        return Icons.add_circle_outline_rounded;
      case 'send':
      default:
        return Icons.arrow_upward_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isCredit = transaction.isCredit;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showTransactionReceipt(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Circular Category Icon Badge
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: isCredit
                      ? AppTheme.accent.withValues(alpha: 0.12)
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFEEF2F6)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIcon(transaction.iconCode),
                  color: isCredit ? AppTheme.accent : theme.colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${transaction.date} • ${transaction.time}',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isCredit ? "+" : "-"}₹${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: isCredit ? AppTheme.accent : (isDark ? Colors.white : const Color(0xFF1E293B)),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      transaction.category,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionReceipt(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Icon(
              transaction.isCredit ? Icons.check_circle : Icons.arrow_circle_up_rounded,
              color: transaction.isCredit ? AppTheme.accent : theme.colorScheme.primary,
              size: 52,
            ),
            const SizedBox(height: 12),
            Text(
              '${transaction.isCredit ? "+" : "-"}₹${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: transaction.isCredit ? AppTheme.accent : (isDark ? Colors.white : Colors.black87),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              transaction.isCredit ? 'Payment Received' : 'Payment Successful',
              style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const Divider(height: 32),
            _receiptRow('Transaction ID', transaction.id),
            _receiptRow('Recipient / Source', transaction.recipientUpi),
            _receiptRow('Date & Time', '${transaction.date}, ${transaction.time}'),
            _receiptRow('Category', transaction.category),
            _receiptRow('Status', transaction.status, isStatus: true),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close Receipt'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _receiptRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          if (isStatus)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                value,
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            )
          else
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}

