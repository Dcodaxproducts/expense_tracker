import 'package:shared_preferences/shared_preferences.dart';
import 'account_repo.dart';

class AccountRepoImpl implements AccountRepo {
  final SharedPreferences prefs;
  AccountRepoImpl({required this.prefs});

  static const String _accountsKey = 'accounts_data';

  @override
  Future<bool> saveAccounts(String accountsJson) async {
    return await prefs.setString(_accountsKey, accountsJson);
  }

  @override
  String? getAccounts() => prefs.getString(_accountsKey);
}
