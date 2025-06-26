import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2B2E),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with TikTok icon and Search text
              Row(
                children: [
                  Icon(
                    Icons.music_note,
                    color: const Color(0xFF00D4AA),
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Search',
                    style: TextStyle(
                      color: Color(0xFF00D4AA),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Songs, Artists, Podcasts & More',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Your Top Genres section
              const Text(
                'Your Top Genres',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Top Genres Grid
              Row(
                children: [
                  Expanded(
                    child: _buildGenreCard(
                      'Kpop',
                      Colors.green,
                      'assets/kpop_bg.jpg',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildGenreCard(
                      'Indie',
                      const Color(0xFFE91E63),
                      'assets/indie_bg.jpg',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildGenreCard(
                      'R&B',
                      const Color(0xFF3F51B5),
                      'assets/rnb_bg.jpg',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildGenreCard(
                      'Pop',
                      const Color(0xFFFF9800),
                      'assets/pop_bg.jpg',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Browse All section
              const Text(
                'Browse All',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Browse All Grid
              Row(
                children: [
                  Expanded(
                    child: _buildBrowseCard(
                      'Made for You',
                      const Color(0xFF2196F3),
                      'assets/made_for_you_bg.jpg',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildBrowseCard(
                      'RELEASED',
                      const Color(0xFF9C27B0),
                      'assets/released_bg.jpg',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildBrowseCard(
                      'Music Charts',
                      const Color(0xFF3F51B5),
                      'assets/music_charts_bg.jpg',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildBrowseCard(
                      'Podcasts',
                      const Color(0xFFD32F2F),
                      'assets/podcasts_bg.jpg',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildBrowseCard(
                      'Bollywood',
                      const Color(0xFF795548),
                      'assets/bollywood_bg.jpg',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildBrowseCard(
                      'Pop Fusion',
                      const Color(0xFF607D8B),
                      'assets/pop_fusion_bg.jpg',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100), // Extra space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenreCard(String title, Color color, String imagePath) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            color.withOpacity(0.7),
            BlendMode.overlay,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrowseCard(String title, Color color, String imagePath) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            color.withOpacity(0.7),
            BlendMode.overlay,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
