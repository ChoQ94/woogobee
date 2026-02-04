import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';

class SummaryCard extends StatelessWidget {
  final int totalAmount;
  final int itemCount;

  const SummaryCard({
    super.key,
    required this.totalAmount,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.summaryCardBackground,
            AppColors.primaryLight.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                '이번 달 고정비',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${numberFormat.format(totalAmount)}원',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '총 $itemCount개 항목',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
