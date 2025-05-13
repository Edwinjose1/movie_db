// lib/presentation/widgets/movie_details/movie_info_section.dart
import 'package:flutter/material.dart';
import 'package:movie_search_app/core/constants/app_colors.dart';
import 'package:movie_search_app/core/constants/app_dimensions.dart';
import 'package:movie_search_app/core/constants/app_text_styles.dart';
import 'package:movie_search_app/data/models/movie_details.dart';


class MovieInfoSection extends StatelessWidget {
  final MovieDetails movie;
  final bool isDarkMode;

  const MovieInfoSection({
    super.key,
    required this.movie,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPlot(context),
        _buildSectionDivider(context),
        _buildInfo(context),
      ],
    );
  }

  Widget _buildPlot(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.kPaddingM, vertical: AppDimensions.kPaddingS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                size: 22,
                color: isDarkMode ? AppColors.primaryColor : Colors.blue,
              ),
              SizedBox(width: AppDimensions.kPaddingS),
              Text(
                'Plot',
                style: AppTextStyles.subtitle(context, isDarkMode),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.kPaddingS),
          Text(
            movie.plot,
            style: AppTextStyles.body(context, isDarkMode),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.kPaddingM, vertical: AppDimensions.kPaddingS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 22,
                color: isDarkMode ? AppColors.primaryColor : Colors.blue,
              ),
              SizedBox(width: AppDimensions.kPaddingS),
              Text(
                'Movie Info',
                style: AppTextStyles.subtitle(context, isDarkMode),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.kPaddingM),
          _buildInfoCard(context, 'Director', movie.director, Icons.movie_creation_outlined),
          _buildInfoCard(context, 'Writer', movie.writer, Icons.edit_outlined),
          _buildInfoCard(context, 'Released', movie.released, Icons.event_outlined),
          _buildInfoCard(context, 'Country', movie.country, Icons.public_outlined),
          _buildInfoCard(context, 'Language', movie.language, Icons.language_outlined),
          _buildInfoCard(context, 'Awards', movie.awards, Icons.emoji_events_outlined),
          if (movie.boxOffice != null && movie.boxOffice != 'N/A')
            _buildInfoCard(context, 'Box Office', movie.boxOffice!, Icons.attach_money_outlined),
          if (movie.production != null && movie.production != 'N/A')
            _buildInfoCard(context, 'Production', movie.production!, Icons.business_outlined),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String label, String value, IconData icon) {
    if (value == 'N/A') return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 22,
              color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
          SizedBox(width: AppDimensions.kPaddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                    fontSize: AppDimensions.textM(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.body(context, isDarkMode),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionDivider(BuildContext context) {
    return Divider(
      color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
      thickness: 1,
      height: AppDimensions.kPaddingL,
      indent: AppDimensions.kPaddingM,
      endIndent: AppDimensions.kPaddingM,
    );
  }
}