import 'package:flutter/material.dart';
import '../models/songs.dart';
import '../models/artist.dart';
import '../services/favorites_service.dart';

class LikedController extends ChangeNotifier {
  final FavoritesService _favoritesService;

  LikedController(this._favoritesService);

  List<ModelSongs> get favoriteSongs => _favoritesService.favoriteSongs;
  List<Artist> get favoriteArtists => _favoritesService.favoriteArtists;

  bool isSongLiked(String songId) => _favoritesService.isSongFavorite(songId);
  bool isArtistLiked(String artistId) =>
      _favoritesService.isArtistFavorite(artistId);

  Future<void> toggleSongLike(ModelSongs song) async {
    await _favoritesService.toggleSongFavorite(song);
    notifyListeners();
  }

  Future<void> toggleArtistLike(Artist artist) async {
    await _favoritesService.toggleArtistFavorite(artist);
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    await _favoritesService.loadFavorites();
    notifyListeners();
  }
}
