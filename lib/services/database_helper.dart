import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static const String _usersKey = 'users_db';
  static bool _initialized = false;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<void> initialize() async {
    if (_initialized) return;

    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    // Create default user if no users exist
    if (usersJson == null) {
      final hashedPassword = _hashPassword('123456');
      final defaultUser = {
        'id': 1,
        'email': 'omar@x.com',
        'password': hashedPassword,
        'name': 'Omar',
        'created_at': DateTime.now().toIso8601String(),
      };
      await prefs.setString(_usersKey, json.encode([defaultUser]));
    }

    _initialized = true;
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<List<Map<String, dynamic>>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return [];

    final List<dynamic> usersList = json.decode(usersJson);
    return usersList.map((u) => Map<String, dynamic>.from(u)).toList();
  }

  Future<void> _saveUsers(List<Map<String, dynamic>> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, json.encode(users));
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    await initialize();
    final hashedPassword = _hashPassword(password);
    final users = await _getUsers();

    for (var user in users) {
      if (user['email'] == email && user['password'] == hashedPassword) {
        return user;
      }
    }
    return null;
  }

  Future<bool> register(String email, String password, String? name) async {
    await initialize();
    final hashedPassword = _hashPassword(password);
    final users = await _getUsers();

    // Check if email exists
    for (var user in users) {
      if (user['email'] == email) {
        return false;
      }
    }

    // Add new user
    final newUser = {
      'id': users.length + 1,
      'email': email,
      'password': hashedPassword,
      'name': name ?? email.split('@').first,
      'created_at': DateTime.now().toIso8601String(),
    };

    users.add(newUser);
    await _saveUsers(users);
    return true;
  }

  Future<bool> emailExists(String email) async {
    await initialize();
    final users = await _getUsers();

    for (var user in users) {
      if (user['email'] == email) {
        return true;
      }
    }
    return false;
  }

  Future<void> updateUserName(String email, String name) async {
    await initialize();
    final users = await _getUsers();

    for (var user in users) {
      if (user['email'] == email) {
        user['name'] = name;
        break;
      }
    }

    await _saveUsers(users);
  }
}
