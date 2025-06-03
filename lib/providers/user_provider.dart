import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class UserProvider with ChangeNotifier {
  String? _email;
  String? _name;

  String? get email => _email;
  String? get name => _name;

  bool get isLoggedIn => _email != null;

  Future<void> setUser(String email, String name) async {
    _email = email;
    _name = name;
    await StorageService.saveUserSession(email);
    notifyListeners();
  }

  Future<void> loadUser() async {
    final email = await StorageService.getUserSession();
    if (email != null) {
      _email = email;
      _name = 'User'; // Default name, update as needed
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _email = null;
    _name = null;
    await StorageService.clearUserSession();
    notifyListeners();
  }
}