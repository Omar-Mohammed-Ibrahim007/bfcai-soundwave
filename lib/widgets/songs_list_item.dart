import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/songs.dart';
import '../controllers/music_controller.dart';
import '../services/favorites_service.dart';
import '../themes/dark_theme.dart';

class SongsListItem extends StatelessWidget {
  final ModelSongs song;
  final List<ModelSongs> songs;
  final int index;

  const SongsListItem({
    super.key,
    required this.song,
    required this.songs,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<MusicController, FavoritesService>(
      builder: (context, musicController, favService, child) {
        final isPlaying = musicController.currentSong?.id == song.id;
        final isFavorite = favService.isSongFavorite(song.id);

        return ListTile(
          onTap: () {
            musicController.playSong(song, songs: songs, index: index);
          },
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: song.albumImage.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: song.albumImage,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 56,
                          height: 56,
                          color: cardDark,
                          child: const Icon(
                            Icons.music_note,
                            color: textSecondary,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 56,
                          height: 56,
                          color: cardDark,
                          child: const Icon(
                            Icons.music_note,
                            color: textSecondary,
                          ),
                        ),
                      )
                    : Container(
                        width: 56,
                        height: 56,
                        color: cardDark,
                        child: const Icon(
                          Icons.music_note,
                          color: textSecondary,
                        ),
                      ),
              ),
              if (isPlaying)
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.equalizer, color: primaryCyan),
                ),
            ],
          ),
          title: Text(
            song.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isPlaying ? primaryCyan : textPrimary,
              fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(
            song.artistName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: textSecondary),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                song.formattedDuration,
                style: const TextStyle(color: textSecondary, fontSize: 12),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : textSecondary,
                ),
                onPressed: () {
                  favService.toggleSongFavorite(song);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
