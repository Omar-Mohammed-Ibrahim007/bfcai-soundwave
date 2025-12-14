import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/songs.dart';
import '../models/artist.dart';

class FavoritesService extends ChangeNotifier {
  static const String _favoriteSongsKey = 'favorite_songs';
  static const String _favoriteArtistsKey = 'favorite_artists';

  List<ModelSongs> _favoriteSongs = [];
  List<Artist> _favoriteArtists = [];

  List<ModelSongs> get favoriteSongs => _favoriteSongs;
  List<Artist> get favoriteArtists => _favoriteArtists;

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    // Load favorite songs
    final songsString = prefs.getString(_favoriteSongsKey);
    if (songsString != null) {
      final songsJson = json.decode(songsString) as List<dynamic>;
      _favoriteSongs = songsJson.map((s) => ModelSongs.fromJson(s)).toList();
    }

    // Load favorite artists
    final artistsString = prefs.getString(_favoriteArtistsKey);
    if (artistsString != null) {
      final artistsJson = json.decode(artistsString) as List<dynamic>;
      _favoriteArtists = artistsJson.map((a) => Artist.fromJson(a)).toList();
    }

    notifyListeners();
  }

  Future<void> _saveFavoriteSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final songsJson = _favoriteSongs.map((s) => s.toJson()).toList();
    await prefs.setString(_favoriteSongsKey, json.encode(songsJson));
  }

  Future<void> _saveFavoriteArtists() async {
    final prefs = await SharedPreferences.getInstance();
    final artistsJson = _favoriteArtists.map((a) => a.toJson()).toList();
    await prefs.setString(_favoriteArtistsKey, json.encode(artistsJson));
  }

  bool isSongFavorite(String songId) {
    return _favoriteSongs.any((s) => s.id == songId);
  }

  bool isArtistFavorite(String artistId) {
    return _favoriteArtists.any((a) => a.id == artistId);
  }

  Future<void> toggleSongFavorite(ModelSongs song) async {
    if (isSongFavorite(song.id)) {
      _favoriteSongs.removeWhere((s) => s.id == song.id);
    } else {
      _favoriteSongs.add(song.copyWith(isFavorite: true));
    }
    await _saveFavoriteSongs();
    notifyListeners();
  }

  Future<void> toggleArtistFavorite(Artist artist) async {
    if (isArtistFavorite(artist.id)) {
      _favoriteArtists.removeWhere((a) => a.id == artist.id);
    } else {
      _favoriteArtists.add(artist.copyWith(isFavorite: true));
    }
    await _saveFavoriteArtists();
    notifyListeners();
  }

  Future<void> addSongToFavorites(ModelSongs song) async {
    if (!isSongFavorite(song.id)) {
      _favoriteSongs.add(song.copyWith(isFavorite: true));
      await _saveFavoriteSongs();
      notifyListeners();
    }
  }

  Future<void> removeSongFromFavorites(String songId) async {
    _favoriteSongs.removeWhere((s) => s.id == songId);
    await _saveFavoriteSongs();
    notifyListeners();
  }

  Future<void> addArtistToFavorites(Artist artist) async {
    if (!isArtistFavorite(artist.id)) {
      _favoriteArtists.add(artist.copyWith(isFavorite: true));
      await _saveFavoriteArtists();
      notifyListeners();
    }
  }

  Future<void> removeArtistFromFavorites(String artistId) async {
    _favoriteArtists.removeWhere((a) => a.id == artistId);
    await _saveFavoriteArtists();
    notifyListeners();
  }

  Future<void> clearAllFavorites() async {
    _favoriteSongs.clear();
    _favoriteArtists.clear();
    await _saveFavoriteSongs();
    await _saveFavoriteArtists();
    notifyListeners();
  }
}
