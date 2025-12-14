import 'ihandler.dart';
import '../models/songs.dart';
import '../models/artist.dart';
import '../repos/jamendo_repo.dart';

class JamendoHandler implements IHandler {
  final JamendoRepo _repo = JamendoRepo();

  @override
  Future<List<ModelSongs>> fetchSongs({int limit = 20, int offset = 0}) async {
    return await _repo.getTracks(limit: limit, offset: offset);
  }

  @override
  Future<List<Artist>> fetchArtists({int limit = 20, int offset = 0}) async {
    return await _repo.getArtists(limit: limit, offset: offset);
  }

  @override
  Future<List<ModelSongs>> searchSongs(String query) async {
    return await _repo.searchTracks(query);
  }

  @override
  Future<List<Artist>> searchArtists(String query) async {
    return await _repo.searchArtists(query);
  }
}
