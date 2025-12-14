import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/songs_controller.dart';
import '../controllers/music_controller.dart';
import '../services/favorites_service.dart';
import '../themes/dark_theme.dart';
import 'songs_list_item.dart';
import 'newcontrols.dart';

class SongsPage extends StatefulWidget {
  final bool showFavoritesOnly;

  const SongsPage({super.key, this.showFavoritesOnly = false});

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (!widget.showFavoritesOnly) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<SongsController>().loadSongs(refresh: true);
      });

      _scrollController.addListener(_onScroll);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SongsController>().loadMoreSongs();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.showFavoritesOnly ? 'Favorite Songs' : 'All Songs'),
      ),
      body: Consumer<MusicController>(
        builder: (context, musicController, child) {
          return Column(
            children: [
              // Search Bar (only for all songs)
              if (!widget.showFavoritesOnly) _buildSearchBar(),

              // Songs List
              Expanded(
                child: widget.showFavoritesOnly
                    ? _buildFavoriteSongsList()
                    : _buildAllSongsList(),
              ),

              // Bottom Player
              if (musicController.currentSong != null) const MiniPlayer(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search songs...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<SongsController>().clearSearch();
                  },
                )
              : null,
        ),
        onChanged: (value) {
          context.read<SongsController>().searchSongs(value);
        },
      ),
    );
  }

  Widget _buildAllSongsList() {
    return Consumer<SongsController>(
      builder: (context, controller, child) {
        final songs = controller.isSearching
            ? controller.searchResults
            : controller.songs;

        if (controller.isLoading && songs.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage != null && songs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: textSecondary),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.loadSongs(refresh: true),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (songs.isEmpty) {
          return const Center(
            child: Text(
              'No songs found',
              style: TextStyle(color: textSecondary),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadSongs(refresh: true),
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: songs.length + (controller.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == songs.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return SongsListItem(
                song: songs[index],
                songs: songs,
                index: index,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFavoriteSongsList() {
    return Consumer<FavoritesService>(
      builder: (context, favService, child) {
        final songs = favService.favoriteSongs;

        if (songs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 64, color: textSecondary),
                SizedBox(height: 16),
                Text(
                  'No favorite songs yet',
                  style: TextStyle(color: textSecondary, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Tap the heart icon on any song to add it here',
                  style: TextStyle(color: textSecondary),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: songs.length,
          itemBuilder: (context, index) {
            return SongsListItem(
              song: songs[index],
              songs: songs,
              index: index,
            );
          },
        );
      },
    );
  }
}
