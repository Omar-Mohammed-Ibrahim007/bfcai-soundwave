import '../models/songs.dart';
import '../models/artist.dart';

class Mappers {
  static ModelSongs mapToSong(Map<String, dynamic> json) {
    return ModelSongs.fromJson(json);
  }

  static Artist mapToArtist(Map<String, dynamic> json) {
    return Artist.fromJson(json);
  }

  static List<ModelSongs> mapToSongs(List<dynamic> jsonList) {
    return jsonList.map((json) => mapToSong(json)).toList();
  }

  static List<Artist> mapToArtists(List<dynamic> jsonList) {
    return jsonList.map((json) => mapToArtist(json)).toList();
  }
}
