import 'package:expense_tracker/features/account/data/model/account_type.dart';

class AccountModel {
  final String id;
  final String name;
  final AccountType type;
  final double balance;
  final String? note;

  AccountModel({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    this.note,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'],
      name: json['name'],
      type: AccountType.fromString(json['type']),
      balance: (json['balance'] as num).toDouble(),
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.value,
        'balance': balance,
        'note': note,
      };
}
