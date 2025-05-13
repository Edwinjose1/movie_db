// lib/presentation/widgets/movie_details/movie_detail_app_bar.dart
import 'package:flutter/material.dart';
import 'package:movie_search_app/core/constants/app_colors.dart';
import 'package:movie_search_app/core/constants/app_dimensions.dart';
import 'package:movie_search_app/core/constants/app_text_styles.dart';
import 'package:movie_search_app/data/models/movie_details.dart';


class MovieDetailAppBar extends StatelessWidget {
  final MovieDetails movie;
  final bool isDarkMode;

  const MovieDetailAppBar({
    super.key,
    required this.movie,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return SliverAppBar(
      expandedHeight: AppDimensions.getResponsiveHeight(context, 0.4),
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Movie poster background
            movie.poster != 'N/A'
                ? Image.network(
                    movie.poster,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / 
                                  loadingProgress.expectedTotalBytes!
                                : null,
                            color: isDarkMode ? AppColors.primaryColor : Colors.blue,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('Error loading poster (${movie.title}): $error');
                      return _getPlaceholderImage(
                        height: screenHeight * 0.4,
                        width: double.infinity,
                        isDarkMode: isDarkMode,
                        text: 'Poster unavailable for ${movie.title}',
                      );
                    },
                  )
                : _getPlaceholderImage(
                    height: screenHeight * 0.4,
                    width: double.infinity,
                    isDarkMode: isDarkMode,
                  ),
                  
            // Double gradient overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.2),
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.5),
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.3, 0.7, 1.0],
                ),
              ),
            ),
            
            // Side gradient for title protection
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.7),
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.3, 0.6],
                ),
              ),
            ),
          ],
        ),
        title: Opacity(
          opacity: 0.9, // Slight opacity for better visual effect
          child: Text(
            movie.title,
            style: AppTextStyles.titleDark(context),
          ),
        ),
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
      ),
      backgroundColor: isDarkMode ? AppColors.dark : AppColors.primaryColor,
      actions: [
        // Add a share button
      
      ],
    );
  }

  Widget _getPlaceholderImage({
    required double height,
    required double width,
    required bool isDarkMode,
    String text = 'No Image Available',
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
              text,
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
}