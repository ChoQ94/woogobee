import '../models/fixed_expense.dart';
import '../providers/expense_provider.dart';
import 'base_viewmodel.dart';

/// HomeScreen의 비즈니스 로직을 담당하는 ViewModel
class HomeViewModel extends BaseViewModel {
  final ExpenseProvider _expenseProvider;

  HomeViewModel(this._expenseProvider) {
    _expenseProvider.addListener(_onProviderChanged);
  }

  void _onProviderChanged() {
    notifyListeners();
  }

  // === Getters ===

  /// 개인/공유 필터 상태
  bool get showSharedOnly => _expenseProvider.showSharedOnly;

  /// 이번 달 총 고정비
  int get totalMonthlyExpense => _expenseProvider.totalMonthlyExpense;

  /// 필터링된 고정비 개수
  int get filteredExpenseCount => _expenseProvider.filteredExpenses.length;

  /// 다가오는 결제 목록
  List<FixedExpense> get upcomingPayments =>
      _expenseProvider.getUpcomingPayments(DateTime.now());

  /// 결제 목록이 비어있는지 확인
  bool get hasNoPayments => upcomingPayments.isEmpty;

  // === Actions ===

  /// 개인/공유 필터 토글
  void toggleSharedFilter(bool showShared) {
    _expenseProvider.toggleSharedFilter(showShared);
  }

  @override
  void dispose() {
    _expenseProvider.removeListener(_onProviderChanged);
    super.dispose();
  }
}
