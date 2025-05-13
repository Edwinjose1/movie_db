// lib/presentation/widgets/search_page_widgets/movie_search_header.dart
import 'package:flutter/material.dart';
import 'package:movie_search_app/core/constants/app_dimensions.dart';


class MovieSearchHeader extends StatelessWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const MovieSearchHeader({
    super.key,
    required this.onBackPressed,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.kPaddingM,
        vertical: AppDimensions.kPaddingM,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onBackPressed,
            borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
            child: Container(
              padding: EdgeInsets.all(AppDimensions.kPaddingXS),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.kRadiusM),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: isDarkMode ? Colors.black12 : Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: isDarkMode ? Colors.white : Colors.black87,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Search Movies',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const Spacer(),

        ],
      ),
    );
  }
}