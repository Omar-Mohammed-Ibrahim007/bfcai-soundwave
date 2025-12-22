import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/favorites_service.dart';
import '../controllers/music_controller.dart';
import '../themes/dark_theme.dart';
import 'songs_page.dart';
import 'artists_page.dart';
import 'settings_page.dart';
import 'songs_list_item.dart';
import 'favourite_artists.dart';
import 'newcontrols.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesService>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.music_note_rounded, color: primaryCyan),
            const SizedBox(width: 8),
            const Text('Jamendo'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<MusicController>(
        builder: (context, musicController, child) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGridBoxes(context),
                      const SizedBox(height: 24),

                      _buildFavoriteSongsSection(context),
                      const SizedBox(height: 24),

                      _buildFavoriteArtistsSection(context),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),

              // Bottom Player
              if (musicController.currentSong != null) const MiniPlayer(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGridBoxes(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildGridBox(
          context,
          icon: Icons.favorite_rounded,
          title: 'Favorite\nSongs',
          color: Colors.red,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SongsPage(showFavoritesOnly: true),
            ),
          ),
        ),
        _buildGridBox(
          context,
          icon: Icons.mic_rounded,
          title: 'Favorite\nArtists',
          color: secondaryPurple,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ArtistsPage(showFavoritesOnly: true),
            ),
          ),
        ),
        _buildGridBox(
          context,
          icon: Icons.library_music_rounded,
          title: 'All\nSongs',
          color: primaryCyan,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SongsPage()),
          ),
        ),
        _buildGridBox(
          context,
          icon: Icons.people_rounded,
          title: 'All\nArtists',
          color: Colors.orange,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ArtistsPage()),
          ),
        ),
      ],
    );
  }

  Widget _buildGridBox(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteSongsSection(BuildContext context) {
    return Consumer<FavoritesService>(
      builder: (context, favService, child) {
        final favoriteSongs = favService.favoriteSongs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '❤️ Favorite Songs',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                if (favoriteSongs.isNotEmpty)
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SongsPage(showFavoritesOnly: true),
                      ),
                    ),
                    child: const Text('See All'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (favoriteSongs.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No favorite songs yet.\nTap the heart icon on any song to add it here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textSecondary),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: favoriteSongs.length > 3 ? 3 : favoriteSongs.length,
                itemBuilder: (context, index) {
                  return SongsListItem(
                    song: favoriteSongs[index],
                    songs: favoriteSongs,
                    index: index,
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildFavoriteArtistsSection(BuildContext context) {
    return Consumer<FavoritesService>(
      builder: (context, favService, child) {
        final favoriteArtists = favService.favoriteArtists;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '🎤 Favorite Artists',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                if (favoriteArtists.isNotEmpty)
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ArtistsPage(showFavoritesOnly: true),
                      ),
                    ),
                    child: const Text('See All'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (favoriteArtists.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No favorite artists yet.\nTap the heart icon on any artist to add them here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textSecondary),
                  ),
                ),
              )
            else
              FavoriteArtistsList(
                artists: favoriteArtists.length > 5
                    ? favoriteArtists.sublist(0, 5)
                    : favoriteArtists,
              ),
          ],
        );
      },
    );
  }
}
