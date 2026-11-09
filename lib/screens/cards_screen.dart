import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<WalletProvider>();
    final cards = provider.cards;
    final activeCard = cards[_currentCardIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual Cards & Security'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Selector Tabs
                SizedBox(
                  height: 40,
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
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Virtual Card Display
                VirtualCardWidget(card: activeCard),

                const SizedBox(height: 16),

                // Card Actions Row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: Icon(activeCard.isFrozen ? Icons.lock_open : Icons.ac_unit),
                        label: Text(activeCard.isFrozen ? 'Unfreeze' : 'Freeze Card'),
                        onPressed: () => provider.toggleCardFreeze(activeCard.id),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.credit_card_outlined),
                        label: const Text('View CVV / Details'),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Card Security Details'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Card Number: ${activeCard.cardNumber}'),
                                  const SizedBox(height: 8),
                                  Text('CVV: ${activeCard.cvv}'),
                                  const SizedBox(height: 8),
                                  Text('Expiry: ${activeCard.expiryDate}'),
                                  const SizedBox(height: 8),
                                  Text('Cardholder: ${activeCard.cardHolder}'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Close'),
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
                  'Spending Limits & Controls',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Daily Online Limit',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              '₹${_dailyLimit.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
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
                        const Divider(height: 16),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Online E-Commerce Transactions'),
                          subtitle: const Text('Enable payments on Amazon, Flipkart, Swiggy, etc.'),
                          value: _onlineTransactions,
                          onChanged: (val) => setState(() => _onlineTransactions = val),
                        ),
                        const Divider(height: 16),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('International Payments'),
                          subtitle: const Text('Allow cross-border transactions and subscriptions'),
                          value: _intlUsage,
                          onChanged: (val) => setState(() => _intlUsage = val),
                        ),
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
}

