import 'package:expense_tracker/imports.dart';
import 'package:expense_tracker/core/widgets/confirmation_dialog.dart';
import 'package:expense_tracker/features/account/data/model/account_model.dart';
import 'package:expense_tracker/features/account/presentation/controller/account_controller.dart';
import 'package:expense_tracker/features/account/presentation/view/add_account_screen.dart';
import 'package:expense_tracker/features/account/presentation/widgets/account_card.dart';
import 'package:intl/intl.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Iconsax.arrow_left, size: 22.sp),
              onPressed: pop,
            ),
            title: Text(
              'Accounts',
              style: context.font20.copyWith(fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: () async {
              await launchScreen(const AddAccountScreen());
              controller.loadAccounts();
            },
            child: Icon(Iconsax.add, color: Colors.white, size: 24.sp),
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: AppPadding.padding16,
                  children: [
                    // Total balance card
                    _buildTotalBalanceCard(context, controller),
                    SizedBox(height: 20.sp),

                    // Accounts list
                    Text(
                      'Your Accounts',
                      style: context.font16.copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8.sp),

                    if (controller.accounts.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 60.sp),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Iconsax.bank, size: 64.sp, color: Theme.of(context).hintColor),
                              SizedBox(height: 16.sp),
                              Text(
                                'No accounts yet',
                                style: context.font16.copyWith(color: Theme.of(context).hintColor),
                              ),
                              SizedBox(height: 4.sp),
                              Text(
                                'Tap + to add your first account',
                                style: context.font12.copyWith(color: Theme.of(context).hintColor),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...controller.accounts.map((account) {
                        return AccountCard(
                          account: account,
                          onTap: () async {
                            await launchScreen(AddAccountScreen(account: account));
                            controller.loadAccounts();
                          },
                          onDelete: () => _confirmDelete(context, controller, account),
                        );
                      }),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildTotalBalanceCard(BuildContext context, AccountController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        gradient: primaryGradient,
        borderRadius: AppRadius.circular16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: context.font14.copyWith(color: Colors.white70, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8.sp),
          Text(
            NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(controller.totalBalance),
            style: context.font28.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4.sp),
          Text(
            '${controller.accounts.length} account${controller.accounts.length == 1 ? '' : 's'}',
            style: context.font12.copyWith(color: Colors.white60),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, AccountController controller, AccountModel account) {
    showConfirmationDialog(
      title: 'Delete Account',
      subtitle: 'Are you sure you want to delete "${account.name}"?',
      actionText: 'Delete',
      onAccept: () {
        controller.deleteAccount(account.id);
        pop();
      },
    );
  }
}
