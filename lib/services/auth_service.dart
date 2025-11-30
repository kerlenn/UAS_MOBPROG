import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  Future<bool> saveUserLocally(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(user.toMap()));
      await prefs.setBool('is_logged_in', true);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User?> getUserLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null) {
        return User.fromMap(jsonDecode(userData));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', false);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      if (!email.contains('@') || !email.contains('.')) {
        return {
          'success': false,
          'message': 'Format email salah. Harus mengandung @ dan titik (.)'
        };
      }

      await Future.delayed(const Duration(seconds: 1));

      final prefs = await SharedPreferences.getInstance();
      final existingUser = await getUserLocally();
      final storedPassword = prefs.getString('registered_password');

      if (existingUser != null &&
          existingUser.email == email &&
          storedPassword == password) {
        await prefs.setBool('is_logged_in', true);
        return {'success': true, 'user': existingUser};
      } else {
        return {
          'success': false,
          'message': 'Email atau Kata Sandi salah, atau akun belum terdaftar.'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      if (!email.contains('@') || !email.contains('.')) {
        return {
          'success': false,
          'message': 'Format email salah. Harus mengandung @ dan titik (.)'
        };
      }

      await Future.delayed(const Duration(seconds: 1));

      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: username,
        email: email,
        phone: phone,
        token: 'dummy_token_${DateTime.now().millisecondsSinceEpoch}',
      );

      await saveUserLocally(newUser);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('registered_password', password);

      return {'success': true, 'user': newUser};
    } catch (e) {
      return {'success': false, 'message': 'Gagal mendaftar: $e'};
    }
  }
  Future<bool> updatePassword(String newPassword) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Timpa password lama dengan yang baru
      await prefs.setString('registered_password', newPassword);
      print('✅ Password berhasil diperbarui');
      return true;
    } catch (e) {
      print('❌ Gagal update password: $e');
      return false;
    }
  }
}