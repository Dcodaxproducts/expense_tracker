import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/features/expense/data/repository/expense_repo.dart';
import 'package:expense_tracker/features/expense/data/repository/expense_repo_impl.dart';
import 'package:expense_tracker/features/expense/domain/service/expense_service.dart';
import 'package:expense_tracker/features/expense/domain/service/expense_service_impl.dart';
import 'package:expense_tracker/features/expense/presentation/controller/expense_controller.dart';

class ExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseRepo>(() => ExpenseRepoImpl(prefs: Get.find<SharedPreferences>()));
    Get.lazyPut<ExpenseService>(() => ExpenseServiceImpl(repo: Get.find<ExpenseRepo>()));
    Get.lazyPut<ExpenseController>(() => ExpenseController(service: Get.find<ExpenseService>()));
  }
}
