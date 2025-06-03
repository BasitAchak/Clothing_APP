class User {
  final String email;
  final String name;

  User({required this.email, required this.name});
}

class AuthService {
  // In-memory store of registered users: email -> User
  static final Map<String, User> _registeredUsers = {};

  static Future<User> signup(String email, String name, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isNotEmpty && name.isNotEmpty && password.length >= 6) {
      if (_registeredUsers.containsKey(email)) {
        throw Exception('Email already registered');
      }
      final user = User(email: email, name: name);
      _registeredUsers[email] = user;
      // Note: Password is not stored in this simple example.
      return user;
    }
    throw Exception('Invalid signup details');
  }

  static Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    final user = _registeredUsers[email];
    if (user != null) {
      // For this example, password is not checked (you can extend this later)
      return user;
    }
    throw Exception('Invalid email or password');
  }

  static Future<void> changePassword(String email, String oldPassword, String newPassword) async {
    await Future.delayed(const Duration(seconds: 1));
    if (_registeredUsers.containsKey(email)) {
      // Add password change logic if you store passwords
      return;
    }
    throw Exception('Password change failed');
  }

  static Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
