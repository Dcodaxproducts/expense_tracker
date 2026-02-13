import 'dart:convert';
import 'package:expense_tracker/features/account/data/model/account_model.dart';
import 'package:expense_tracker/features/account/data/model/account_type.dart';
import 'package:expense_tracker/features/account/data/repository/account_repo.dart';
import 'account_service.dart';

class AccountServiceImpl implements AccountService {
  final AccountRepo repo;
  AccountServiceImpl({required this.repo});

  @override
  List<AccountModel> getAccounts() {
    final String? data = repo.getAccounts();
    if (data == null || data.isEmpty) return [];
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((e) => AccountModel.fromJson(e)).toList();
  }

  Future<bool> _saveAll(List<AccountModel> accounts) async {
    final String json = jsonEncode(accounts.map((e) => e.toJson()).toList());
    return await repo.saveAccounts(json);
  }

  @override
  Future<bool> addAccount(String name, AccountType type, double balance, String? note) async {
    final accounts = getAccounts();
    final account = AccountModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      type: type,
      balance: balance,
      note: note,
    );
    accounts.add(account);
    return await _saveAll(accounts);
  }

  @override
  Future<bool> updateAccount(AccountModel account) async {
    final accounts = getAccounts();
    final index = accounts.indexWhere((e) => e.id == account.id);
    if (index == -1) return false;
    accounts[index] = account;
    return await _saveAll(accounts);
  }

  @override
  Future<bool> deleteAccount(String id) async {
    final accounts = getAccounts();
    accounts.removeWhere((e) => e.id == id);
    return await _saveAll(accounts);
  }

  @override
  double getTotalBalance(List<AccountModel> accounts) {
    return accounts.fold(0.0, (sum, a) => sum + a.balance);
  }
}
