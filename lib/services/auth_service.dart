import 'dart:convert';
// import 'package:http/http.dart' as http; // Comment dulu biar gak warning
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = 'https://your-api-url.com/api';

  // Simpan user data ke local storage
  Future<bool> saveUserLocally(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(user.toMap()));
      await prefs.setBool('is_logged_in', true);
      print('✅ User saved: ${user.username}'); // Debug
      return true;
    } catch (e) {
      print('❌ Error saving user: $e');
      return false;
    }
  }

  // Ambil user data dari local storage
  Future<User?> getUserLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null) {
        final user = User.fromMap(jsonDecode(userData));
        print('✅ User loaded: ${user.username}'); // Debug
        return user;
      }
      print('⚠️ No user data found');
      return null;
    } catch (e) {
      print('❌ Error loading user: $e');
      return null;
    }
  }

  // Check apakah user sudah login
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    print('🔍 isLoggedIn: $isLoggedIn');
    return isLoggedIn;
  }

  // Logout - hapus data user
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      await prefs.setBool('is_logged_in', false);
      print('✅ User logged out');
      return true;
    } catch (e) {
      print('❌ Logout error: $e');
      return false;
    }
  }

  // LOGIN DUMMY (FIXED)
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      // ← PERBAIKAN: Ambil username dari email (bagian sebelum @)
      String username = email.split(
        '@',
      )[0]; // Contoh: "yusuf@gmail.com" → "yusuf"
      username =
          username[0].toUpperCase() + username.substring(1); // Capitalize

      final dummyUser = User(
        id: '1',
        username: username, // ← Sekarang pakai username dari email
        email: email, // ← Email dari input
        phone: '081234567890', // ← Bisa di-custom nanti
        token: 'dummy_token_12345',
      );

      await saveUserLocally(dummyUser);
      print('✅ Login success: ${dummyUser.username}');

      return {'success': true, 'user': dummyUser};
    } catch (e) {
      print('❌ Login error: $e');
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // REGISTER DUMMY (Sudah OK, pakai input user)
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      final dummyUser = User(
        id: '2',
        username: username, // ← Ini sudah benar, pakai input user
        email: email,
        phone: phone,
        token: 'dummy_token_67890',
      );

      await saveUserLocally(dummyUser);
      print('✅ Register success: ${dummyUser.username}');

      return {'success': true, 'user': dummyUser};
    } catch (e) {
      print('❌ Register error: $e');
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}
