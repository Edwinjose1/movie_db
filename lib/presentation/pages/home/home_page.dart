
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_app/domain/usecases/search_movies.dart';
import 'package:movie_search_app/presentation/pages/home/widgets/category_detail_bottom_sheet.dart';
import 'package:movie_search_app/presentation/pages/home/widgets/categroy_section.dart';
import 'package:movie_search_app/presentation/pages/home/widgets/featured_section.dart';
import 'package:movie_search_app/presentation/pages/home/widgets/home_app_header.dart';
import 'package:movie_search_app/presentation/pages/home/widgets/search_bar_widget.dart';
import '../../bloc/movie_categories/movie_categories_bloc.dart';
import '../../bloc/movie_categories/movie_categories_event.dart';
import '../../bloc/movie_categories/movie_categories_state.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
// import '../../widgets/horizontal_movie_list.dart';
import '../movie_search_page.dart';
// import '../movie_details/movie_details_page.dart';
import '../../../core/constants/app_colors.dart';
// import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';

import '../../../core/constants/utils/theme_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CategoryDetailBottomSheet(
          categoryTitle: categoryTitle,
          initialMovies: movies,
          searchMovies: (query, page) async {
            final result = await context.read<MovieCategoriesBloc>().searchMovies(
              SearchMoviesParams(query: query, page: page),
            );
            return result.fold(
              (failure) => [],
              (movies) => movies,
            );
          },
        );
      },
    );
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
                    child: HomeAppHeader(isDarkMode: isDarkMode),
                  ),

                  // Search bar
                  SliverToBoxAdapter(
                    child: SearchBarWidget(
                      isDarkMode: isDarkMode,
                      onTap: _navigateToSearch,
                    ),
                  ),

                  if (state is MovieCategoriesInitial || state is MovieCategoriesLoading)
                    const SliverFillRemaining(
                      child: LoadingWidget(),
                    )
                  else if (state is MovieCategoriesLoaded)
                    SliverList(
                      delegate: SliverChildListDelegate([
                        FeaturedSection(
                          movies: state.latestMovies,
                          isDarkMode: isDarkMode,
                        ),
                        CategorySection(
                          title: 'Latest Movies 2025',
                          movies: state.latestMovies,
                          isLoading: state.isLatestLoading,
                          hasError: state.latestError != null,
                          errorMessage: state.latestError,
                          isDarkMode: isDarkMode,
                          onRetry: _loadData,
                          onSeeAll: () => _showCategoryView('Latest Movies 2025', state.latestMovies),
                        ),
                        CategorySection(
                          title: 'Popular Action Movies',
                          movies: state.actionMovies,
                          isLoading: state.isActionLoading,
                          hasError: state.actionError != null,
                          errorMessage: state.actionError,
                          isDarkMode: isDarkMode,
                          onRetry: _loadData,
                          onSeeAll: () => _showCategoryView('Popular Action Movies', state.actionMovies),
                        ),
                        CategorySection(
                          title: 'Trending Science Fiction',
                          movies: state.scifiMovies,
                          isLoading: state.isScifiLoading, 
                          hasError: state.scifiError != null,
                          errorMessage: state.scifiError,
                          isDarkMode: isDarkMode,
                          onRetry: _loadData,
                          onSeeAll: () => _showCategoryView('Trending Science Fiction', state.scifiMovies),
                        ),
                        CategorySection(
                          title: 'Top Rated Blockbusters',
                          movies: state.blockbusterMovies,
                          isLoading: state.isBlockbusterLoading,
                          hasError: state.blockbusterError != null,
                          errorMessage: state.blockbusterError,
                          isDarkMode: isDarkMode,
                          onRetry: _loadData,
                          onSeeAll: () => _showCategoryView('Top Rated Blockbusters', state.blockbusterMovies),
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
}

