import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/songs.dart';
import '../models/artist.dart';

class JamendoRepo {
  static const String _baseUrl = 'https://api.jamendo.com/v3.0';
  static String get _clientId => dotenv.env['JAMENDO_CLIENT_ID'] ?? '';
  static const String _format = 'json';

  // Build URL with common parameters
  String _buildUrl(String endpoint, Map<String, String> params) {
    final queryParams = {'client_id': _clientId, 'format': _format, ...params};
    final uri = Uri.parse(
      '$_baseUrl$endpoint',
    ).replace(queryParameters: queryParams);
    return uri.toString();
  }

  // Fetch tracks
  Future<List<ModelSongs>> getTracks({int limit = 20, int offset = 0}) async {
    try {
      final url = _buildUrl('/tracks/', {
        'limit': limit.toString(),
        'offset': offset.toString(),
        'include': 'musicinfo',
        'audioformat': 'mp32',
      });

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>;
        return results.map((track) => ModelSongs.fromJson(track)).toList();
      } else {
        throw Exception('Failed to load tracks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching tracks: $e');
    }
  }

  // Search tracks
  Future<List<ModelSongs>> searchTracks(String query) async {
    try {
      final url = _buildUrl('/tracks/', {
        'namesearch': query,
        'limit': '50',
        'audioformat': 'mp32',
      });

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>;
        return results.map((track) => ModelSongs.fromJson(track)).toList();
      } else {
        throw Exception('Failed to search tracks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching tracks: $e');
    }
  }

  // Get tracks by artist
  Future<List<ModelSongs>> getTracksByArtist(String artistId) async {
    try {
      final url = _buildUrl('/tracks/', {
        'artist_id': artistId,
        'limit': '50',
        'audioformat': 'mp32',
      });

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>;
        return results.map((track) => ModelSongs.fromJson(track)).toList();
      } else {
        throw Exception('Failed to load artist tracks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching artist tracks: $e');
    }
  }

  // Fetch artists
  Future<List<Artist>> getArtists({int limit = 20, int offset = 0}) async {
    try {
      final url = _buildUrl('/artists/', {
        'limit': limit.toString(),
        'offset': offset.toString(),
        'hasimage': 'true',
      });

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>;
        return results.map((artist) => Artist.fromJson(artist)).toList();
      } else {
        throw Exception('Failed to load artists: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching artists: $e');
    }
  }

  // Search artists
  Future<List<Artist>> searchArtists(String query) async {
    try {
      final url = _buildUrl('/artists/', {
        'namesearch': query,
        'limit': '50',
        'hasimage': 'true',
      });

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>;
        return results.map((artist) => Artist.fromJson(artist)).toList();
      } else {
        throw Exception('Failed to search artists: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching artists: $e');
    }
  }
}
