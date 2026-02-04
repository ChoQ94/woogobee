import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/expense_provider.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/expense_list_item.dart';
import '../widgets/filter_toggle.dart';
import '../widgets/summary_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(
        context.read<ExpenseProvider>(),
      ),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

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

          // 이번 달 고정비 요약 카드
          SummaryCard(
            totalAmount: viewModel.totalMonthlyExpense,
            itemCount: viewModel.filteredExpenseCount,
          ),
          const SizedBox(height: 28),

          // 다가오는 결제 섹션
          const Text(
            '다가오는 결제',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // 결제 목록
          if (viewModel.hasNoPayments)
            _buildEmptyState()
          else
            _buildPaymentList(viewModel),
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
            Icons.check_circle_outline,
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

  Widget _buildPaymentList(HomeViewModel viewModel) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.upcomingPayments.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return ExpenseListItem(
          expense: viewModel.upcomingPayments[index],
          showDaysUntil: true,
        );
      },
    );
  }
}
