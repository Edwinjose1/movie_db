// lib/presentation/pages/movie_search_page.dart
import 'package:flutter/material.dart';

import 'package:movie_search_app/core/constants/app_colors.dart';
import 'package:movie_search_app/presentation/pages/movie_search/widgets/movie_search_bar.dart';
import 'package:movie_search_app/presentation/pages/movie_search/widgets/movie_search_header.dart';
import 'package:movie_search_app/presentation/pages/movie_search/widgets/movie_search_results.dart';

import '../../core/constants/utils/theme_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchPage extends StatelessWidget {
  const MovieSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.dark : Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and theme toggle
            MovieSearchHeader(
              onBackPressed: () => Navigator.pop(context),
              onThemeToggle: () => themeProvider.toggleTheme(),
              isDarkMode: isDarkMode,
            ),

            // Search bar with voice input
            const MovieSearchBar(),

            // Search results
            const Expanded(child: MovieSearchResults()),
          ],
        ),
      ),
    );
  }
}
