import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ui_flutter/main.dart';
import 'package:ui_flutter/providers/wallet_provider.dart';

void main() {
  testWidgets('NovaWallet digital wallet smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => WalletProvider()),
        ],
        child: const NovaWalletApp(),
      ),
    );

    expect(find.text('NovaWallet'), findsWidgets);
    expect(find.text('Total Wallet Balance'), findsWidgets);
  });
}
