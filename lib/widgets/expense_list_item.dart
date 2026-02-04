import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../models/fixed_expense.dart';
import 'category_badge.dart';

class ExpenseListItem extends StatelessWidget {
  final FixedExpense expense;
  final bool showDaysUntil;
  final VoidCallback? onTap;

  const ExpenseListItem({
    super.key,
    required this.expense,
    this.showDaysUntil = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final daysUntil = expense.getDaysUntilPayment(DateTime.now());

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            // 아이콘
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.summaryCardBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  expense.icon ?? '💰',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 이름 및 카테고리
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        expense.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CategoryBadge(category: expense.category),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '매월 ${expense.paymentDay}일',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // 금액 및 남은 일수
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${numberFormat.format(expense.amount)}원',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (showDaysUntil) ...[
                  const SizedBox(height: 4),
                  Text(
                    daysUntil == 0 ? '오늘' : '${daysUntil}일 후',
                    style: TextStyle(
                      fontSize: 13,
                      color: daysUntil <= 3
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight:
                          daysUntil <= 3 ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}
