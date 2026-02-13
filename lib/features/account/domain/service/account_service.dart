import 'package:expense_tracker/features/account/data/model/account_model.dart';
import 'package:expense_tracker/features/account/data/model/account_type.dart';

abstract class AccountService {
  List<AccountModel> getAccounts();
  Future<bool> addAccount(String name, AccountType type, double balance, String? note);
  Future<bool> updateAccount(AccountModel account);
  Future<bool> deleteAccount(String id);
  double getTotalBalance(List<AccountModel> accounts);
}
