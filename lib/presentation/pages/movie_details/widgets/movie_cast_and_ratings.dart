// lib/presentation/widgets/movie_details/movie_cast_and_ratings.dart
import 'package:flutter/material.dart';
import 'package:movie_search_app/core/constants/app_colors.dart';
import 'package:movie_search_app/core/constants/app_dimensions.dart';
import 'package:movie_search_app/core/constants/app_text_styles.dart';
import 'package:movie_search_app/data/models/movie_details.dart';


class MovieCastAndRatings extends StatelessWidget {
  final MovieDetails movie;
  final bool isDarkMode;

  const MovieCastAndRatings({
    super.key,
    required this.movie,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCast(context),
        _buildSectionDivider(),
        _buildRatings(context),
      ],
    );
  }

  Widget _buildCast(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.kPaddingM, vertical: AppDimensions.kPaddingS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.people_outline,
                size: 22,
                color: isDarkMode ? AppColors.primaryColor : Colors.blue,
              ),
              SizedBox(width: AppDimensions.kPaddingS),
              Text(
                'Cast',
                style: AppTextStyles.subtitle(context, isDarkMode),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.kPaddingM),
          
          // Build actor chips instead of plain text
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: movie.actors.split(', ').map((actor) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      actor,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRatings(BuildContext context) {
    if (movie.ratings.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.kPaddingM, vertical: AppDimensions.kPaddingS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.stars_outlined,
                size: 22,
                color: isDarkMode ? AppColors.primaryColor : Colors.blue,
              ),
              SizedBox(width: AppDimensions.kPaddingS),
              Text(
                'Ratings',
                style: AppTextStyles.subtitle(context, isDarkMode),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.kPaddingM),
          ...movie.ratings.map((rating) => _buildRatingItem(rating)),
        ],
      ),
    );
  }

  Widget _buildRatingItem(Rating rating) {
    // Function to get appropriate icon based on rating source
    IconData getSourceIcon() {
      switch (rating.source.toLowerCase()) {
        case 'internet movie database':
          return Icons.movie_filter_outlined;
        case 'rotten tomatoes':
          return Icons.thumb_up_alt_outlined;
        case 'metacritic':
          return Icons.analytics_outlined;
        default:
          return Icons.star_outline;
      }
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: isDarkMode ? Colors.grey.shade800.withOpacity(0.6) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade700 : Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              getSourceIcon(),
              size: 24,
              color: isDarkMode ? Colors.white70 : Colors.grey.shade800,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rating.source,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  rating.value,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionDivider() {
    return Divider(
      color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
      thickness: 1,
      height: AppDimensions.kPaddingL,
      indent: AppDimensions.kPaddingM,
      endIndent: AppDimensions.kPaddingM,
    );
  }
}