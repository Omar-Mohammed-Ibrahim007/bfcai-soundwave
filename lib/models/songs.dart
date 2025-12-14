class ModelSongs {
  final String id;
  final String name;
  final String artistName;
  final String artistId;
  final String albumName;
  final String albumId;
  final String albumImage;
  final String audioUrl;
  final int duration;
  final String releaseDate;
  bool isFavorite;

  ModelSongs({
    required this.id,
    required this.name,
    required this.artistName,
    required this.artistId,
    required this.albumName,
    required this.albumId,
    required this.albumImage,
    required this.audioUrl,
    required this.duration,
    required this.releaseDate,
    this.isFavorite = false,
  });

  factory ModelSongs.fromJson(Map<String, dynamic> json) {
    return ModelSongs(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      artistName: json['artist_name'] ?? '',
      artistId: json['artist_id']?.toString() ?? '',
      albumName: json['album_name'] ?? '',
      albumId: json['album_id']?.toString() ?? '',
      albumImage: json['album_image'] ?? json['image'] ?? '',
      audioUrl: json['audio'] ?? '',
      duration: json['duration'] ?? 0,
      releaseDate: json['releasedate'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'artist_name': artistName,
      'artist_id': artistId,
      'album_name': albumName,
      'album_id': albumId,
      'album_image': albumImage,
      'audio': audioUrl,
      'duration': duration,
      'releasedate': releaseDate,
      'isFavorite': isFavorite,
    };
  }

  ModelSongs copyWith({
    String? id,
    String? name,
    String? artistName,
    String? artistId,
    String? albumName,
    String? albumId,
    String? albumImage,
    String? audioUrl,
    int? duration,
    String? releaseDate,
    bool? isFavorite,
  }) {
    return ModelSongs(
      id: id ?? this.id,
      name: name ?? this.name,
      artistName: artistName ?? this.artistName,
      artistId: artistId ?? this.artistId,
      albumName: albumName ?? this.albumName,
      albumId: albumId ?? this.albumId,
      albumImage: albumImage ?? this.albumImage,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
      releaseDate: releaseDate ?? this.releaseDate,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
