import 'package:flutter/material.dart';
import 'package:movie_search_app/core/constants/app_colors.dart';
import 'package:movie_search_app/core/constants/app_dimensions.dart';
import 'package:movie_search_app/presentation/pages/home/widgets/category_error_widget.dart';
import 'package:movie_search_app/presentation/pages/movie_details/movie_details_page.dart';
import 'package:movie_search_app/presentation/widgets/horizontal_movie_list.dart';

class CategorySection extends StatelessWidget {
  final String title;
  final List<dynamic> movies;
  final bool isLoading;
  final bool hasError;
  final bool isDarkMode;
  final String? errorMessage;
  final VoidCallback onRetry;
  final VoidCallback onSeeAll;

  const CategorySection({
    super.key,
    required this.title,
    required this.movies,
    required this.isLoading,
    required this.hasError,
    required this.isDarkMode,
    this.errorMessage,
    required this.onRetry,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.kPaddingM,
            vertical: AppDimensions.kPaddingS,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: Text(
                  'See all',
                  style: TextStyle(
                    color: isDarkMode ? AppColors.primaryColor : Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: AppDimensions.movieCardHeight(context) + AppDimensions.kPaddingM,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: isDarkMode ? Colors.white70 : Colors.blueGrey,
                  ),
                )
              : hasError
                  ? CategoryErrorWidget(
                      errorMessage: errorMessage,
                      isDarkMode: isDarkMode,
                      onRetry: onRetry,
                    )
                  : movies.isEmpty
                      ? Center(
                          child: Text(
                            'No movies found',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.grey[700],
                            ),
                          ),
                        )
                      : HorizontalMovieList(
                          movies: movies,
                          onTap: (movie) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailsPage(
                                  movieId: movie.imdbId,
                                ),
                              ),
                            );
                          },
                          isDarkMode: isDarkMode,
                        ),
        ),
      ],
    );
  }
}