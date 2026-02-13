import 'package:expense_tracker/features/expense/data/model/expense_category.dart';

class ExpenseModel {
  final String id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
  final String? note;
  final double vatPercent;
  final String paymentMethod;
  final bool isIncome;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
    this.vatPercent = 0.0,
    this.paymentMethod = 'Cash',
    this.isIncome = false,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      category: ExpenseCategory.fromString(json['category']),
      date: DateTime.parse(json['date']),
      note: json['note'],
      vatPercent: (json['vat_percent'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['payment_method'] ?? 'Cash',
      isIncome: json['is_income'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'category': category.value,
        'date': date.toIso8601String(),
        'note': note,
        'vat_percent': vatPercent,
        'payment_method': paymentMethod,
        'is_income': isIncome,
      };
}
