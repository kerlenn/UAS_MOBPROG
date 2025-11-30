import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = false;
  bool _isLoggedIn = false;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;

  // Check login status saat app pertama kali dibuka
  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    _isLoggedIn = await _authService.isLoggedIn();
    if (_isLoggedIn) {
      _user = await _authService.getUserLocally();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Login function
  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.login(email, password);

    if (result['success']) {
      _user = result['user'];
      _isLoggedIn = true;
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  // Register function
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.register(
      username: username,
      email: email,
      phone: phone,
      password: password,
    );

    if (result['success']) {
      _user = result['user'];
      _isLoggedIn = true;
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  // Logout function
  Future<bool> logout() async {
    _isLoading = true;
    notifyListeners();

    final success = await _authService.logout();

    if (success) {
      _user = null;
      _isLoggedIn = false;
      print('✅ AuthProvider: User berhasil logout'); // Debug log
    } else {
      print('❌ AuthProvider: Logout gagal'); // Debug log
    }

    _isLoading = false;
    notifyListeners();

    return success;
  }

  // Update user data (setelah edit profile)
  void updateUser(User updatedUser) {
    _user = updatedUser;
    notifyListeners();
    print('✅ AuthProvider: User updated to ${updatedUser.username}');
  }

  Future<bool> updatePassword(String newPassword) async {
    return await _authService.updatePassword(newPassword);
  }
}
