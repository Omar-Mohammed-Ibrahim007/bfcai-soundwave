import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

/// Service for handling file uploads to Supabase Storage
class StorageService {
  static const String _bucketName = 'avatars';
  static const String _profileImageKey = 'user_image';

  /// Pick an image from gallery or camera
  static Future<XFile?> pickImage({bool fromCamera = false}) async {
    final picker = ImagePicker();
    return await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
  }

  /// Upload profile image to Supabase Storage
  static Future<String?> uploadProfileImage(XFile imageFile) async {
    try {
      final user = SupabaseConfig.currentUser;
      if (user == null) return null;

      // Read file bytes (works on web)
      final bytes = await imageFile.readAsBytes();
      final fileName =
          '${user.id}/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload to Supabase Storage
      await SupabaseConfig.client.storage
          .from(_bucketName)
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      // Get public URL
      final publicUrl = SupabaseConfig.client.storage
          .from(_bucketName)
          .getPublicUrl(fileName);

      // Save URL locally
      await saveProfileImageUrl(publicUrl);

      return publicUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  /// Save profile image URL to SharedPreferences
  static Future<void> saveProfileImageUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileImageKey, url);
  }

  /// Get profile image URL from SharedPreferences
  static Future<String?> getProfileImageUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileImageKey);
  }

  /// Delete profile image from storage
  static Future<bool> deleteProfileImage() async {
    try {
      final user = SupabaseConfig.currentUser;
      if (user == null) return false;

      // List files in user's folder
      final files = await SupabaseConfig.client.storage
          .from(_bucketName)
          .list(path: user.id);

      // Delete all files in user's folder
      if (files.isNotEmpty) {
        final paths = files.map((f) => '${user.id}/${f.name}').toList();
        await SupabaseConfig.client.storage.from(_bucketName).remove(paths);
      }

      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileImageKey);

      return true;
    } catch (e) {
      print('Error deleting profile image: $e');
      return false;
    }
  }
}
