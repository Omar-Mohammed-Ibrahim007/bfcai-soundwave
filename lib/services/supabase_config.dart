import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  // ============ AUTH METHODS ============

  /// Sign up a new user
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );
    return response;
  }

  /// Sign in an existing user
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  /// Sign out the current user
  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  /// Get current user
  static User? get currentUser => client.auth.currentUser;

  /// Check if user is logged in
  static bool get isLoggedIn => currentUser != null;

  /// Get user's display name
  static String get userName =>
      currentUser?.userMetadata?['name'] ??
      currentUser?.email?.split('@').first ??
      'User';

  /// Get user's email
  static String get userEmail => currentUser?.email ?? '';

  /// Listen to auth state changes
  static Stream<AuthState> get authStateChanges =>
      client.auth.onAuthStateChange;
}

/*
============ SUPABASE SETUP ============

1. Go to https://supabase.com and create a new project

2. Go to Project Settings > API and copy:
   - Project URL → supabaseUrl
   - anon public key → supabaseAnonKey

3. Authentication is handled by Supabase Auth automatically
   No additional tables needed for basic auth!

4. (Optional) Disable email confirmation for testing:
   Authentication > Providers > Email > Confirm email = OFF

5. Add the dependency to pubspec.yaml:
   supabase_flutter: ^2.3.0

6. Update main.dart:
   
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await SupabaseConfig.initialize();
     runApp(const JELMusicApp());
   }

Note: Favorites are stored locally using SharedPreferences
      (see favorites_service.dart)
*/
