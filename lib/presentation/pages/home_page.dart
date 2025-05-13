import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_app/domain/usecases/search_movies.dart';
import '../bloc/movie_categories/movie_categories_bloc.dart';
import '../bloc/movie_categories/movie_categories_event.dart';
import '../bloc/movie_categories/movie_categories_state.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/horizontal_movie_list.dart';
import 'movie_search_page.dart';
import 'movie_details_page.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';

import '../../core/constants/utils/theme_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  // int _currentIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadData() {
    context.read<MovieCategoriesBloc>().add(FetchAllCategoriesEvent());
  }

  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MovieSearchPage()),
    );
  }


void _showCategoryView(String categoryTitle, List<dynamic> movies) {
  // Create a scroll controller to detect scroll position for pagination
  final ScrollController scrollController = ScrollController();
  
  // Variables to track pagination state
  bool isLoadingMore = false;
  int currentPage = 1;
  List<dynamic> displayedMovies = List.from(movies);
  
  // Function to load more movies based on category
  Future<List<dynamic>> loadMoreMovies(int page) async {
    try {
      // Get the search query based on category
      String searchQuery;
      switch(categoryTitle) {
        case 'Latest Movies 2025':
          searchQuery = '2025';
          break;
        case 'Popular Action Movies':
          searchQuery = 'action 2024';
          break;
        case 'Trending Science Fiction':
          searchQuery = 'sci-fi';
          break;
        case 'Top Rated Blockbusters':
          searchQuery = 'marvel';
          break;
        default:
          searchQuery = '';
      }
      
      // If we don't have a valid search query, return empty list
      if (searchQuery.isEmpty) return [];
      
      // Use the searchMovies use case directly
      final result = await context.read<MovieCategoriesBloc>().searchMovies(
        SearchMoviesParams(query: searchQuery, page: page),
      );
      
      return result.fold(
        (failure) => [],
        (movies) => movies,
      );
    } catch (e) {
      // Handle any errors that might occur
      debugPrint('Error loading more movies: $e');
      return [];
    }
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final themeProvider = Provider.of<ThemeProvider>(context);
      final isDarkMode = themeProvider.isDarkMode;
      
      return StatefulBuilder(
        builder: (context, setState) {
          // Add scroll listener for pagination
          scrollController.addListener(() {
            if (scrollController.position.pixels >= scrollController.position.maxScrollExtent * 0.8 &&
                !isLoadingMore) {
              // Load more data when we're 80% to the bottom
              setState(() {
                isLoadingMore = true;
              });
              
              loadMoreMovies(currentPage + 1).then((moreMovies) {
                if (moreMovies.isNotEmpty) {
                  setState(() {
                    displayedMovies.addAll(moreMovies);
                    currentPage++;
                    isLoadingMore = false;
                  });
                } else {
                  setState(() {
                    isLoadingMore = false;
                  });
                }
              });
            }
          });
          
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
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[600] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            categoryTitle,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                            onPressed: () {
                              // Clean up resources
                              scrollController.dispose();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    // Movie grid with loading indicator
                    Expanded(
                      child: displayedMovies.isEmpty
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
                                  return Container(
                                    decoration: BoxDecoration(
                                      // ignore: deprecated_member_use
                                      color: isDarkMode ? Colors.grey[800]!.withOpacity(0.5) : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: isDarkMode ? Colors.white70 : AppColors.primaryColor,
                                      ),
                                    ),
                                  );
                                }
                                
                                final movie = displayedMovies[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MovieDetailsPage(
                                          movieId: movie.imdbId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: GridTile(
                                      footer: GridTileBar(
                                        backgroundColor: Colors.black54,
                                        title: Text(
                                          movie.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Text(movie.year),
                                        // Removed the rating section that was causing errors
                                      ),
                                      child: Container(
                                        color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                                        child: movie.poster != "N/A"
                                            ? Image.network(
                                                movie.poster,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) => Icon(
                                                  Icons.movie,
                                                  size: 50,
                                                  color: isDarkMode ? Colors.grey[700] : Colors.grey[400],
                                                ),
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return Center(
                                                    child: CircularProgressIndicator(
                                                      value: loadingProgress.expectedTotalBytes != null
                                                          ? loadingProgress.cumulativeBytesLoaded / 
                                                              loadingProgress.expectedTotalBytes!
                                                          : null,
                                                      color: isDarkMode ? Colors.white70 : AppColors.primaryColor,
                                                    ),
                                                  );
                                                },
                                              )
                                            : Icon(
                                                Icons.movie,
                                                size: 50,
                                                color: isDarkMode ? Colors.grey[700] : Colors.grey[400],
                                              ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    
                    // Loading indicator at the bottom
                    if (isLoadingMore)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: isDarkMode ? Colors.white70 : AppColors.primaryColor,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Loading more movies...',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white70 : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  ).then((_) {
    // Dispose of the scroll controller when the bottom sheet is closed
    scrollController.dispose();
  });
}
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.dark : Colors.grey[50],
      body: SafeArea(
        child: BlocConsumer<MovieCategoriesBloc, MovieCategoriesState>(
          listener: (context, state) {
            if (state is MovieCategoriesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                _loadData();
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Modern app header
                  SliverToBoxAdapter(
                    child: _buildHeader(isDarkMode),
                  ),

                  // Search bar
                  SliverToBoxAdapter(
                    child: _buildSearchBar(isDarkMode),
                  ),

                  if (state is MovieCategoriesInitial || state is MovieCategoriesLoading)
                    const SliverFillRemaining(
                      child: LoadingWidget(),
                    )
                  else if (state is MovieCategoriesLoaded)
                    SliverList(
                      delegate: SliverChildListDelegate([
                        _buildFeaturedSection(state.latestMovies, isDarkMode),
                        _buildCategorySection(
                          title: 'Latest Movies 2025',
                          movies: state.latestMovies,
                          isLoading: state.isLatestLoading,
                          hasError: state.latestError != null,
                          errorMessage: state.latestError,
                          isDarkMode: isDarkMode,
                        ),
                        _buildCategorySection(
                          title: 'Popular Action Movies',
                          movies: state.actionMovies,
                          isLoading: state.isActionLoading,
                          hasError: state.actionError != null,
                          errorMessage: state.actionError,
                          isDarkMode: isDarkMode,
                        ),
                        _buildCategorySection(
                          title: 'Trending Science Fiction',
                          movies: state.scifiMovies,
                          isLoading: state.isScifiLoading, 
                          hasError: state.scifiError != null,
                          errorMessage: state.scifiError,
                          isDarkMode: isDarkMode,
                        ),
                        _buildCategorySection(
                          title: 'Top Rated Blockbusters',
                          movies: state.blockbusterMovies,
                          isLoading: state.isBlockbusterLoading,
                          hasError: state.blockbusterError != null,
                          errorMessage: state.blockbusterError,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: AppDimensions.kPaddingL),
                      ]),
                    )
                  else if (state is MovieCategoriesError)
                    SliverFillRemaining(
                      child: ErrorDisplayWidget(
                        message: state.message,
                        onRetry: _loadData,
                      ),
                    )
                  else
                    const SliverToBoxAdapter(child: SizedBox.shrink()),
                ],
              ),
            );
          },
        ),
      ),
      
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.kPaddingM,
        vertical: AppDimensions.kPaddingL,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.appTitle,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                'Find your favorite movies',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
            ],
          ),
          // Theme toggle button in header instead of floating action button
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDarkMode ? Colors.amber : Colors.blueGrey,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDarkMode) {
    return GestureDetector(
      onTap: _navigateToSearch,
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

  Widget _buildFeaturedSection(List<dynamic> movies, bool isDarkMode) {
    // Only show featured section if we have movies
    if (movies.isEmpty) return const SizedBox.shrink();
    
    // Get the first movie from the list as featured
    final featuredMovie = movies.first;
    
    return Container(
      margin: EdgeInsets.all(AppDimensions.kPaddingM),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Movie poster as background
            featuredMovie.poster != "N/A"
                ? 
                Image.network(
                    featuredMovie.poster,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                    child: Icon(
                      Icons.movie,
                      size: 80,
                      color: isDarkMode ? Colors.grey[700] : Colors.grey[400],
                    ),
                  ),
            
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            
            // Movie info
            Positioned(
              bottom: AppDimensions.kPaddingM,
              left: AppDimensions.kPaddingM,
              right: AppDimensions.kPaddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    featuredMovie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppDimensions.kPaddingXS),
                  Text(
                    featuredMovie.year,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
        
            
            // Make the entire card clickable
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailsPage(
                        movieId: featuredMovie.imdbId,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection({
    required String title,
    required List<dynamic> movies,
    required bool isLoading,
    required bool hasError,
    required bool isDarkMode,
    String? errorMessage,
  }) {
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
                onPressed: () {
                  // Show bottom sheet with all movies in this category
                  _showCategoryView(title, movies);
                },
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
                  ? Center(
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
                            onPressed: _loadData,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
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