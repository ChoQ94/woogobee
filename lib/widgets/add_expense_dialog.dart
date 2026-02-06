import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_colors.dart';
import '../models/fixed_expense.dart';
import '../providers/expense_provider.dart';

class AddExpenseDialog extends StatefulWidget {
  const AddExpenseDialog({super.key});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _paymentDayController = TextEditingController(text: '1');

  bool _isShared = true;
  ExpenseCategory _selectedCategory = ExpenseCategory.subscription;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _paymentDayController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final amountText = _amountController.text.trim();
    final paymentDayText = _paymentDayController.text.trim();

    if (name.isEmpty) {
      _showError('이름을 입력해주세요');
      return;
    }

    final amount = int.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showError('올바른 금액을 입력해주세요');
      return;
    }

    final paymentDay = int.tryParse(paymentDayText);
    if (paymentDay == null || paymentDay < 1 || paymentDay > 31) {
      _showError('결제일은 1~31 사이로 입력해주세요');
      return;
    }

    final expense = FixedExpense(
      id: const Uuid().v4(),
      name: name,
      amount: amount,
      paymentDay: paymentDay,
      category: _selectedCategory,
      isShared: _isShared,
      createdAt: DateTime.now(),
    );

    context.read<ExpenseProvider>().addExpense(expense);
    Navigator.of(context).pop();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '고정비 등록',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: AppColors.textHint),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 공간 (공유/개인)
            const Text('공간', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            _buildDropdown<bool>(
              value: _isShared,
              items: const [
                DropdownMenuItem(value: true, child: _DropdownItem(icon: Icons.people, label: '공유')),
                DropdownMenuItem(value: false, child: _DropdownItem(icon: Icons.person, label: '개인')),
              ],
              onChanged: (value) => setState(() => _isShared = value ?? true),
            ),
            const SizedBox(height: 16),

            // 이름
            const Text('이름', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _nameController,
              hintText: '예) 넷플릭스',
            ),
            const SizedBox(height: 16),

            // 금액
            const Text('금액', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _amountController,
              hintText: '0',
              keyboardType: TextInputType.number,
              suffixText: '원',
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),

            // 매월 결제일
            const Text('매월 결제일', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _paymentDayController,
              hintText: '1',
              keyboardType: TextInputType.number,
              suffixText: '일',
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),

            // 카테고리
            const Text('카테고리', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            _buildDropdown<ExpenseCategory>(
              value: _selectedCategory,
              items: ExpenseCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: _DropdownItem(icon: category.icon, label: category.displayName),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedCategory = value ?? ExpenseCategory.subscription),
            ),
            const SizedBox(height: 24),

            // 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소', style: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('등록'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    String? suffixText,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textHint),
        suffixText: suffixText,
        suffixStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textHint),
      ),
    );
  }
}

class _DropdownItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DropdownItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: AppColors.textPrimary)),
      ],
    );
  }
}
