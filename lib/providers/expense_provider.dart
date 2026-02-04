import 'package:flutter/foundation.dart';
import '../models/fixed_expense.dart';

class ExpenseProvider extends ChangeNotifier {
  List<FixedExpense> _expenses = [];
  bool _showSharedOnly = false; // false: 개인, true: 공유

  List<FixedExpense> get expenses => _expenses;
  bool get showSharedOnly => _showSharedOnly;

  /// 현재 필터에 맞는 고정비 목록
  List<FixedExpense> get filteredExpenses {
    return _expenses.where((e) => e.isShared == _showSharedOnly).toList();
  }

  /// 이번 달 총 고정비
  int get totalMonthlyExpense {
    return filteredExpenses.fold(0, (sum, e) => sum + e.amount);
  }

  /// 카테고리별 고정비 그룹
  Map<ExpenseCategory, List<FixedExpense>> get expensesByCategory {
    final map = <ExpenseCategory, List<FixedExpense>>{};
    for (final expense in filteredExpenses) {
      map.putIfAbsent(expense.category, () => []).add(expense);
    }
    return map;
  }

  /// 카테고리별 총액
  Map<ExpenseCategory, int> get totalByCategory {
    final map = <ExpenseCategory, int>{};
    for (final expense in filteredExpenses) {
      map[expense.category] = (map[expense.category] ?? 0) + expense.amount;
    }
    return map;
  }

  /// 다가오는 결제 목록 (결제일 기준 정렬)
  List<FixedExpense> getUpcomingPayments(DateTime from) {
    final sorted = List<FixedExpense>.from(filteredExpenses);
    sorted.sort((a, b) =>
        a.getDaysUntilPayment(from).compareTo(b.getDaysUntilPayment(from)));
    return sorted;
  }

  /// 특정 날짜에 결제되는 고정비 목록
  List<FixedExpense> getExpensesForDay(int day) {
    return filteredExpenses.where((e) => e.paymentDay == day).toList();
  }

  /// 특정 날짜의 총 결제 금액
  int getTotalForDay(int day) {
    return getExpensesForDay(day).fold(0, (sum, e) => sum + e.amount);
  }

  /// 개인/공유 토글
  void toggleSharedFilter(bool showShared) {
    _showSharedOnly = showShared;
    notifyListeners();
  }

  /// 고정비 추가
  void addExpense(FixedExpense expense) {
    _expenses.add(expense);
    notifyListeners();
  }

  /// 고정비 수정
  void updateExpense(FixedExpense expense) {
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
      notifyListeners();
    }
  }

  /// 고정비 삭제
  void deleteExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  /// 샘플 데이터 로드 (테스트용)
  void loadSampleData() {
    _expenses = [
      FixedExpense(
        id: '1',
        name: '넷플릭스',
        amount: 17000,
        paymentDay: 5,
        category: ExpenseCategory.subscription,
        icon: '📺',
        createdAt: DateTime.now(),
      ),
      FixedExpense(
        id: '2',
        name: '인터넷',
        amount: 35000,
        paymentDay: 5,
        category: ExpenseCategory.communication,
        icon: '📺',
        createdAt: DateTime.now(),
      ),
      FixedExpense(
        id: '3',
        name: '아파트 관리비',
        amount: 150000,
        paymentDay: 10,
        category: ExpenseCategory.utility,
        icon: '🏠',
        createdAt: DateTime.now(),
      ),
      FixedExpense(
        id: '4',
        name: '자동차 보험',
        amount: 85000,
        paymentDay: 15,
        category: ExpenseCategory.insurance,
        icon: '🚗',
        createdAt: DateTime.now(),
      ),
      FixedExpense(
        id: '5',
        name: '스포티파이',
        amount: 10900,
        paymentDay: 18,
        category: ExpenseCategory.subscription,
        icon: '🎵',
        createdAt: DateTime.now(),
      ),
      FixedExpense(
        id: '6',
        name: '건강보험',
        amount: 120000,
        paymentDay: 25,
        category: ExpenseCategory.insurance,
        icon: '🏥',
        createdAt: DateTime.now(),
      ),
    ];
    notifyListeners();
  }
}
