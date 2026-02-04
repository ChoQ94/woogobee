import 'package:flutter/material.dart';
import '../models/fixed_expense.dart';

class CategoryBadge extends StatelessWidget {
  final ExpenseCategory category;
  final double fontSize;
  final EdgeInsets padding;

  const CategoryBadge({
    super.key,
    required this.category,
    this.fontSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: category.badgeColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        category.displayName,
        style: TextStyle(
          color: category.badgeTextColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
