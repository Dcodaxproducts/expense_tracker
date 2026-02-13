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
  final _noteController = TextEditingController();
  final ValueNotifier<ExpenseCategory> _selectedCategory = ValueNotifier(ExpenseCategory.food);
  final ValueNotifier<DateTime> _selectedDate = ValueNotifier(DateTime.now());

  bool get isEditing => widget.expense != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _titleController.text = widget.expense!.title;
      _amountController.text = widget.expense!.amount.toStringAsFixed(2);
      _noteController.text = widget.expense!.note ?? '';
      _selectedCategory.value = widget.expense!.category;
      _selectedDate.value = widget.expense!.date;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    _selectedCategory.dispose();
    _selectedDate.dispose();
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
              leading: IconButton(
                icon: Icon(Iconsax.arrow_left, size: 22.sp),
                onPressed: pop,
              ),
              title: Text(
                isEditing ? 'Edit Expense' : 'Add Expense',
                style: context.font18.copyWith(fontWeight: FontWeight.w600),
              ),
              centerTitle: true,
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: AppPadding.padding16,
                children: [
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

                  // Amount
                  Text('Amount', style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                  SizedBox(height: 8.sp),
                  CustomTextField(
                    controller: _amountController,
                    hintText: 'Enter amount',
                    prefixIcon: Iconsax.dollar_circle,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter an amount';
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) return 'Enter a valid amount';
                      return null;
                    },
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
                              Text(
                                DateFormat('MMM dd, yyyy').format(date),
                                style: context.font14,
                              ),
                            ],
                          ),
                        ),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) _selectedDate.value = picked;
  }

  void _submit(ExpenseController controller) {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final amount = double.parse(_amountController.text.trim());
    final note = _noteController.text.trim().isEmpty ? null : _noteController.text.trim();

    if (isEditing) {
      final updated = ExpenseModel(
        id: widget.expense!.id,
        title: title,
        amount: amount,
        category: _selectedCategory.value,
        date: _selectedDate.value,
        note: note,
      );
      controller.updateExpense(updated);
    } else {
      controller.addExpense(title, amount, _selectedCategory.value, _selectedDate.value, note);
    }
    pop();
  }
}
