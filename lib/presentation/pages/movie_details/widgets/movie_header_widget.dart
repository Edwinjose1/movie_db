// lib/presentation/widgets/movie_details/movie_header_widget.dart
import 'package:flutter/material.dart';
import 'package:movie_search_app/core/constants/app_colors.dart';
import 'package:movie_search_app/core/constants/app_dimensions.dart';
import 'package:movie_search_app/core/constants/app_text_styles.dart';
import 'package:movie_search_app/data/models/movie_details.dart';

class MovieHeaderWidget extends StatelessWidget {
  final MovieDetails movie;
  final bool isDarkMode;

  const MovieHeaderWidget({
    super.key,
    required this.movie,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final posterHeight = AppDimensions.getResponsiveHeight(context, 0.25);
    final posterWidth = AppDimensions.getResponsiveWidth(context, 0.33);
    
    return Padding(
      padding: EdgeInsets.all(AppDimensions.kPaddingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie poster
          Hero(
            tag: 'movie-poster-${movie.imdbId}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.kRadiusM),
              child: movie.poster != 'N/A' && movie.poster.isNotEmpty
                ? Image.network(
                    movie.poster,
                    height: posterHeight,
                    width: posterWidth,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildLoadingContainer(posterHeight, posterWidth, isDarkMode);
                    },
                    errorBuilder: (context, error, stackTrace) {
                      // Log error but don't try external placeholder services
                      debugPrint('Error loading image for "${movie.title}": $error');
                      return _getLocalPlaceholderImage(
                        height: posterHeight,
                        width: posterWidth,
                        isDarkMode: isDarkMode,
                      );
                    },
                  )
                : _getLocalPlaceholderImage(
                    height: posterHeight,
                    width: posterWidth,
                    isDarkMode: isDarkMode,
                  ),
            ),
          ),
          SizedBox(width: AppDimensions.kPaddingM),
          
          // Movie info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: AppTextStyles.title(context, isDarkMode),
                ),
                SizedBox(height: AppDimensions.kPaddingXS),
                
                // Movie metadata with icons
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    // Year
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined, 
                          size: 16, 
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          movie.year,
                          style: AppTextStyles.caption(context, isDarkMode),
                        ),
                      ],
                    ),
                    
                    // Rating
                    if (movie.rated != 'N/A') Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.remove_red_eye_outlined, 
                          size: 16, 
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          movie.rated,
                          style: AppTextStyles.caption(context, isDarkMode),
                        ),
                      ],
                    ),
                    
                    // Runtime
                    if (movie.runtime != 'N/A') Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer_outlined, 
                          size: 16, 
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          movie.runtime,
                          style: AppTextStyles.caption(context, isDarkMode),
                        ),
                      ],
                    ),
                  ],
                ),
                
                SizedBox(height: AppDimensions.kPaddingS),
                _buildGenreChips(context, movie.genre.split(', ')),
                SizedBox(height: AppDimensions.kPaddingM),
                
                // IMDB Rating with improved visuals
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: isDarkMode ? Colors.amber.withOpacity(0.1) : Colors.amber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      // ignore: deprecated_member_use
                      color: Colors.amber.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: movie.imdbRating,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                            TextSpan(
                              text: '/10',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDarkMode ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${movie.imdbVotes})',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white60 : Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreChips(BuildContext context, List<String> genres) {
    return Wrap(
      spacing: AppDimensions.kPaddingXS,
      runSpacing: AppDimensions.kPaddingXS,
      children: genres.map((genre) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Text(
            genre,
            style: TextStyle(
              fontSize: AppDimensions.textS(context),
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLoadingContainer(double height, double width, bool isDarkMode) {
    return Container(
      height: height,
      width: width,
      color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
      child: Center(
        child: CircularProgressIndicator(
          color: isDarkMode ? AppColors.primaryColor : Colors.blue,
        ),
      ),
    );
  }

  Widget _getLocalPlaceholderImage({
    required double height,
    required double width,
    required bool isDarkMode,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_outlined,
            size: height * 0.3,
            color: isDarkMode ? Colors.white38 : Colors.black26,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'No Image Available',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDarkMode ? Colors.white54 : Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // This method is no longer used but kept for reference
}