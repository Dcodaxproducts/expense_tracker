import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

enum AccountType {
  cash('cash', 'Cash', Iconsax.wallet_1, Color(0xFF4CAF50)),
  bank('bank', 'Bank', Iconsax.bank, Color(0xFF2196F3)),
  creditCard('credit_card', 'Credit Card', Iconsax.card, Color(0xFFFF9800)),
  savings('savings', 'Savings', Iconsax.safe_home, Color(0xFF9C27B0)),
  investment('investment', 'Investment', Iconsax.chart_2, Color(0xFF00BCD4)),
  other('other', 'Other', Iconsax.more_circle, Color(0xFF607D8B));

  final String value;
  final String displayName;
  final IconData icon;
  final Color color;

  const AccountType(this.value, this.displayName, this.icon, this.color);

  static AccountType fromString(String value) {
    return AccountType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AccountType.other,
    );
  }
}
