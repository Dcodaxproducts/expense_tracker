import 'package:expense_tracker/imports.dart';
import 'package:expense_tracker/features/expense/data/model/expense_model.dart';
import 'package:expense_tracker/features/expense/data/model/expense_category.dart';
import 'package:expense_tracker/features/expense/presentation/controller/expense_controller.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  final ExpenseModel? expense;
  const AddExpenseScreen({super.key, this.expense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _vatController = TextEditingController();
  final _noteController = TextEditingController();
  final ValueNotifier<ExpenseCategory> _selectedCategory = ValueNotifier(ExpenseCategory.food);
  final ValueNotifier<DateTime> _selectedDate = ValueNotifier(DateTime.now());
  final ValueNotifier<String> _paymentMethod = ValueNotifier('Cash');
  final ValueNotifier<bool> _isIncome = ValueNotifier(false);

  bool get isEditing => widget.expense != null;

  static const List<String> _paymentMethods = ['Cash', 'Google Pay', 'Paytm', 'Bank Transfer', 'Credit Card'];

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _titleController.text = widget.expense!.title;
      _amountController.text = widget.expense!.amount.toStringAsFixed(2);
      _vatController.text = widget.expense!.vatPercent > 0 ? widget.expense!.vatPercent.toString() : '';
      _noteController.text = widget.expense!.note ?? '';
      _selectedCategory.value = widget.expense!.category;
      _selectedDate.value = widget.expense!.date;
      _paymentMethod.value = widget.expense!.paymentMethod;
      _isIncome.value = widget.expense!.isIncome;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _vatController.dispose();
    _noteController.dispose();
    _selectedCategory.dispose();
    _selectedDate.dispose();
    _paymentMethod.dispose();
    _isIncome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpenseController>(
      builder: (controller) {
        return AbsorbPointer(
          absorbing: controller.isLoading,
          child: Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: pop,
                child: Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).dividerColor, width: 1.5.sp),
                    ),
                    child: Icon(Iconsax.arrow_left_2, size: 16.sp),
                  ),
                ),
              ),
              title: Text(
                isEditing ? 'Edit Expense' : 'Add Expense',
                style: context.font18.copyWith(fontWeight: FontWeight.w600),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: AppPadding.padding16,
                children: [
                  // Income/Expense toggle
                  ValueListenableBuilder<bool>(
                    valueListenable: _isIncome,
                    builder: (context, isIncome, _) {
                      return Row(
                        children: [
                          _toggleChip(context, 'Expense', !isIncome, () => _isIncome.value = false),
                          SizedBox(width: 8.sp),
                          _toggleChip(context, 'Income', isIncome, () => _isIncome.value = true),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 16.sp),

                  // Title
                  Text('Title', style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                  SizedBox(height: 8.sp),
                  CustomTextField(
                    controller: _titleController,
                    hintText: 'Enter expense title',
                    prefixIcon: Iconsax.edit,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter a title';
                      return null;
                    },
                  ),
                  SizedBox(height: 16.sp),

                  // Amount + VAT row
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Amount', style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                            SizedBox(height: 8.sp),
                            CustomTextField(
                              controller: _amountController,
                              hintText: 'Amount',
                              prefixIcon: Iconsax.dollar_circle,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Required';
                                final amount = double.tryParse(value);
                                if (amount == null || amount <= 0) return 'Invalid';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.sp),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('VAT %', style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                            SizedBox(height: 8.sp),
                            CustomTextField(
                              controller: _vatController,
                              hintText: '0.0',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.sp),

                  // Category
                  Text('Category', style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                  SizedBox(height: 8.sp),
                  ValueListenableBuilder<ExpenseCategory>(
                    valueListenable: _selectedCategory,
                    builder: (context, selectedCategory, _) {
                      return Wrap(
                        spacing: 8.sp,
                        runSpacing: 8.sp,
                        children: ExpenseCategory.values.map((category) {
                          final isSelected = category == selectedCategory;
                          return GestureDetector(
                            onTap: () => _selectedCategory.value = category,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
                              decoration: BoxDecoration(
                                color: isSelected ? category.color.withValues(alpha: 0.2) : Theme.of(context).cardColor,
                                borderRadius: AppRadius.circular8,
                                border: Border.all(
                                  color: isSelected ? category.color : Theme.of(context).dividerColor,
                                  width: 1.5.sp,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(category.icon, size: 16.sp, color: category.color),
                                  SizedBox(width: 6.sp),
                                  Text(
                                    category.displayName,
                                    style: context.font12.copyWith(
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      color: isSelected ? category.color : Theme.of(context).textTheme.bodyMedium?.color,
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

                  // Date
                  Text('Date', style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                  SizedBox(height: 8.sp),
                  ValueListenableBuilder<DateTime>(
                    valueListenable: _selectedDate,
                    builder: (context, date, _) {
                      return GestureDetector(
                        onTap: () => _pickDate(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 14.sp),
                          decoration: BoxDecoration(
                            borderRadius: AppRadius.circular8,
                            border: Border.all(color: Theme.of(context).dividerColor),
                          ),
                          child: Row(
                            children: [
                              Icon(Iconsax.calendar_1, size: 20.sp, color: Theme.of(context).hintColor),
                              SizedBox(width: 10.sp),
                              Text(DateFormat('MMM dd, yyyy').format(date), style: context.font14),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16.sp),

                  // Payment Method
                  Text('Payment Method', style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                  SizedBox(height: 8.sp),
                  ValueListenableBuilder<String>(
                    valueListenable: _paymentMethod,
                    builder: (context, selected, _) {
                      return Wrap(
                        spacing: 8.sp,
                        runSpacing: 8.sp,
                        children: _paymentMethods.map((method) {
                          final isSelected = method == selected;
                          return GestureDetector(
                            onTap: () => _paymentMethod.value = method,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
                              decoration: BoxDecoration(
                                color: isSelected ? primaryColor.withValues(alpha: 0.15) : Theme.of(context).cardColor,
                                borderRadius: AppRadius.circular8,
                                border: Border.all(
                                  color: isSelected ? primaryColor : Theme.of(context).dividerColor,
                                  width: 1.5.sp,
                                ),
                              ),
                              child: Text(
                                method,
                                style: context.font12.copyWith(
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: isSelected ? primaryColor : Theme.of(context).textTheme.bodyMedium?.color,
                                ),
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
                    text: isEditing ? 'Update Expense' : 'Add Expense',
                    onPressed: controller.isLoading ? null : () => _submit(controller),
                  ),
                  SizedBox(height: 16.sp),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _toggleChip(BuildContext context, String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
        decoration: BoxDecoration(
          color: active ? primaryColor : Theme.of(context).cardColor,
          borderRadius: AppRadius.circular8,
          border: Border.all(color: active ? primaryColor : Theme.of(context).dividerColor),
        ),
        child: Text(
          text,
          style: context.font12.copyWith(
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) _selectedDate.value = picked;
  }

  void _submit(ExpenseController controller) {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final amount = double.parse(_amountController.text.trim());
    final vatPercent = double.tryParse(_vatController.text.trim()) ?? 0.0;
    final note = _noteController.text.trim().isEmpty ? null : _noteController.text.trim();

    if (isEditing) {
      final updated = ExpenseModel(
        id: widget.expense!.id,
        title: title,
        amount: amount,
        category: _selectedCategory.value,
        date: _selectedDate.value,
        note: note,
        vatPercent: vatPercent,
        paymentMethod: _paymentMethod.value,
        isIncome: _isIncome.value,
      );
      controller.updateExpense(updated);
    } else {
      controller.addExpense(
        title: title,
        amount: amount,
        category: _selectedCategory.value,
        date: _selectedDate.value,
        note: note,
        vatPercent: vatPercent,
        paymentMethod: _paymentMethod.value,
        isIncome: _isIncome.value,
      );
    }
    pop();
  }
}
