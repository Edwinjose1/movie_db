import 'package:flutter/material.dart';
import 'package:movie_search_app/core/constants/app_colors.dart';
import 'package:movie_search_app/core/constants/app_dimensions.dart';

class CategoryErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final bool isDarkMode;
  final VoidCallback onRetry;

  const CategoryErrorWidget({
    super.key,
    this.errorMessage,
    required this.isDarkMode,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorMessage ?? 'Error loading movies',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.grey[700],
            ),
          ),
          SizedBox(height: AppDimensions.kPaddingS),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? AppColors.primaryColor : Colors.blue,
            ),
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}