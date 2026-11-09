import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/virtual_card_widget.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  int _currentCardIndex = 0;
  double _dailyLimit = 25000.0;
  bool _onlineTransactions = true;
  bool _intlUsage = false;
  bool _contactless = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<WalletProvider>();
    final cards = provider.cards;
    final activeCard = cards[_currentCardIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cards & Security Studio'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Selector Pills
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: cards.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final isSelected = index == _currentCardIndex;
                      return ChoiceChip(
                        label: Text(cards[index].cardType),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _currentCardIndex = index),
                        selectedColor: theme.colorScheme.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : (isDark ? Colors.grey[300] : Colors.grey[800]),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Interactive Card Display
                VirtualCardWidget(card: activeCard),

                const SizedBox(height: 16),

                // Card Actions Row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: Icon(activeCard.isFrozen ? Icons.lock_open_rounded : Icons.ac_unit_rounded),
                        label: Text(activeCard.isFrozen ? 'Unfreeze Card' : 'Freeze Card'),
                        onPressed: () => provider.toggleCardFreeze(activeCard.id),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: const Icon(Icons.security_rounded),
                        label: const Text('View CVV / Pin'),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              title: const Row(
                                children: [
                                  Icon(Icons.shield_rounded, color: AppTheme.accentNeon),
                                  SizedBox(width: 10),
                                  Text('Card Credentials'),
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _credRow('Card Number', activeCard.cardNumber),
                                  _credRow('Cardholder', activeCard.cardHolder),
                                  _credRow('CVV Code', activeCard.cvv),
                                  _credRow('Expiry Date', activeCard.expiryDate),
                                  _credRow('Network', activeCard.cardType),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Done'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Spending Controls
                const Text(
                  'Spending Limits & Protections',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.4),
                ),
                const SizedBox(height: 12),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Daily E-Commerce Limit',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              '₹${_dailyLimit.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: theme.colorScheme.primary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _dailyLimit,
                          min: 1000,
                          max: 50000,
                          divisions: 49,
                          label: '₹${_dailyLimit.toStringAsFixed(0)}',
                          onChanged: (val) => setState(() => _dailyLimit = val),
                        ),
                        const Divider(height: 20),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Online E-Commerce Usage'),
                          subtitle: const Text('Allow payments on Amazon, Flipkart, Swiggy, etc.'),
                          value: _onlineTransactions,
                          onChanged: (val) => setState(() => _onlineTransactions = val),
                        ),
                        const Divider(height: 20),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Contactless Tap & Pay (NFC)'),
                          subtitle: const Text('POS payments without entering PIN up to ₹5,000'),
                          value: _contactless,
                          onChanged: (val) => setState(() => _contactless = val),
                        ),
                        const Divider(height: 20),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('International Currency Payments'),
                          subtitle: const Text('Allow cross-border billing and overseas transactions'),
                          value: _intlUsage,
                          onChanged: (val) => setState(() => _intlUsage = val),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Category Spending Breakdown
                const Text(
                  'Card Spending Breakdown',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.4),
                ),
                const SizedBox(height: 12),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _spendCategory('Online Shopping', 0.42, '₹6,825.00', AppTheme.accentPurple),
                        const SizedBox(height: 14),
                        _spendCategory('Food & Dining', 0.28, '₹4,550.00', AppTheme.accentGold),
                        const SizedBox(height: 14),
                        _spendCategory('Utility Bills', 0.18, '₹2,925.00', AppTheme.accentCyan),
                        const SizedBox(height: 14),
                        _spendCategory('Entertainment & OTT', 0.12, '₹1,950.00', AppTheme.accentRose),
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

  Widget _credRow(String title, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        ],
      ),
    );
  }

  Widget _spendCategory(String name, double percentage, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 7,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
