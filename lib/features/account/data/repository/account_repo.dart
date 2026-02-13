abstract class AccountRepo {
  Future<bool> saveAccounts(String accountsJson);
  String? getAccounts();
}
