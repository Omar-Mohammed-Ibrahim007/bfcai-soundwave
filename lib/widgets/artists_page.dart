import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/artist_controller.dart';
import '../services/favorites_service.dart';
import '../models/artist.dart';
import '../themes/dark_theme.dart';

class ArtistsPage extends StatefulWidget {
  final bool showFavoritesOnly;

  const ArtistsPage({super.key, this.showFavoritesOnly = false});

  @override
  State<ArtistsPage> createState() => _ArtistsPageState();
}

class _ArtistsPageState extends State<ArtistsPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (!widget.showFavoritesOnly) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ArtistController>().loadArtists(refresh: true);
      });

      _scrollController.addListener(_onScroll);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ArtistController>().loadMoreArtists();
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
        title: Text(
          widget.showFavoritesOnly ? 'Favorite Artists' : 'All Artists',
        ),
      ),
      body: Column(
        children: [
          // Search Bar (only for all artists)
          if (!widget.showFavoritesOnly) _buildSearchBar(),

          // Artists Grid
          Expanded(
            child: widget.showFavoritesOnly
                ? _buildFavoriteArtistsGrid()
                : _buildAllArtistsGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search artists...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<ArtistController>().clearSearch();
                  },
                )
              : null,
        ),
        onChanged: (value) {
          context.read<ArtistController>().searchArtists(value);
        },
      ),
    );
  }

  Widget _buildAllArtistsGrid() {
    return Consumer<ArtistController>(
      builder: (context, controller, child) {
        final artists = controller.isSearching
            ? controller.searchResults
            : controller.artists;

        if (controller.isLoading && artists.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage != null && artists.isEmpty) {
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
                  onPressed: () => controller.loadArtists(refresh: true),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (artists.isEmpty) {
          return const Center(
            child: Text(
              'No artists found',
              style: TextStyle(color: textSecondary),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadArtists(refresh: true),
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: artists.length + (controller.isLoading ? 2 : 0),
            itemBuilder: (context, index) {
              if (index >= artists.length) {
                return const Center(child: CircularProgressIndicator());
              }
              return _buildArtistCard(artists[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildFavoriteArtistsGrid() {
    return Consumer<FavoritesService>(
      builder: (context, favService, child) {
        final artists = favService.favoriteArtists;

        if (artists.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: textSecondary),
                SizedBox(height: 16),
                Text(
                  'No favorite artists yet',
                  style: TextStyle(color: textSecondary, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Tap the heart icon on any artist to add them here',
                  style: TextStyle(color: textSecondary),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: artists.length,
          itemBuilder: (context, index) {
            return _buildArtistCard(artists[index]);
          },
        );
      },
    );
  }

  Widget _buildArtistCard(Artist artist) {
    return Consumer<FavoritesService>(
      builder: (context, favService, child) {
        final isFavorite = favService.isArtistFavorite(artist.id);

        return GestureDetector(
          onTap: () {
            // Could navigate to artist details page
          },
          child: Container(
            decoration: BoxDecoration(
              color: cardDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Artist Image
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: artist.image.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: artist.image,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: surfaceDark,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: surfaceDark,
                                  child: const Icon(
                                    Icons.person,
                                    size: 48,
                                    color: textSecondary,
                                  ),
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                color: surfaceDark,
                                child: const Icon(
                                  Icons.person,
                                  size: 48,
                                  color: textSecondary,
                                ),
                              ),
                      ),
                      // Favorite Button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            favService.toggleArtistFavorite(artist);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Artist Name
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    artist.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
