import 'base_viewmodel.dart';

/// MainScreen의 비즈니스 로직을 담당하는 ViewModel
class MainViewModel extends BaseViewModel {
  int _currentIndex = 0;

  // === Getters ===

  int get currentIndex => _currentIndex;

  /// 현재 선택된 탭의 타이틀
  String get currentTitle {
    switch (_currentIndex) {
      case 0:
        return '홈';
      case 1:
        return '달력';
      case 2:
        return '리스트';
      default:
        return '고정비 관리';
    }
  }

  // === Actions ===

  /// 탭 변경
  void setCurrentIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  /// 등록 화면으로 이동 (추후 구현)
  void navigateToAddExpense() {
    // TODO: 등록 화면 네비게이션 로직
  }
}
