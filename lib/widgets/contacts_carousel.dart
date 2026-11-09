import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/wallet_models.dart';
import '../providers/wallet_provider.dart';
import '../theme/app_theme.dart';
import '../screens/send_money_screen.dart';

class ContactsCarousel extends StatelessWidget {
  const ContactsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<WalletProvider>();
    final contacts = provider.contacts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Quick Send & Frequent Payees',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                letterSpacing: -0.3,
              ),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Payee', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              onPressed: () {
                _showAddPayeeModal(context);
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 98,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: contacts.length + 1,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              if (index == 0) {
                // "Scan QR" / "Add" Action
                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('UPI Scanner activated.')),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.primary,
                            width: 1.5,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        ),
                        child: Icon(Icons.qr_code_scanner_rounded, color: theme.colorScheme.primary, size: 24),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Scan & Pay',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }

              final contact = contacts[index - 1];
              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SendMoneyScreen(initialContact: contact),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2.5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [AppTheme.accentPurple, AppTheme.accentNeon],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 26,
                            backgroundColor: isDark ? const Color(0xFF101726) : Colors.white,
                            child: Text(
                              contact.avatarInitials,
                              style: TextStyle(
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 2,
                          bottom: 2,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppTheme.accentNeon,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark ? const Color(0xFF090D16) : Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 64,
                      child: Text(
                        contact.name.split(' ').first,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddPayeeModal(BuildContext context) {
    final nameCtrl = TextEditingController();
    final upiCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New UPI Payee',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Payee Name', prefixIcon: Icon(Icons.person_outline)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: upiCtrl,
              decoration: const InputDecoration(labelText: 'UPI ID or Mobile', prefixIcon: Icon(Icons.alternate_email)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty && upiCtrl.text.isNotEmpty) {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SendMoneyScreen(
                          initialContact: ContactModel(
                            id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
                            name: nameCtrl.text.trim(),
                            upiId: upiCtrl.text.trim(),
                            phone: '',
                            avatarInitials: nameCtrl.text.substring(0, 1).toUpperCase(),
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Continue to Transfer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

