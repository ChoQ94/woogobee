import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// 고정비 카테고리
enum ExpenseCategory {
  subscription, // 구독
  communication, // 통신비
  utility, // 관리비
  insurance, // 보험
  other, // 기타
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get displayName {
    switch (this) {
      case ExpenseCategory.subscription:
        return '구독';
      case ExpenseCategory.communication:
        return '통신비';
      case ExpenseCategory.utility:
        return '관리비';
      case ExpenseCategory.insurance:
        return '보험';
      case ExpenseCategory.other:
        return '기타';
    }
  }

  Color get badgeColor {
    switch (this) {
      case ExpenseCategory.subscription:
        return AppColors.badgeSubscription;
      case ExpenseCategory.communication:
        return AppColors.badgeCommunication;
      case ExpenseCategory.utility:
        return AppColors.badgeUtility;
      case ExpenseCategory.insurance:
        return AppColors.badgeInsurance;
      case ExpenseCategory.other:
        return AppColors.primaryLight;
    }
  }

  Color get badgeTextColor {
    switch (this) {
      case ExpenseCategory.subscription:
        return AppColors.badgeTextSubscription;
      case ExpenseCategory.communication:
        return AppColors.badgeTextCommunication;
      case ExpenseCategory.utility:
        return AppColors.badgeTextUtility;
      case ExpenseCategory.insurance:
        return AppColors.badgeTextInsurance;
      case ExpenseCategory.other:
        return AppColors.primaryDark;
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseCategory.subscription:
        return Icons.subscriptions_outlined;
      case ExpenseCategory.communication:
        return Icons.wifi;
      case ExpenseCategory.utility:
        return Icons.apartment;
      case ExpenseCategory.insurance:
        return Icons.shield_outlined;
      case ExpenseCategory.other:
        return Icons.more_horiz;
    }
  }
}

/// 고정비 모델
class FixedExpense {
  final String id;
  final String name;
  final int amount;
  final int paymentDay; // 매월 결제일 (1-31)
  final ExpenseCategory category;
  final String? icon; // 커스텀 아이콘 (이모지 또는 아이콘 이름)
  final bool isShared; // 공유 고정비 여부
  final String? memo;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FixedExpense({
    required this.id,
    required this.name,
    required this.amount,
    required this.paymentDay,
    required this.category,
    this.icon,
    this.isShared = false,
    this.memo,
    required this.createdAt,
    this.updatedAt,
  });

  /// 다음 결제일 계산
  DateTime getNextPaymentDate(DateTime from) {
    final currentMonth = DateTime(from.year, from.month, 1);
    final paymentDateThisMonth = DateTime(from.year, from.month, paymentDay);

    if (from.day <= paymentDay) {
      // 이번 달 결제일이 아직 안 지남
      return paymentDateThisMonth;
    } else {
      // 이번 달 결제일이 지남 -> 다음 달
      final nextMonth = DateTime(from.year, from.month + 1, 1);
      return DateTime(nextMonth.year, nextMonth.month, paymentDay);
    }
  }

  /// 결제일까지 남은 일수
  int getDaysUntilPayment(DateTime from) {
    final nextPayment = getNextPaymentDate(from);
    return nextPayment.difference(DateTime(from.year, from.month, from.day)).inDays;
  }

  /// JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'payment_day': paymentDay,
      'category': category.name,
      'icon': icon,
      'is_shared': isShared,
      'memo': memo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory FixedExpense.fromJson(Map<String, dynamic> json) {
    return FixedExpense(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      paymentDay: json['payment_day'],
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ExpenseCategory.other,
      ),
      icon: json['icon'],
      isShared: json['is_shared'] ?? false,
      memo: json['memo'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  FixedExpense copyWith({
    String? id,
    String? name,
    int? amount,
    int? paymentDay,
    ExpenseCategory? category,
    String? icon,
    bool? isShared,
    String? memo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FixedExpense(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      paymentDay: paymentDay ?? this.paymentDay,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      isShared: isShared ?? this.isShared,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
