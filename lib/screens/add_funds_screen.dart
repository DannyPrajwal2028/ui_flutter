import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../theme/app_theme.dart';

class AddFundsScreen extends StatefulWidget {
  const AddFundsScreen({super.key});

  @override
  State<AddFundsScreen> createState() => _AddFundsScreenState();
}

class _AddFundsScreenState extends State<AddFundsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _paymentSource = 'HDFC Bank (•••• 4021)';
  bool _isProcessing = false;

  final List<String> _sources = [
    'HDFC Bank (•••• 4021)',
    'State Bank of India (•••• 8912)',
    'ICICI Bank (•••• 5523)',
    'UPI Auto-Topup',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submitTopup() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final provider = context.read<WalletProvider>();
    provider.addFunds(amount: amount, paymentSource: _paymentSource);

    setState(() => _isProcessing = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.account_balance_wallet, color: AppTheme.accent, size: 44),
              ),
              const SizedBox(height: 20),
              const Text(
                'Top-up Successful!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '₹${amount.toStringAsFixed(2)} added to your NovaPay digital wallet from $_paymentSource.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('View Updated Balance'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<WalletProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Funds to Wallet'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Balance Banner
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Current Wallet Balance', style: TextStyle(color: Colors.grey, fontSize: 13)),
                              SizedBox(height: 4),
                              Text('Ready for online & offline payments', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Text(
                            '₹${provider.walletBalance.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Enter Top-Up Amount',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Amount Field
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      labelText: 'Amount (₹) *',
                      prefixIcon: Icon(Icons.currency_rupee, size: 24),
                      hintText: '500',
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter top-up amount';
                      }
                      final amount = double.tryParse(val.trim());
                      if (amount == null || amount < 50) {
                        return 'Minimum top-up amount is ₹50';
                      }
                      if (amount > 100000) {
                        return 'Maximum per-transaction limit is ₹1,00,000';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  // Quick Amount Chips
                  Wrap(
                    spacing: 8,
                    children: [500, 1000, 2000, 5000].map((amt) {
                      return ActionChip(
                        label: Text('+₹$amt'),
                        onPressed: () {
                          setState(() {
                            _amountController.text = amt.toString();
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Select Payment Source',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    initialValue: _paymentSource,
                    decoration: const InputDecoration(
                      labelText: 'Funding Source',
                      prefixIcon: Icon(Icons.account_balance),
                    ),
                    items: _sources.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _paymentSource = val);
                    },
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _isProcessing ? null : _submitTopup,
                      icon: _isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.add_card_rounded),
                      label: Text(_isProcessing ? 'Processing...' : 'Add Funds Instantly'),
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
}

