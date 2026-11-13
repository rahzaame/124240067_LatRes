import 'package:bcrypt/bcrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/database_helper.dart';

class AuthService {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Register akun baru
  Future<bool> register({
    required String username,
    required String password,
  }) async {
    final cleanUsername = username.trim();

    if (cleanUsername.isEmpty || password.isEmpty) {
      throw Exception('Username dan password wajib diisi');
    }

    final existingUser = await _databaseHelper.getUserByUsername(cleanUsername);

    if (existingUser != null) {
      throw Exception('Username sudah digunakan');
    }

    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    await _databaseHelper.insertUser({
      'username': cleanUsername,
      'password': hashedPassword,
    });

    return true;
  }

  // Login menggunakan akun yang sudah terdaftar
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final cleanUsername = username.trim();

    if (cleanUsername.isEmpty || password.isEmpty) {
      throw Exception('Username dan password wajib diisi');
    }

    final user = await _databaseHelper.getUserByUsername(cleanUsername);

    if (user == null) {
      throw Exception('Username atau password salah');
    }

    final isPasswordCorrect = BCrypt.checkpw(password, user['password']);

    if (!isPasswordCorrect) {
      throw Exception('Username atau password salah');
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('user_id', user['id']);
    await prefs.setString('username', user['username']);
    await prefs.setBool('is_logged_in', true);

    return true;
  }

  // Memeriksa status login
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool('is_logged_in') ?? false;
  }

  // Mengambil username yang sedang login
  Future<String?> getLoggedInUsername() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('username');
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('user_id');
    await prefs.remove('username');
    await prefs.remove('is_logged_in');
  }
}
