import '../models/fixed_expense.dart';
import '../providers/expense_provider.dart';
import 'base_viewmodel.dart';

/// 정렬 기준
enum SortBy { date, amount, name }

/// ListScreen의 비즈니스 로직을 담당하는 ViewModel
class ListViewModel extends BaseViewModel {
  final ExpenseProvider _expenseProvider;

  ExpenseCategory? _selectedCategory;
  SortBy _sortBy = SortBy.date;
  final Map<ExpenseCategory, bool> _expandedCategories = {};

  ListViewModel(this._expenseProvider) {
    _expenseProvider.addListener(_onProviderChanged);
  }

  void _onProviderChanged() {
    notifyListeners();
  }

  // === Getters ===

  /// 개인/공유 필터 상태
  bool get showSharedOnly => _expenseProvider.showSharedOnly;

  /// 선택된 카테고리 필터
  ExpenseCategory? get selectedCategory => _selectedCategory;

  /// 현재 정렬 기준
  SortBy get sortBy => _sortBy;

  /// 이번 달 총 고정비
  int get totalMonthlyExpense => _expenseProvider.totalMonthlyExpense;

  /// 필터링된 고정비 개수
  int get filteredExpenseCount => _expenseProvider.filteredExpenses.length;

  /// 카테고리별 고정비 그룹
  Map<ExpenseCategory, List<FixedExpense>> get expensesByCategory {
    var expenses = _expenseProvider.expensesByCategory;

    // 카테고리 필터 적용
    if (_selectedCategory != null) {
      expenses = {
        if (expenses.containsKey(_selectedCategory))
          _selectedCategory!: expenses[_selectedCategory]!
      };
    }

    // 정렬 적용
    for (final category in expenses.keys) {
      final list = expenses[category]!;
      switch (_sortBy) {
        case SortBy.date:
          list.sort((a, b) => a.paymentDay.compareTo(b.paymentDay));
          break;
        case SortBy.amount:
          list.sort((a, b) => b.amount.compareTo(a.amount));
          break;
        case SortBy.name:
          list.sort((a, b) => a.name.compareTo(b.name));
          break;
      }
    }

    return expenses;
  }

  /// 카테고리별 총액
  Map<ExpenseCategory, int> get totalByCategory =>
      _expenseProvider.totalByCategory;

  /// 고정비 목록이 비어있는지 확인
  bool get hasNoExpenses => expensesByCategory.isEmpty;

  /// 카테고리 확장 상태 확인
  bool isCategoryExpanded(ExpenseCategory category) =>
      _expandedCategories[category] ?? true;

  // === Actions ===

  /// 개인/공유 필터 토글
  void toggleSharedFilter(bool showShared) {
    _expenseProvider.toggleSharedFilter(showShared);
  }

  /// 카테고리 필터 변경
  void setSelectedCategory(ExpenseCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// 정렬 기준 변경
  void setSortBy(SortBy sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  /// 정렬 기준 변경 (문자열 버전 - 드롭다운용)
  void setSortByString(String sortByString) {
    switch (sortByString) {
      case 'date':
        setSortBy(SortBy.date);
        break;
      case 'amount':
        setSortBy(SortBy.amount);
        break;
      case 'name':
        setSortBy(SortBy.name);
        break;
    }
  }

  /// 정렬 기준을 문자열로 반환
  String get sortByString {
    switch (_sortBy) {
      case SortBy.date:
        return 'date';
      case SortBy.amount:
        return 'amount';
      case SortBy.name:
        return 'name';
    }
  }

  /// 카테고리 확장/축소 토글
  void toggleCategoryExpanded(ExpenseCategory category) {
    _expandedCategories[category] = !isCategoryExpanded(category);
    notifyListeners();
  }

  @override
  void dispose() {
    _expenseProvider.removeListener(_onProviderChanged);
    super.dispose();
  }
}
