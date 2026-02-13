import 'package:expense_tracker/imports.dart';
import 'package:expense_tracker/features/account/data/model/account_model.dart';
import 'package:expense_tracker/features/account/data/model/account_type.dart';
import 'package:expense_tracker/features/account/domain/service/account_service.dart';

class AccountController extends GetxController implements GetxService {
  final AccountService service;
  AccountController({required this.service});

  static AccountController get find => Get.find<AccountController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  List<AccountModel> _accounts = [];
  List<AccountModel> get accounts => _accounts;

  double _totalBalance = 0.0;
  double get totalBalance => _totalBalance;

  @override
  void onInit() {
    super.onInit();
    loadAccounts();
  }

  void loadAccounts() {
    try {
      isLoading = true;
      _accounts = service.getAccounts();
      _totalBalance = service.getTotalBalance(_accounts);
      isLoading = false;
    } catch (e) {
      showToast('Failed to load accounts: $e');
      isLoading = false;
    }
  }

  Future<void> addAccount(String name, AccountType type, double balance, String? note) async {
    try {
      isLoading = true;
      final success = await service.addAccount(name, type, balance, note);
      if (success) {
        loadAccounts();
        showToast('Account added');
      }
    } catch (e) {
      showToast('Failed to add account: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> updateAccount(AccountModel account) async {
    try {
      isLoading = true;
      final success = await service.updateAccount(account);
      if (success) {
        loadAccounts();
        showToast('Account updated');
      }
    } catch (e) {
      showToast('Failed to update account: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> deleteAccount(String id) async {
    try {
      isLoading = true;
      final success = await service.deleteAccount(id);
      if (success) {
        loadAccounts();
        showToast('Account deleted');
      }
    } catch (e) {
      showToast('Failed to delete account: $e');
    } finally {
      isLoading = false;
    }
  }
}
