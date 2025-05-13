// lib/presentation/widgets/horizontal_movie_list.dart
import 'package:flutter/material.dart';

import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';

class HorizontalMovieList extends StatelessWidget {
  final List<dynamic> movies;
  final Function(dynamic) onTap;
  final bool isDarkMode;

  // ignore: use_super_parameters
  const HorizontalMovieList({
    Key? key,
    required this.movies,
    required this.onTap,
    this.isDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardWidth = AppDimensions.movieCardWidth(context);
    final cardHeight = AppDimensions.movieCardHeight(context);
    
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.kPaddingS),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () => onTap(movie),
          child: Container(
            width: cardWidth,
            margin: EdgeInsets.symmetric(horizontal: AppDimensions.kPaddingS),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.kRadiusM),
                  child: Image.network(
                    movie.poster != 'N/A' 
                        ? movie.poster 
                        : 'https://via.placeholder.com/140x200?text=No+Image',
                    height: cardHeight * 0.8,
                    width: cardWidth,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: cardHeight * 0.8,
                      width: cardWidth,
                      color: Colors.grey.shade300,
                      child: const Center(child: Icon(Icons.image_not_supported)),
                    ),
                  ),
                ),
                SizedBox(height: AppDimensions.kPaddingXS),
                Text(
                  movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.movieTitle(context, isDarkMode),
                ),
                Text(
                  movie.year,
                  style: AppTextStyles.movieYear(context, isDarkMode),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}