// Stateless widget for featured movie section
import 'package:flutter/material.dart';
import 'package:movie_search_app/core/constants/app_dimensions.dart';
import 'package:movie_search_app/presentation/pages/movie_details/movie_details_page.dart';

class FeaturedSection extends StatelessWidget {
  final List<dynamic> movies;
  final bool isDarkMode;

  const FeaturedSection({
    super.key,
    required this.movies,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    // Only show featured section if we have movies
    if (movies.isEmpty) return const SizedBox.shrink();
    
    // Get the first movie from the list as featured
    final featuredMovie = movies.first;
    
    return Container(
      margin: EdgeInsets.all(AppDimensions.kPaddingM),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Movie poster as background
            featuredMovie.poster != "N/A"
                ? Image.network(
                    featuredMovie.poster,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                    child: Icon(
                      Icons.movie,
                      size: 80,
                      color: isDarkMode ? Colors.grey[700] : Colors.grey[400],
                    ),
                  ),
            
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            
            // Movie info
            Positioned(
              bottom: AppDimensions.kPaddingM,
              left: AppDimensions.kPaddingM,
              right: AppDimensions.kPaddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    featuredMovie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppDimensions.kPaddingXS),
                  Text(
                    featuredMovie.year,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            // Make the entire card clickable
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailsPage(
                        movieId: featuredMovie.imdbId,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}