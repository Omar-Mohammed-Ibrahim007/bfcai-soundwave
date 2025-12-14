import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/songs.dart';

class SongsHelper {
  static const String _cachedSongsKey = 'cached_songs';

  Future<void> cacheSongs(List<ModelSongs> songs) async {
    final prefs = await SharedPreferences.getInstance();
    final songsJson = songs.map((s) => s.toJson()).toList();
    await prefs.setString(_cachedSongsKey, json.encode(songsJson));
  }

  Future<List<ModelSongs>> getCachedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final songsString = prefs.getString(_cachedSongsKey);
    if (songsString == null) return [];

    final songsJson = json.decode(songsString) as List<dynamic>;
    return songsJson.map((s) => ModelSongs.fromJson(s)).toList();
  }

  Future<void> clearCachedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cachedSongsKey);
  }
}
