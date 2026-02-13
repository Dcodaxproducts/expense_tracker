import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

enum ExpenseCategory {
  food('food', 'Food', Iconsax.coffee, Color(0xFFFF6B6B)),
  transport('transport', 'Transport', Iconsax.car, Color(0xFF4ECDC4)),
  shopping('shopping', 'Shopping', Iconsax.bag_2, Color(0xFFFFBE76)),
  entertainment('entertainment', 'Entertainment', Iconsax.game, Color(0xFFA29BFE)),
  bills('bills', 'Bills', Iconsax.receipt_item, Color(0xFFFF7979)),
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
