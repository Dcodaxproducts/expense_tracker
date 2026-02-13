import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/features/account/data/repository/account_repo.dart';
import 'package:expense_tracker/features/account/data/repository/account_repo_impl.dart';
import 'package:expense_tracker/features/account/domain/service/account_service.dart';
import 'package:expense_tracker/features/account/domain/service/account_service_impl.dart';
import 'package:expense_tracker/features/account/presentation/controller/account_controller.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountRepo>(() => AccountRepoImpl(prefs: Get.find<SharedPreferences>()));
    Get.lazyPut<AccountService>(() => AccountServiceImpl(repo: Get.find<AccountRepo>()));
    Get.lazyPut<AccountController>(() => AccountController(service: Get.find<AccountService>()));
  }
}
