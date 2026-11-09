import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/wallet_models.dart';
import '../providers/wallet_provider.dart';

class VirtualCardWidget extends StatelessWidget {
  final VirtualCardModel card;

  const VirtualCardWidget({super.key, required this.card});

  static const List<List<Color>> gradients = [
    [Color(0xFF4F46E5), Color(0xFF7C3AED)], // Indigo to Purple
    [Color(0xFF0F172A), Color(0xFF334155)], // Slate Obsidian
    [Color(0xFF059669), Color(0xFF10B981)], // Emerald
  ];

  @override
  Widget build(BuildContext context) {
    final gradient = gradients[card.gradientIndex % gradients.length];
    final provider = context.watch<WalletProvider>();

    return AspectRatio(
      aspectRatio: 1.58, // Standard credit card ratio
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Decorative background circles
              Positioned(
                right: -30,
                top: -30,
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.white.withValues(alpha: 0.06),
                ),
              ),
              Positioned(
                left: -20,
                bottom: -40,
                child: CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.white.withValues(alpha: 0.04),
                ),
              ),

              // Card Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Row: Bank Label & Contactless / Visa
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.account_balance_wallet, color: Colors.white, size: 18),
                              SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'NovaPay Card',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.contactless, color: Colors.white.withValues(alpha: 0.8), size: 20),
                      ],
                    ),

                    // Chip and Card Type
                    Row(
                      children: [
                        Container(
                          width: 34,
                          height: 25,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBBF24),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: const Color(0xFFD97706), width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(width: 1, color: const Color(0xFFB45309)),
                              Container(width: 1, color: const Color(0xFFB45309)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          card.cardType,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),

                    // Card Number
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        card.maskedNumber,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Bottom Row: Holder & Expiry
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'CARD HOLDER',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 8,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                card.cardHolder,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'EXPIRES',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 8,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              card.expiryDate,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Frozen Overlay
              if (card.isFrozen)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.75),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.ac_unit, color: Colors.lightBlueAccent, size: 30),
                          const SizedBox(height: 6),
                          const Text(
                            'CARD FROZEN',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white24,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            ),
                            onPressed: () => provider.toggleCardFreeze(card.id),
                            child: const Text('Unfreeze Card', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
