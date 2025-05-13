
// Stateless widget for movie grid loading item
import 'package:flutter/material.dart';
import 'package:movie_search_app/core/constants/app_colors.dart';
import 'package:movie_search_app/presentation/pages/movie_details/movie_details_page.dart';

class MovieGridLoadingItem extends StatelessWidget {
  final bool isDarkMode;

  const MovieGridLoadingItem({
    super.key,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: isDarkMode ? Colors.grey[800]!.withOpacity(0.5) : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: isDarkMode ? Colors.white70 : AppColors.primaryColor,
        ),
      ),
    );
  }
}

// Stateless widget for movie grid item
class MovieGridItem extends StatelessWidget {
  final dynamic movie;
  final bool isDarkMode;

  const MovieGridItem({
    super.key,
    required this.movie,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsPage(
              movieId: movie.imdbId,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            title: Text(
              movie.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(movie.year),
          ),
          child: Container(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
            child: movie.poster != "N/A"
                ? Image.network(
                    movie.poster,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.movie,
                      size: 50,
                      color: isDarkMode ? Colors.grey[700] : Colors.grey[400],
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / 
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: isDarkMode ? Colors.white70 : AppColors.primaryColor,
                        ),
                      );
                    },
                  )
                : Icon(
                    Icons.movie,
                    size: 50,
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[400],
                  ),
          ),
        ),
      ),
    );
  }
}

// Stateless widget for category bottom sheet loading footer
class CategoryBottomSheetLoadingFooter extends StatelessWidget {
  final bool isDarkMode;

  const CategoryBottomSheetLoadingFooter({
    super.key,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: isDarkMode ? Colors.white70 : AppColors.primaryColor,
          ),
          const SizedBox(width: 16),
          Text(
            'Loading more movies...',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}