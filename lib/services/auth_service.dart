import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

class AuthService extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => SupabaseConfig.isLoggedIn;
  String? get errorMessage => _errorMessage;
  String get userName => SupabaseConfig.userName;
  String get userEmail => SupabaseConfig.userEmail;

  // Email validation
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Password validation (minimum 6 characters)
  bool isValidPassword(String password) {
    return password.length >= 6;
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Validate email
    if (!isValidEmail(email)) {
      _errorMessage = 'Please enter a valid email address';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Validate password
    if (!isValidPassword(password)) {
      _errorMessage = 'Password must be at least 6 characters';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      await SupabaseConfig.signIn(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _parseAuthError(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String? name) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Validate email
    if (!isValidEmail(email)) {
      _errorMessage = 'Please enter a valid email address';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Validate password
    if (!isValidPassword(password)) {
      _errorMessage = 'Password must be at least 6 characters';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      await SupabaseConfig.signUp(email: email, password: password, name: name);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _parseAuthError(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await SupabaseConfig.signOut();
    notifyListeners();
  }

  String _parseAuthError(String error) {
    if (error.contains('Invalid login credentials')) {
      return 'Invalid email or password';
    } else if (error.contains('Email not confirmed')) {
      return 'Please confirm your email address';
    } else if (error.contains('User already registered')) {
      return 'Email already registered';
    } else if (error.contains('Password should be')) {
      return 'Password must be at least 6 characters';
    }
    return 'An error occurred. Please try again.';
  }

  Future<void> updateName(String name) async {
    try {
      await SupabaseConfig.client.auth.updateUser(
        UserAttributes(data: {'name': name}),
      );
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update name';
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
