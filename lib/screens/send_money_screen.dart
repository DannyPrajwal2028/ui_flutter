import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/wallet_models.dart';
import '../providers/wallet_provider.dart';
import '../theme/app_theme.dart';

class SendMoneyScreen extends StatefulWidget {
  final ContactModel? initialContact;

  const SendMoneyScreen({super.key, this.initialContact});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _recipientNameController;
  late final TextEditingController _upiIdController;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String _selectedCategory = 'Transfers';
  bool _isProcessing = false;

  final List<String> _categories = [
    'Transfers',
    'Food',
    'Shopping',
    'Bills',
    'Entertainment',
  ];

  @override
  void initState() {
    super.initState();
    _recipientNameController =
        TextEditingController(text: widget.initialContact?.name ?? '');
    _upiIdController =
        TextEditingController(text: widget.initialContact?.upiId ?? '');
  }

  @override
  void dispose() {
    _recipientNameController.dispose();
    _upiIdController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submitTransfer() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<WalletProvider>();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;

    if (amount > provider.walletBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Insufficient balance! Available: ₹${provider.walletBalance.toStringAsFixed(2)}',
          ),
          backgroundColor: AppTheme.expenseRed,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    final success = provider.sendMoney(
      recipientName: _recipientNameController.text.trim(),
      upiId: _upiIdController.text.trim(),
      amount: amount,
      category: _selectedCategory,
      note: _noteController.text.trim(),
    );

    setState(() => _isProcessing = false);

    if (success) {
      _showSuccessDialog(amount);
    }
  }

  void _showSuccessDialog(double amount) {
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
                child: const Icon(Icons.check_circle, color: AppTheme.accent, size: 48),
              ),
              const SizedBox(height: 20),
              const Text(
                'Payment Sent!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '₹${amount.toStringAsFixed(2)} successfully transferred to ${_recipientNameController.text.trim()}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('UPI ID:'),
                    Text(
                      _upiIdController.text.trim(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
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
            child: const Text('Back to Wallet'),
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
        title: const Text('Send Money'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Available Balance Card
                  Card(
                    color: theme.colorScheme.primary,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Available Wallet Balance',
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'NovaPay Digital Account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '₹${provider.walletBalance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Frequent Contacts Horizontal Chips
                  const Text(
                    'Quick Transfer Contacts',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.contacts.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final contact = provider.contacts[index];
                        return ActionChip(
                          avatar: CircleAvatar(
                            backgroundColor: theme.colorScheme.primary,
                            child: Text(
                              contact.avatarInitials,
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ),
                          label: Text(contact.name),
                          onPressed: () {
                            setState(() {
                              _recipientNameController.text = contact.name;
                              _upiIdController.text = contact.upiId;
                            });
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Recipient Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),

                  // Recipient Name Field
                  TextFormField(
                    controller: _recipientNameController,
                    decoration: const InputDecoration(
                      labelText: 'Recipient Full Name *',
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: 'e.g. Aditi Sharma',
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Recipient name is required';
                      }
                      if (val.trim().length < 3) {
                        return 'Name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Recipient UPI ID or Phone
                  TextFormField(
                    controller: _upiIdController,
                    decoration: const InputDecoration(
                      labelText: 'UPI ID or Mobile Number *',
                      prefixIcon: Icon(Icons.alternate_email),
                      hintText: 'e.g. name@okaxis or 9876543210',
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'UPI ID or phone number is required';
                      }
                      final isUpi = RegExp(r'^[\w.-]+@[\w.-]+$').hasMatch(val.trim());
                      final isPhone = RegExp(r'^[6-9]\d{9}$').hasMatch(val.trim());
                      if (!isUpi && !isPhone) {
                        return 'Enter a valid UPI ID (user@bank) or 10-digit mobile number';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Transfer Amount & Category',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),

                  // Amount Field
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      labelText: 'Amount (₹) *',
                      prefixIcon: Icon(Icons.currency_rupee, size: 22),
                      hintText: '0.00',
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter transfer amount';
                      }
                      final amount = double.tryParse(val.trim());
                      if (amount == null || amount <= 0) {
                        return 'Enter a valid amount greater than ₹0';
                      }
                      if (amount > provider.walletBalance) {
                        return 'Amount exceeds wallet balance (₹${provider.walletBalance.toStringAsFixed(2)})';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),

                  const SizedBox(height: 16),

                  // Note / Remarks
                  TextFormField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      labelText: 'Note / Remarks (Optional)',
                      prefixIcon: Icon(Icons.note_alt_outlined),
                      hintText: 'e.g. Dinner split, Rent, etc.',
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Submit Transfer Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _isProcessing ? null : _submitTransfer,
                      icon: _isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.send_rounded),
                      label: Text(
                        _isProcessing ? 'Processing Transfer...' : 'Send Money Securely',
                      ),
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

