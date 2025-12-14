import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/music_controller.dart';
import '../themes/dark_theme.dart';
import '../helpers/conversions.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicController>(
      builder: (context, controller, child) {
        final song = controller.currentSong;
        if (song == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const FullPlayer(),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: surfaceDark,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress bar
                LinearProgressIndicator(
                  value: controller.duration.inSeconds > 0
                      ? controller.position.inSeconds /
                            controller.duration.inSeconds
                      : 0,
                  backgroundColor: cardDark,
                  valueColor: const AlwaysStoppedAnimation<Color>(primaryCyan),
                  minHeight: 2,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      // Album Art
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: song.albumImage.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: song.albumImage,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Container(
                                  width: 48,
                                  height: 48,
                                  color: cardDark,
                                  child: const Icon(Icons.music_note),
                                ),
                              )
                            : Container(
                                width: 48,
                                height: 48,
                                color: cardDark,
                                child: const Icon(Icons.music_note),
                              ),
                      ),
                      const SizedBox(width: 12),

                      // Song Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              song.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              song.artistName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Controls
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        color: textPrimary,
                        onPressed: controller.playPrevious,
                      ),
                      IconButton(
                        icon: Icon(
                          controller.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          size: 40,
                        ),
                        color: primaryCyan,
                        onPressed: controller.togglePlayPause,
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        color: textPrimary,
                        onPressed: controller.playNext,
                      ),
                    ],
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

class FullPlayer extends StatelessWidget {
  const FullPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicController>(
      builder: (context, controller, child) {
        final song = controller.currentSong;
        if (song == null) return const SizedBox.shrink();

        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: backgroundDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: textSecondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // Album Art
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: song.albumImage.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: song.albumImage,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              color: cardDark,
                              child: const Icon(
                                Icons.music_note,
                                size: 100,
                                color: textSecondary,
                              ),
                            ),
                          )
                        : Container(
                            color: cardDark,
                            child: const Icon(
                              Icons.music_note,
                              size: 100,
                              color: textSecondary,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Song Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      song.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      song.artistName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                      ),
                      child: Slider(
                        value: controller.position.inSeconds.toDouble(),
                        max: controller.duration.inSeconds.toDouble() > 0
                            ? controller.duration.inSeconds.toDouble()
                            : 1,
                        onChanged: (value) {
                          controller.seek(Duration(seconds: value.toInt()));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Conversions.formatDurationFromDuration(
                              controller.position,
                            ),
                            style: const TextStyle(
                              color: textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            Conversions.formatDurationFromDuration(
                              controller.duration,
                            ),
                            style: const TextStyle(
                              color: textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    iconSize: 40,
                    color: textPrimary,
                    onPressed: controller.playPrevious,
                  ),
                  const SizedBox(width: 24),
                  Container(
                    decoration: const BoxDecoration(
                      color: primaryCyan,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        controller.isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                      iconSize: 48,
                      color: Colors.black,
                      onPressed: controller.togglePlayPause,
                    ),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    iconSize: 40,
                    color: textPrimary,
                    onPressed: controller.playNext,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
