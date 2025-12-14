import 'package:flutter/material.dart';
import '../models/songs.dart';
import '../handlers/jamendo_handler.dart';
import '../storage/songs_helper.dart';

class SongsController extends ChangeNotifier {
  final JamendoHandler _handler = JamendoHandler();
  final SongsHelper _songsHelper = SongsHelper();

  List<ModelSongs> _songs = [];
  List<ModelSongs> _searchResults = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;
  int _offset = 0;
  final int _limit = 20;

  List<ModelSongs> get songs => _songs;
  List<ModelSongs> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;

  Future<void> loadSongs({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _offset = 0;
      _songs.clear();
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Try to load from cache first
      if (_songs.isEmpty) {
        final cachedSongs = await _songsHelper.getCachedSongs();
        if (cachedSongs.isNotEmpty) {
          _songs = cachedSongs;
          notifyListeners();
        }
      }

      // Fetch from API
      final newSongs = await _handler.fetchSongs(
        limit: _limit,
        offset: _offset,
      );

      if (refresh) {
        _songs = newSongs;
      } else {
        _songs.addAll(newSongs);
      }

      _offset += _limit;

      // Cache songs
      await _songsHelper.cacheSongs(_songs);
    } catch (e) {
      _errorMessage = 'Failed to load songs. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchSongs(String query) async {
    if (query.isEmpty) {
      _searchResults.clear();
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _handler.searchSongs(query);
    } catch (e) {
      _errorMessage = 'Search failed. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults.clear();
    _isSearching = false;
    notifyListeners();
  }

  Future<void> loadMoreSongs() async {
    if (!_isLoading && !_isSearching) {
      await loadSongs();
    }
  }
}
