import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

class SongScreen extends StatefulWidget {
  final Map<String, dynamic> songData;

  const SongScreen({super.key, required this.songData});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen>
    with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late AnimationController _animationController;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isLiked = false;
  bool _isShuffleMode = false;
  bool _isRepeatMode = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _animationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _setupAudioPlayer();
    _loadSong();
  }

  void _setupAudioPlayer() {
    // Listen to player state changes
    _audioPlayer.playerStateStream.listen((playerState) {
      if (mounted) {
        setState(() {
          _isPlaying = playerState.playing;
          _isLoading =
              playerState.processingState == ProcessingState.loading ||
              playerState.processingState == ProcessingState.buffering;
        });

        if (_isPlaying) {
          _animationController.repeat();
        } else {
          _animationController.stop();
        }
      }
    });

    // Listen to duration changes
    _audioPlayer.durationStream.listen((duration) {
      if (mounted && duration != null) {
        setState(() {
          _duration = duration;
        });
      }
    });

    // Listen to position changes
    _audioPlayer.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });
  }

  Future<void> _loadSong() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Print the song data for debugging
      print('Song data: ${widget.songData}');

      // Try to extract song URL from multiple possible fields
      String? songUrl = _extractSongUrl();

      print('Extracted song URL: $songUrl');

      if (songUrl == null || songUrl.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'No audio URL found in song data. Available fields: ${widget.songData.keys.join(", ")}';
        });
        return;
      }

      await _audioPlayer.setUrl(songUrl);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load song: ${e.toString()}';
      });
    }
  }

  String? _extractSongUrl() {
    // Check various possible URL field names
    final possibleUrlFields = [
      'link', // This is what the backend API returns
      'preview_url',
      'url',
      'stream_url',
      'audio_url',
      'download_url',
      'play_url',
      'listen_url',
      'file_url',
      'mp3_url',
      'audio',
      'href',
      'src',
      'external_urls',
      'track_url',
      'song_url',
    ];

    // First try direct fields
    for (String field in possibleUrlFields) {
      final value = widget.songData[field];
      if (value != null && value.toString().isNotEmpty) {
        // Handle nested objects
        if (value is Map) {
          // Try common nested URL patterns
          final nestedUrl =
              value['preview'] ??
              value['url'] ??
              value['mp3'] ??
              value['stream'];
          if (nestedUrl != null && nestedUrl.toString().isNotEmpty) {
            return nestedUrl.toString();
          }
        } else if (value is String && value.isNotEmpty) {
          return value;
        }
      }
    }

    // Try to find any field that looks like a URL
    for (final entry in widget.songData.entries) {
      final value = entry.value?.toString() ?? '';
      if (value.startsWith('http') &&
          (value.contains('.mp3') ||
              value.contains('.wav') ||
              value.contains('.m4a') ||
              value.contains('.ogg') ||
              value.contains('audio') ||
              value.contains('stream'))) {
        return value;
      }
    }

    // If still no URL found, return null to show error instead of demo URL
    return null;
  }

  Future<void> _togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  Future<void> _seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title =
        widget.songData['title'] ??
        widget.songData['name'] ??
        widget.songData['song'] ??
        'Unknown Title';
    final artist =
        widget.songData['artist'] ??
        widget.songData['performer'] ??
        widget.songData['singer'] ??
        'Unknown Artist';
    final album = widget.songData['album'] ?? '';

    // Show error if there's an error message
    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F0F23),
        body: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 64,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Error Loading Song',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _errorMessage,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _loadSong,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A1A2E),
              const Color(0xFF0F0F23),
              const Color(0xFF000000),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Album Art Section
              Expanded(flex: 3, child: _buildAlbumArtSection(title)),

              // Song Info
              _buildSongInfo(title, artist, album),

              // Progress Bar
              _buildProgressBar(),

              // Controls
              _buildControls(),

              // Bottom Actions
              _buildBottomActions(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          const Text(
            'PLAYING FROM PLAYLIST',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white, size: 24),
            onPressed: () {
              // Show more options
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumArtSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Lofi Lofi',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 30),

          // Rotating Album Art
          RotationTransition(
            turns: _animationController,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF6366F1),
                        const Color(0xFF8B5CF6),
                        const Color(0xFFEC4899),
                        const Color(0xFFF59E0B),
                      ],
                    ),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.music_note,
                            size: 80,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongInfo(String title, String artist, String album) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            artist,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          if (album.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              album,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF1DB954),
              inactiveTrackColor: Colors.white.withOpacity(0.3),
              thumbColor: const Color(0xFF1DB954),
              overlayColor: const Color(0xFF1DB954).withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              trackHeight: 4,
            ),
            child: Slider(
              value: _duration.inMilliseconds > 0
                  ? _position.inMilliseconds.toDouble()
                  : 0.0,
              max: _duration.inMilliseconds.toDouble(),
              onChanged: (value) {
                _seekTo(Duration(milliseconds: value.toInt()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_position),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                Text(
                  _formatDuration(_duration),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Shuffle
          IconButton(
            icon: Icon(
              Icons.shuffle,
              color: _isShuffleMode
                  ? const Color(0xFF1DB954)
                  : Colors.white.withOpacity(0.7),
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _isShuffleMode = !_isShuffleMode;
              });
            },
          ),

          // Previous
          IconButton(
            icon: Icon(
              Icons.skip_previous,
              color: Colors.white.withOpacity(0.9),
              size: 36,
            ),
            onPressed: () {
              // Handle previous song
            },
          ),

          // Play/Pause
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF1DB954),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1DB954).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                _isLoading
                    ? Icons.hourglass_empty
                    : _isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
                size: 36,
              ),
              onPressed: _isLoading ? null : _togglePlayPause,
            ),
          ),

          // Next
          IconButton(
            icon: Icon(
              Icons.skip_next,
              color: Colors.white.withOpacity(0.9),
              size: 36,
            ),
            onPressed: () {
              // Handle next song
            },
          ),

          // Repeat
          IconButton(
            icon: Icon(
              Icons.repeat,
              color: _isRepeatMode
                  ? const Color(0xFF1DB954)
                  : Colors.white.withOpacity(0.7),
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _isRepeatMode = !_isRepeatMode;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              color: _isLiked ? Colors.red : Colors.white.withOpacity(0.7),
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _isLiked = !_isLiked;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white.withOpacity(0.7),
              size: 24,
            ),
            onPressed: () {
              // Handle share
            },
          ),
          IconButton(
            icon: Icon(
              Icons.download_for_offline,
              color: Colors.white.withOpacity(0.7),
              size: 24,
            ),
            onPressed: () {
              // Handle download
            },
          ),
        ],
      ),
    );
  }
}
