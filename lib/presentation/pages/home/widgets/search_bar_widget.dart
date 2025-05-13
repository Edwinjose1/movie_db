import 'package:flutter/material.dart';
import 'package:movie_search_app/core/constants/app_dimensions.dart';
import 'package:movie_search_app/core/constants/app_strings.dart';

class SearchBarWidget extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onTap;

  const SearchBarWidget({
    super.key,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppDimensions.kPaddingM,
          vertical: AppDimensions.kPaddingS,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.kPaddingM,
          vertical: AppDimensions.kPaddingM,
        ),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: isDarkMode ? Colors.black12 : Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            SizedBox(width: AppDimensions.kPaddingS),
            Text(
              AppStrings.searchHint,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.mic,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}
