import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/artist.dart';

class ArtistsHelper {
  static const String _cachedArtistsKey = 'cached_artists';

  Future<void> cacheArtists(List<Artist> artists) async {
    final prefs = await SharedPreferences.getInstance();
    final artistsJson = artists.map((a) => a.toJson()).toList();
    await prefs.setString(_cachedArtistsKey, json.encode(artistsJson));
  }

  Future<List<Artist>> getCachedArtists() async {
    final prefs = await SharedPreferences.getInstance();
    final artistsString = prefs.getString(_cachedArtistsKey);
    if (artistsString == null) return [];

    final artistsJson = json.decode(artistsString) as List<dynamic>;
    return artistsJson.map((a) => Artist.fromJson(a)).toList();
  }

  Future<void> clearCachedArtists() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cachedArtistsKey);
  }
}
