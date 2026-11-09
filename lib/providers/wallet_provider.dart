import 'package:flutter/material.dart';
import '../models/wallet_models.dart';

class WalletProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _hideBalance = false;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  double _walletBalance = 48750.00;
  double _monthlyIncome = 65000.00;
  double _monthlySpent = 16250.00;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get hideBalance => _hideBalance;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  double get walletBalance => _walletBalance;
  double get monthlyIncome => _monthlyIncome;
  double get monthlySpent => _monthlySpent;

  final List<String> categories = const [
    'All',
    'Transfers',
    'Shopping',
    'Food',
    'Bills',
    'Salary',
    'Entertainment',
  ];

  final List<VirtualCardModel> _cards = [
    VirtualCardModel(
      id: 'c-1',
      cardHolder: 'AARAV MEHTA',
      cardNumber: '4532 8921 7845 9012',
      expiryDate: '09/29',
      cvv: '842',
      cardType: 'Visa Platinum',
      balance: 32500.00,
      gradientIndex: 0,
    ),
    VirtualCardModel(
      id: 'c-2',
      cardHolder: 'AARAV MEHTA',
      cardNumber: '5241 6789 3412 4490',
      expiryDate: '12/28',
      cvv: '319',
      cardType: 'Mastercard World',
      balance: 16250.00,
      gradientIndex: 1,
    ),
  ];

  final List<ContactModel> _contacts = [
    ContactModel(
      id: 'ct-1',
      name: 'Aditi Sharma',
      upiId: 'aditi.sharma@okaxis',
      phone: '9876543210',
      avatarInitials: 'AS',
    ),
    ContactModel(
      id: 'ct-2',
      name: 'Rahul Varma',
      upiId: 'rahul.v@icici',
      phone: '9845123456',
      avatarInitials: 'RV',
    ),
    ContactModel(
      id: 'ct-3',
      name: 'Sneha Reddy',
      upiId: 'sneha.reddy@okhdfcbank',
      phone: '9701234567',
      avatarInitials: 'SR',
    ),
    ContactModel(
      id: 'ct-4',
      name: 'Vikram Singh',
      upiId: 'vikram.singh@paytm',
      phone: '9988776655',
      avatarInitials: 'VS',
    ),
    ContactModel(
      id: 'ct-5',
      name: 'Kavya Patel',
      upiId: 'kavya.p@ybl',
      phone: '9123456789',
      avatarInitials: 'KP',
    ),
  ];

  final List<TransactionModel> _transactions = [
    TransactionModel(
      id: 'tx-101',
      title: 'Netflix Subscription',
      subtitle: 'Auto-Debit • Entertainment',
      category: 'Entertainment',
      amount: 649.00,
      isCredit: false,
      date: 'Today',
      time: '02:45 PM',
      recipientUpi: 'netflix.india@hdfc',
      iconCode: 'movie',
    ),
    TransactionModel(
      id: 'tx-102',
      title: 'Salary Deposit (Tech Corp)',
      subtitle: 'Direct Deposit • Monthly Credits',
      category: 'Salary',
      amount: 45000.00,
      isCredit: true,
      date: 'Yesterday',
      time: '09:00 AM',
      recipientUpi: 'payroll@techcorp.in',
      iconCode: 'payments',
    ),
    TransactionModel(
      id: 'tx-103',
      title: 'Swiggy Gourmet Order',
      subtitle: 'Online Food Delivery',
      category: 'Food',
      amount: 580.00,
      isCredit: false,
      date: 'Nov 07, 2026',
      time: '08:15 PM',
      recipientUpi: 'swiggy@icici',
      iconCode: 'restaurant',
    ),
    TransactionModel(
      id: 'tx-104',
      title: 'Sent to Aditi Sharma',
      subtitle: 'UPI Transfer • Dinner split',
      category: 'Transfers',
      amount: 1200.00,
      isCredit: false,
      date: 'Nov 06, 2026',
      time: '11:20 AM',
      recipientUpi: 'aditi.sharma@okaxis',
      iconCode: 'send',
    ),
    TransactionModel(
      id: 'tx-105',
      title: 'Amazon Electronics',
      subtitle: 'Wireless Headphones',
      category: 'Shopping',
      amount: 3499.00,
      isCredit: false,
      date: 'Nov 05, 2026',
      time: '04:10 PM',
      recipientUpi: 'amazonpay@apl',
      iconCode: 'shopping_bag',
    ),
    TransactionModel(
      id: 'tx-106',
      title: 'Received from Sneha Reddy',
      subtitle: 'Trip contribution reimbursement',
      category: 'Transfers',
      amount: 4500.00,
      isCredit: true,
      date: 'Nov 04, 2026',
      time: '06:30 PM',
      recipientUpi: 'sneha.reddy@okhdfcbank',
      iconCode: 'call_received',
    ),
    TransactionModel(
      id: 'tx-107',
      title: 'Electricity & Utility Bill',
      subtitle: 'State Electricity Board',
      category: 'Bills',
      amount: 1840.00,
      isCredit: false,
      date: 'Nov 02, 2026',
      time: '10:05 AM',
      recipientUpi: 'tssouthernpower@billdesk',
      iconCode: 'receipt_long',
    ),
  ];

  List<VirtualCardModel> get cards => List.unmodifiable(_cards);
  List<ContactModel> get contacts => List.unmodifiable(_contacts);

  List<TransactionModel> get transactions {
    return _transactions.where((tx) {
      final matchesCategory = _selectedCategory == 'All' ||
          tx.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          tx.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tx.recipientUpi.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tx.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void toggleHideBalance() {
    _hideBalance = !_hideBalance;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = (_themeMode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleCardFreeze(String cardId) {
    final idx = _cards.indexWhere((c) => c.id == cardId);
    if (idx != -1) {
      _cards[idx].isFrozen = !_cards[idx].isFrozen;
      notifyListeners();
    }
  }

  bool sendMoney({
    required String recipientName,
    required String upiId,
    required double amount,
    required String category,
    String? note,
  }) {
    if (amount <= 0 || amount > _walletBalance) {
      return false;
    }

    _walletBalance -= amount;
    _monthlySpent += amount;

    final newTx = TransactionModel(
      id: 'tx-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      title: 'Transfer to $recipientName',
      subtitle: note?.isNotEmpty == true ? note! : 'UPI Transfer • $category',
      category: category,
      amount: amount,
      isCredit: false,
      date: 'Just now',
      time: '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      recipientUpi: upiId,
      status: 'Completed',
      iconCode: 'send',
    );

    _transactions.insert(0, newTx);
    notifyListeners();
    return true;
  }

  void addFunds({
    required double amount,
    required String paymentSource,
  }) {
    if (amount <= 0) return;

    _walletBalance += amount;
    _monthlyIncome += amount;

    final newTx = TransactionModel(
      id: 'tx-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      title: 'Wallet Top-up ($paymentSource)',
      subtitle: 'Direct Deposit • Instant Credit',
      category: 'Transfers',
      amount: amount,
      isCredit: true,
      date: 'Just now',
      time: '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      recipientUpi: 'wallet.credit@nova',
      status: 'Completed',
      iconCode: 'account_balance_wallet',
    );

    _transactions.insert(0, newTx);
    notifyListeners();
  }
}

