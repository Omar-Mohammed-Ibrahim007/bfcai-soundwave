import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/database_helper.dart';
import 'services/favorites_service.dart';
import 'services/supabase_config.dart';

class Startup {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Load environment variables
    await dotenv.load(fileName: '.env');

    // Initialize Supabase for authentication
    await SupabaseConfig.initialize();

    // Initialize local database (fallback for offline)
    await DatabaseHelper().initialize();

    // Load favorites from SharedPreferences
    await FavoritesService().loadFavorites();
  }
}
