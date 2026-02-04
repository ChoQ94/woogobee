import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/fixed_expense.dart';
import '../providers/expense_provider.dart';
import '../viewmodels/list_viewmodel.dart';
import '../widgets/filter_toggle.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ListViewModel(
        context.read<ExpenseProvider>(),
      ),
      child: const _ListScreenContent(),
    );
  }
}

class _ListScreenContent extends StatelessWidget {
  const _ListScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ListViewModel>();
    final numberFormat = NumberFormat('#,###');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 개인/공유 토글
          FilterToggle(
            isSharedSelected: viewModel.showSharedOnly,
            onChanged: viewModel.toggleSharedFilter,
          ),
          const SizedBox(height: 20),

          // 필터 및 정렬
          _FilterRow(viewModel: viewModel),
          const SizedBox(height: 16),

          // 총 항목 및 금액
          _buildSummaryBar(viewModel, numberFormat),
          const SizedBox(height: 20),

          // 카테고리별 그룹
          if (viewModel.hasNoExpenses)
            _buildEmptyState()
          else
            ...viewModel.expensesByCategory.entries.map((entry) {
              final category = entry.key;
              final expenses = entry.value;
              final total = viewModel.totalByCategory[category] ?? 0;
              final isExpanded = viewModel.isCategoryExpanded(category);

              return _CategoryGroup(
                category: category,
                expenses: expenses,
                total: total,
                isExpanded: isExpanded,
                numberFormat: numberFormat,
                onToggle: () => viewModel.toggleCategoryExpanded(category),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildSummaryBar(ListViewModel viewModel, NumberFormat numberFormat) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.summaryCardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '총 ${viewModel.filteredExpenseCount}개 항목',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            '${numberFormat.format(viewModel.totalMonthlyExpense)}원',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.list_alt,
            size: 48,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 12),
          Text(
            '등록된 고정비가 없습니다',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final ListViewModel viewModel;

  const _FilterRow({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 카테고리 필터
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ExpenseCategory?>(
                value: viewModel.selectedCategory,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary),
                hint: Row(
                  children: [
                    Icon(Icons.filter_list,
                        size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    const Text('전체'),
                  ],
                ),
                items: [
                  const DropdownMenuItem<ExpenseCategory?>(
                    value: null,
                    child: Text('전체'),
                  ),
                  ...ExpenseCategory.values.map((category) {
                    return DropdownMenuItem<ExpenseCategory?>(
                      value: category,
                      child: Text(category.displayName),
                    );
                  }),
                ],
                onChanged: (value) {
                  viewModel.setSelectedCategory(value);
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // 정렬
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: viewModel.sortByString,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary),
                items: const [
                  DropdownMenuItem(value: 'date', child: Text('날짜순')),
                  DropdownMenuItem(value: 'amount', child: Text('금액순')),
                  DropdownMenuItem(value: 'name', child: Text('이름순')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    viewModel.setSortByString(value);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryGroup extends StatelessWidget {
  final ExpenseCategory category;
  final List<FixedExpense> expenses;
  final int total;
  final bool isExpanded;
  final NumberFormat numberFormat;
  final VoidCallback onToggle;

  const _CategoryGroup({
    required this.category,
    required this.expenses,
    required this.total,
    required this.isExpanded,
    required this.numberFormat,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          // 카테고리 헤더
          InkWell(
            onTap: onToggle,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: category.badgeColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      category.icon,
                      color: category.badgeTextColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.displayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${expenses.length}개 항목',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${numberFormat.format(total)}원',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          // 항목 목록
          if (isExpanded)
            Column(
              children: expenses.map((expense) {
                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.divider),
                    ),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    title: Text(
                      expense.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      '매월 ${expense.paymentDay}일',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    trailing: Text(
                      '${numberFormat.format(expense.amount)}원',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
