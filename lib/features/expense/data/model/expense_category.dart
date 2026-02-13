import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

enum ExpenseCategory {
  food('food', 'Food', Iconsax.coffee, Color(0xFF4361EE)),
  rent('rent', 'Rent', Iconsax.home_2, Color(0xFF2EC4B6)),
  shopping('shopping', 'Shopping', Iconsax.bag_2, Color(0xFFFF9F1C)),
  transport('transport', 'Transport', Iconsax.car, Color(0xFFA29BFE)),
  entertainment('entertainment', 'Entertainment', Iconsax.game, Color(0xFFFF6B6B)),
  bills('bills', 'Bills', Iconsax.receipt_item, Color(0xFF00B4D8)),
  health('health', 'Health', Iconsax.health, Color(0xFF55E6C1)),
  education('education', 'Education', Iconsax.book_1, Color(0xFF74B9FF)),
  other('other', 'Other', Iconsax.more_circle, Color(0xFFB2BEC3));

  final String value;
  final String displayName;
  final IconData icon;
  final Color color;

  const ExpenseCategory(this.value, this.displayName, this.icon, this.color);

  static ExpenseCategory fromString(String value) {
    return ExpenseCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ExpenseCategory.other,
    );
  }
}
