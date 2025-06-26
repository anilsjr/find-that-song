import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2B2E),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button and search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Browse Library',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.search,
                          color: Colors.white.withOpacity(0.7),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Recently played section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: Colors.white.withOpacity(0.7),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Recently played',
                    style: TextStyle(
                      color: Color(0xFF00D4AA),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Recently played list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildRecentlyPlayedItem(
                    'Conan Gray',
                    '',
                    'assets/conan_gray.jpg',
                    isArtist: true,
                  ),
                  _buildRecentlyPlayedItem(
                    'DAWN FM',
                    'The Weeknd',
                    'assets/dawn_fm.jpg',
                  ),
                  _buildRecentlyPlayedItem(
                    'Water Fountain',
                    'alec benjamin',
                    'assets/water_fountain.jpg',
                  ),
                  _buildRecentlyPlayedItem(
                    'Wiped Out!',
                    'The Neighbourhood',
                    'assets/wiped_out.jpg',
                  ),
                  _buildRecentlyPlayedItem(
                    'Baking a Mystery',
                    'Updated Aug 21 • Stephanie Soo',
                    'assets/baking_mystery.jpg',
                    isPodcast: true,
                  ),
                  _buildRecentlyPlayedItem(
                    'keshi',
                    '',
                    'assets/keshi.jpg',
                    isArtist: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentlyPlayedItem(
    String title,
    String subtitle,
    String imagePath, {
    bool isArtist = false,
    bool isPodcast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          // Album/Artist Image
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isArtist ? 28 : 8),
              color: Colors.grey[800],
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  // Handle image loading error
                },
              ),
            ),
            child: imagePath.startsWith('assets/') 
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(isArtist ? 28 : 8),
                      color: _getPlaceholderColor(title),
                    ),
                    child: Center(
                      child: Text(
                        title.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getPlaceholderColor(String title) {
    // Generate a color based on the title's hash code
    final colors = [
      const Color(0xFF2196F3),
      const Color(0xFF9C27B0),
      const Color(0xFFE91E63),
      const Color(0xFF00BCD4),
      const Color(0xFF4CAF50),
      const Color(0xFFFF9800),
      const Color(0xFF795548),
      const Color(0xFF607D8B),
    ];
    return colors[title.hashCode % colors.length];
  }
}
