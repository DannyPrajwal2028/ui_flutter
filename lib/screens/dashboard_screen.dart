import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/virtual_card_widget.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/spending_chart_widget.dart';
import '../widgets/contacts_carousel.dart';
import 'send_money_screen.dart';
import 'add_funds_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<WalletProvider>();
    final transactions = provider.transactions;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Executive Top Bar
          SliverAppBar(
            floating: true,
            pinned: false,
            title: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.accentPurple, AppTheme.accentViolet],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentPurple.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'NovaWallet',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'Welcome back, Danny • 24XV1M7606',
                      style: TextStyle(
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Toggle Theme',
                icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                onPressed: () => provider.toggleTheme(),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All payments & transactions up-to-date.')),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Main Dashboard Body
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Holographic Master Balance Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(26),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4338CA)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF312E81).withValues(alpha: 0.35),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'TOTAL LIQUID BALANCE',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(
                                    provider.hideBalance ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                    color: Colors.white70,
                                    size: 20,
                                  ),
                                  onPressed: () => provider.toggleHideBalance(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Balance Text
                            Text(
                              provider.hideBalance
                                  ? '₹ ••••••••'
                                  : '₹${provider.walletBalance.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Metric Badges
                            Row(
                              children: [
                                _buildBalanceMetric(
                                  label: 'Monthly Income',
                                  amount: '₹${provider.monthlyIncome.toStringAsFixed(0)}',
                                  isPositive: true,
                                ),
                                const SizedBox(width: 14),
                                _buildBalanceMetric(
                                  label: 'Monthly Spent',
                                  amount: '₹${provider.monthlySpent.toStringAsFixed(0)}',
                                  isPositive: false,
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Quick Action Buttons Grid Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildActionPill(
                                  context: context,
                                  icon: Icons.north_east_rounded,
                                  label: 'Send',
                                  color: AppTheme.accentNeon,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const SendMoneyScreen()),
                                    );
                                  },
                                ),
                                _buildActionPill(
                                  context: context,
                                  icon: Icons.add_rounded,
                                  label: 'Top Up',
                                  color: const Color(0xFF38BDF8),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const AddFundsScreen()),
                                    );
                                  },
                                ),
                                _buildActionPill(
                                  context: context,
                                  icon: Icons.qr_code_scanner_rounded,
                                  label: 'Scan QR',
                                  color: const Color(0xFFA855F7),
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Camera QR scanner ready for instant merchant UPI.')),
                                    );
                                  },
                                ),
                                _buildActionPill(
                                  context: context,
                                  icon: Icons.receipt_long_rounded,
                                  label: 'Pay Bills',
                                  color: AppTheme.accentGold,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Biller portal loaded (Mobile, Electricity, WiFi).')),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Weekly Trends Chart & Virtual Cards Carousel (Responsive)
                      LayoutBuilder(
                        builder: (context, cardConstraints) {
                          if (cardConstraints.maxWidth >= 900) {
                            return const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 5, child: SpendingChartWidget()),
                                SizedBox(width: 20),
                                Expanded(flex: 5, child: _VirtualCardsSection()),
                              ],
                            );
                          }
                          return const Column(
                            children: [
                              _VirtualCardsSection(),
                              SizedBox(height: 20),
                              SpendingChartWidget(),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Quick Transfer Contacts Carousel
                      const ContactsCarousel(),

                      const SizedBox(height: 24),

                      // Search Bar
                      TextField(
                        controller: _searchController,
                        onChanged: (val) => provider.setSearchQuery(val),
                        decoration: InputDecoration(
                          hintText: 'Search transactions by recipient, category, or note...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: provider.searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded),
                                  onPressed: () {
                                    _searchController.clear();
                                    provider.setSearchQuery('');
                                  },
                                )
                              : null,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Category Filter Chips
                      SizedBox(
                        height: 42,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: provider.categories.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final cat = provider.categories[index];
                            final isSelected = cat == provider.selectedCategory;
                            return ChoiceChip(
                              label: Text(cat),
                              selected: isSelected,
                              onSelected: (_) => provider.setCategory(cat),
                              selectedColor: theme.colorScheme.primary,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : (isDark ? Colors.grey[300] : Colors.grey[800]),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                fontSize: 13,
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              showCheckmark: false,
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Transaction History Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Activity (${transactions.length})',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                            ),
                          ),
                          if (provider.selectedCategory != 'All' || provider.searchQuery.isNotEmpty)
                            TextButton.icon(
                              icon: const Icon(Icons.filter_alt_off_rounded, size: 16),
                              label: const Text('Reset', style: TextStyle(fontWeight: FontWeight.bold)),
                              onPressed: () {
                                _searchController.clear();
                                provider.setSearchQuery('');
                                provider.setCategory('All');
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Transactions List or Empty State
          if (transactions.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off_rounded, size: 54, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      const Text(
                        'No Transactions Found',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'No records match "${provider.searchQuery}". Try another keyword.',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        return TransactionTile(transaction: transactions[index]);
                      },
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBalanceMetric({
    required String label,
    required String amount,
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.south_west_rounded : Icons.north_east_rounded,
            color: isPositive ? AppTheme.accentNeon : const Color(0xFFF87171),
            size: 14,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w600),
              ),
              Text(
                amount,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionPill({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _VirtualCardsSection extends StatelessWidget {
  const _VirtualCardsSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<WalletProvider>();
    final cards = provider.cards;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Linked Virtual Cards',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: -0.3),
            ),
            Text(
              '${cards.length} Active',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 195,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: cards.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 300,
                child: VirtualCardWidget(card: cards[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
