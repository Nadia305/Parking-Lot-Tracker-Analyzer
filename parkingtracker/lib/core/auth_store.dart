import 'package:flutter/foundation.dart';

class AuthStore extends ChangeNotifier {
  AuthStore._();
  static final AuthStore I = AuthStore._();

  // TODO: replace with secure storage/backend later
  static const String _adminPassword = 'admin123';

  bool _isInitUnlocked = false;
  bool get isInitUnlocked => _isInitUnlocked;

  bool tryUnlock(String password) {
    if (password == _adminPassword) {
      _isInitUnlocked = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void lock() {
    _isInitUnlocked = false;
    notifyListeners();
  }
}
