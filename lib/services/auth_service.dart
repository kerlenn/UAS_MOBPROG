import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  // TODO: Ganti dengan URL API kamu nanti
  static const String baseUrl = 'https://your-api-url.com/api';
  
  // Simpan user data ke local storage
  Future<bool> saveUserLocally(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(user.toMap()));
      await prefs.setBool('is_logged_in', true);
      return true;
    } catch (e) {
      print('Error saving user: $e');
      return false;
    }
  }

  // Ambil user data dari local storage
  Future<User?> getUserLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null) {
        return User.fromMap(jsonDecode(userData));
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Check apakah user sudah login
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // Logout - hapus data user
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      await prefs.setBool('is_logged_in', false);
      return true;
    } catch (e) {
      print('Error logout: $e');
      return false;
    }
  }

  // LOGIN - nanti connect ke API
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // TODO: Uncomment ini ketika API sudah siap
      /*
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data['user']);
        await saveUserLocally(user);
        return {'success': true, 'user': user};
      } else {
        return {'success': false, 'message': 'Email atau password salah'};
      }
      */

      // DUMMY LOGIN (untuk testing sebelum API ready)
      await Future.delayed(const Duration(seconds: 1)); // simulasi loading
      
      // Simulasi login berhasil
      final dummyUser = User(
        id: '1',
        username: 'User Demo',
        email: email,
        phone: '081234567890',
        token: 'dummy_token_12345',
      );
      
      await saveUserLocally(dummyUser);
      return {'success': true, 'user': dummyUser};
      
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // REGISTER - nanti connect ke API
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      // TODO: Uncomment ini ketika API sudah siap
      /*
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data['user']);
        await saveUserLocally(user);
        return {'success': true, 'user': user};
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['message']};
      }
      */

      // DUMMY REGISTER (untuk testing sebelum API ready)
      await Future.delayed(const Duration(seconds: 1)); // simulasi loading
      
      final dummyUser = User(
        id: '2',
        username: username,
        email: email,
        phone: phone,
        token: 'dummy_token_67890',
      );
      
      await saveUserLocally(dummyUser);
      return {'success': true, 'user': dummyUser};
      
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}