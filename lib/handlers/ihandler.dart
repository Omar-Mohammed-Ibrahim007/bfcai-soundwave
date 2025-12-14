import '../models/songs.dart';
import '../models/artist.dart';

abstract class IHandler {
  Future<List<ModelSongs>> fetchSongs({int limit = 20, int offset = 0});
  Future<List<Artist>> fetchArtists({int limit = 20, int offset = 0});
  Future<List<ModelSongs>> searchSongs(String query);
  Future<List<Artist>> searchArtists(String query);
}
