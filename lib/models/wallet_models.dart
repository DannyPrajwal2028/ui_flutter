class TransactionModel {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final double amount;
  final bool isCredit;
  final String date;
  final String time;
  final String recipientUpi;
  final String status;
  final String iconCode;

  TransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.amount,
    required this.isCredit,
    required this.date,
    required this.time,
    required this.recipientUpi,
    this.status = 'Completed',
    required this.iconCode,
  });
}

class VirtualCardModel {
  final String id;
  final String cardHolder;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String cardType; // 'Visa' or 'Mastercard'
  final double balance;
  bool isFrozen;
  final int gradientIndex;

  VirtualCardModel({
    required this.id,
    required this.cardHolder,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.cardType,
    required this.balance,
    this.isFrozen = false,
    this.gradientIndex = 0,
  });

  String get maskedNumber =>
      '•••• •••• •••• ${cardNumber.replaceAll(' ', '').substring(cardNumber.replaceAll(' ', '').length - 4)}';
}

class ContactModel {
  final String id;
  final String name;
  final String upiId;
  final String phone;
  final String avatarInitials;

  ContactModel({
    required this.id,
    required this.name,
    required this.upiId,
    required this.phone,
    required this.avatarInitials,
  });
}

