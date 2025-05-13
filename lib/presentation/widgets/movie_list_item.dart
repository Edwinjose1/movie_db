// lib/presentation/widgets/movie_list_item.dart
import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';

class MovieListItem extends StatelessWidget {
  final Movie movie;
  final Function() onTap;
  final bool isDarkMode;

  // ignore: use_super_parameters
  const MovieListItem({
    Key? key,
    required this.movie,
    required this.onTap,
    this.isDarkMode = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: AppDimensions.kPaddingS),
      elevation: isDarkMode ? 4.0 : 1.0,
      color: isDarkMode ? Colors.grey.shade900 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.kRadiusM),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.kRadiusM),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie poster
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.kRadiusM),
                bottomLeft: Radius.circular(AppDimensions.kRadiusM),
              ),
              child: Image.network(
                movie.poster != 'N/A' 
                    ? movie.poster 
                    : 'https://via.placeholder.com/100x150?text=No+Image',
                height: 150,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 150,
                  width: 100,
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
            ),
            // Movie info
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.kPaddingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: AppTextStyles.movieTitle(context, isDarkMode),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppDimensions.kPaddingXS),
                    Text(
                      movie.year,
                      style: AppTextStyles.movieYear(context, isDarkMode),
                    ),
                    SizedBox(height: AppDimensions.kPaddingS),
                    Row(
                      children: [
                        Icon(
                          Icons.movie_outlined,
                          size: 16,
                          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                        SizedBox(width: AppDimensions.kPaddingXS),
                        Text(
                          movie.type.toUpperCase(),
                          style: TextStyle(
                            fontSize: AppDimensions.textXS(context),
                            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.kPaddingS,
                            vertical: AppDimensions.kPaddingXS / 2,
                          ),
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.amber.shade800 : Colors.amber.shade700,
                            borderRadius: BorderRadius.circular(AppDimensions.kRadiusS),
                          ),
                          child: Text(
                            'IMDb',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppDimensions.textXS(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}