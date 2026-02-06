import '../models/fixed_expense.dart';
import '../providers/expense_provider.dart';
import 'base_viewmodel.dart';

/// CalendarScreen의 비즈니스 로직을 담당하는 ViewModel
class CalendarViewModel extends BaseViewModel {
  final ExpenseProvider _expenseProvider;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  CalendarViewModel(this._expenseProvider) {
    _expenseProvider.addListener(_onProviderChanged);
  }

  void _onProviderChanged() {
    notifyListeners();
  }

  // === Getters ===

  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;

  /// 개인/공유 필터 상태
  bool get showSharedOnly => _expenseProvider.showSharedOnly;

  /// 특정 날짜의 총 결제 금액
  int getTotalForDay(int day) => _expenseProvider.getTotalForDay(day);

  /// 특정 날짜에 결제되는 고정비 목록
  List<FixedExpense> getExpensesForDay(int day) => _expenseProvider.getExpensesForDay(day);

  // === Actions ===

  /// 날짜 선택
  void selectDay(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
    notifyListeners();
  }

  /// 페이지 변경 (달력 스와이프)
  void onPageChanged(DateTime focusedDay) {
    _focusedDay = focusedDay;
    // 페이지 변경 시에는 notifyListeners 호출하지 않음 (성능 최적화)
  }

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
