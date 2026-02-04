import 'package:flutter/foundation.dart';

/// 모든 ViewModel의 베이스 클래스
/// 테스트 시 쉽게 mock 가능하도록 추상화
abstract class BaseViewModel extends ChangeNotifier {
  bool _isDisposed = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  @protected
  void setLoading(bool value) {
    if (_isDisposed) return;
    _isLoading = value;
    notifyListeners();
  }

  @protected
  void setError(String? message) {
    if (_isDisposed) return;
    _errorMessage = message;
    notifyListeners();
  }

  @protected
  void clearError() {
    setError(null);
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
