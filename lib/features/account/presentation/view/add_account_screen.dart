import 'package:expense_tracker/imports.dart';
import 'package:expense_tracker/features/account/data/model/account_model.dart';
import 'package:expense_tracker/features/account/data/model/account_type.dart';
import 'package:expense_tracker/features/account/presentation/controller/account_controller.dart';

class AddAccountScreen extends StatefulWidget {
  final AccountModel? account;
  const AddAccountScreen({super.key, this.account});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _noteController = TextEditingController();
  final ValueNotifier<AccountType> _selectedType = ValueNotifier(AccountType.cash);

  bool get isEditing => widget.account != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.account!.name;
      _balanceController.text = widget.account!.balance.toStringAsFixed(2);
      _noteController.text = widget.account!.note ?? '';
      _selectedType.value = widget.account!.type;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _noteController.dispose();
    _selectedType.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(
      builder: (controller) {
        return AbsorbPointer(
          absorbing: controller.isLoading,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Iconsax.arrow_left, size: 22.sp),
                onPressed: pop,
              ),
              title: Text(
                isEditing ? 'Edit Account' : 'Add Account',
                style: context.font18.copyWith(fontWeight: FontWeight.w600),
              ),
              centerTitle: true,
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: AppPadding.padding16,
                children: [
                  // Name
                  Text('Account Name', style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                  SizedBox(height: 8.sp),
                  CustomTextField(
                    controller: _nameController,
                    hintText: 'e.g. Main Bank Account',
                    prefixIcon: Iconsax.edit,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter account name';
                      return null;
                    },
                  ),
                  SizedBox(height: 16.sp),

                  // Balance
                  Text('Balance', style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                  SizedBox(height: 8.sp),
                  CustomTextField(
                    controller: _balanceController,
                    hintText: 'Enter current balance',
                    prefixIcon: Iconsax.dollar_circle,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter balance';
                      if (double.tryParse(value) == null) return 'Enter a valid number';
                      return null;
                    },
                  ),
                  SizedBox(height: 16.sp),

                  // Account Type
                  Text('Account Type', style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                  SizedBox(height: 8.sp),
                  ValueListenableBuilder<AccountType>(
                    valueListenable: _selectedType,
                    builder: (context, selectedType, _) {
                      return Wrap(
                        spacing: 8.sp,
                        runSpacing: 8.sp,
                        children: AccountType.values.map((type) {
                          final isSelected = type == selectedType;
                          return GestureDetector(
                            onTap: () => _selectedType.value = type,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
                              decoration: BoxDecoration(
                                color: isSelected ? type.color.withValues(alpha: 0.2) : Theme.of(context).cardColor,
                                borderRadius: AppRadius.circular8,
                                border: Border.all(
                                  color: isSelected ? type.color : Theme.of(context).dividerColor,
                                  width: 1.5.sp,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(type.icon, size: 16.sp, color: type.color),
                                  SizedBox(width: 6.sp),
                                  Text(
                                    type.displayName,
                                    style: context.font12.copyWith(
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      color: isSelected ? type.color : Theme.of(context).textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  SizedBox(height: 16.sp),

                  // Note
                  Text('Note (optional)', style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                  SizedBox(height: 8.sp),
                  CustomTextField(
                    controller: _noteController,
                    hintText: 'Add a note',
                    prefixIcon: Iconsax.note_1,
                  ),
                  SizedBox(height: 32.sp),

                  // Submit
                  PrimaryButton(
                    text: isEditing ? 'Update Account' : 'Add Account',
                    onPressed: controller.isLoading ? null : () => _submit(controller),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _submit(AccountController controller) {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final balance = double.parse(_balanceController.text.trim());
    final note = _noteController.text.trim().isEmpty ? null : _noteController.text.trim();

    if (isEditing) {
      final updated = AccountModel(
        id: widget.account!.id,
        name: name,
        type: _selectedType.value,
        balance: balance,
        note: note,
      );
      controller.updateAccount(updated);
    } else {
      controller.addAccount(name, _selectedType.value, balance, note);
    }
    pop();
  }
}
