import 'package:flutter/material.dart';
import 'package:movie_search_app/core/constants/app_colors.dart';
import 'package:movie_search_app/core/constants/utils/theme_provider.dart';
import 'package:movie_search_app/presentation/pages/home/widgets/category_bottom_sheet_handle.dart';
import 'package:movie_search_app/presentation/pages/home/widgets/other_common.dart';
import 'package:provider/provider.dart';

class CategoryDetailBottomSheet extends StatefulWidget {
  final String categoryTitle;
  final List<dynamic> initialMovies;
  final Future<List<dynamic>> Function(String query, int page) searchMovies;

  const CategoryDetailBottomSheet({
    super.key,
    required this.categoryTitle,
    required this.initialMovies,
    required this.searchMovies,
  });

  @override
  State<CategoryDetailBottomSheet> createState() => _CategoryDetailBottomSheetState();
}

class _CategoryDetailBottomSheetState extends State<CategoryDetailBottomSheet> {
  late ScrollController scrollController;
  bool isLoadingMore = false;
  int currentPage = 1;
  late List<dynamic> displayedMovies;
  
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    displayedMovies = List.from(widget.initialMovies);
    
    scrollController.addListener(_scrollListener);
  }
  
  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }
  
  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent * 0.8 &&
        !isLoadingMore) {
      _loadMoreMovies();
    }
  }
  
  String _getCategorySearchQuery() {
    switch(widget.categoryTitle) {
      case 'Latest Movies 2025':
        return '2025';
      case 'Popular Action Movies':
        return 'action 2024';
      case 'Trending Science Fiction':
        return 'sci-fi';
      case 'Top Rated Blockbusters':
        return 'marvel';
      default:
        return '';
    }
  }
  
  Future<void> _loadMoreMovies() async {
    if (isLoadingMore) return;
    
    final searchQuery = _getCategorySearchQuery();
    if (searchQuery.isEmpty) return;
    
    setState(() {
      isLoadingMore = true;
    });
    
    try {
      final moreMovies = await widget.searchMovies(searchQuery, currentPage + 1);
      
      if (moreMovies.isNotEmpty) {
        setState(() {
          displayedMovies.addAll(moreMovies);
          currentPage++;
        });
      }
    } catch (e) {
      debugPrint('Error loading more movies: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.dark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              const CategoryBottomSheetHandle(),
              
              // Header
              CategoryBottomSheetHeader(
                categoryTitle: widget.categoryTitle,
                isDarkMode: isDarkMode,
              ),
              
              // Movie grid with loading indicator
              Expanded(
                child: CategoryBottomSheetContent(
                  displayedMovies: displayedMovies,
                  isLoadingMore: isLoadingMore,
                  scrollController: scrollController,
                  isDarkMode: isDarkMode,
                ),
              ),
              
              // Loading indicator at the bottom
              if (isLoadingMore)
                CategoryBottomSheetLoadingFooter(isDarkMode: isDarkMode),
            ],
          ),
        );
      },
    );
  }
}

class CategoryBottomSheetHandle extends StatelessWidget {
  const CategoryBottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 50,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}



// Stateless widget for category bottom sheet content
class CategoryBottomSheetContent extends StatelessWidget {
  final List<dynamic> displayedMovies;
  final bool isLoadingMore;
  final ScrollController scrollController;
  final bool isDarkMode;

  const CategoryBottomSheetContent({
    super.key,
    required this.displayedMovies,
    required this.isLoadingMore,
    required this.scrollController,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return displayedMovies.isEmpty
        ? Center(
            child: Text(
              'No movies available',
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.grey[700],
              ),
            ),
          )
        : GridView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: isLoadingMore 
                ? displayedMovies.length + 2 // Add 2 loading indicators
                : displayedMovies.length,
            itemBuilder: (context, index) {
              // Show loading indicator at the end while loading more
              if (index >= displayedMovies.length) {
                return MovieGridLoadingItem(isDarkMode: isDarkMode);
              }
              
              final movie = displayedMovies[index];
              return MovieGridItem(
                movie: movie,
                isDarkMode: isDarkMode,
              );
            },
          );
  }
}
