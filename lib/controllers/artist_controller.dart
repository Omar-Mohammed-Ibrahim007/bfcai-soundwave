import 'package:flutter/material.dart';
import '../models/artist.dart';
import '../handlers/jamendo_handler.dart';
import '../storage/artists_helper.dart';

class ArtistController extends ChangeNotifier {
  final JamendoHandler _handler = JamendoHandler();
  final ArtistsHelper _artistsHelper = ArtistsHelper();

  List<Artist> _artists = [];
  List<Artist> _searchResults = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;
  int _offset = 0;
  final int _limit = 20;

  List<Artist> get artists => _artists;
  List<Artist> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;

  Future<void> loadArtists({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _offset = 0;
      _artists.clear();
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Try to load from cache first
      if (_artists.isEmpty) {
        final cachedArtists = await _artistsHelper.getCachedArtists();
        if (cachedArtists.isNotEmpty) {
          _artists = cachedArtists;
          notifyListeners();
        }
      }

      // Fetch from API
      final newArtists = await _handler.fetchArtists(
        limit: _limit,
        offset: _offset,
      );

      if (refresh) {
        _artists = newArtists;
      } else {
        _artists.addAll(newArtists);
      }

      _offset += _limit;

      // Cache artists
      await _artistsHelper.cacheArtists(_artists);
    } catch (e) {
      _errorMessage = 'Failed to load artists. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchArtists(String query) async {
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
      _searchResults = await _handler.searchArtists(query);
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

  Future<void> loadMoreArtists() async {
    if (!_isLoading && !_isSearching) {
      await loadArtists();
    }
  }
}
