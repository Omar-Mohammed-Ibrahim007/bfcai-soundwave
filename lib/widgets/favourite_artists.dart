import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/artist.dart';
import '../themes/dark_theme.dart';

class FavoriteArtistsList extends StatelessWidget {
  final List<Artist> artists;

  const FavoriteArtistsList({super.key, required this.artists});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 12,
              right: index == artists.length - 1 ? 0 : 0,
            ),
            child: _buildArtistItem(artist),
          );
        },
      ),
    );
  }

  Widget _buildArtistItem(Artist artist) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: cardDark,
          backgroundImage: artist.image.isNotEmpty
              ? CachedNetworkImageProvider(artist.image)
              : null,
          child: artist.image.isEmpty
              ? const Icon(Icons.person, size: 35, color: textSecondary)
              : null,
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 70,
          child: Text(
            artist.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(color: textPrimary, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
