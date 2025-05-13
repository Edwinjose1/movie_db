// lib/presentation/widgets/search_page_widgets/movie_search_results.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_app/core/constants/app_dimensions.dart';
import 'package:movie_search_app/core/constants/app_strings.dart';
import 'package:movie_search_app/core/constants/utils/theme_provider.dart';
import 'package:movie_search_app/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:movie_search_app/presentation/bloc/movie_search/movie_search_event.dart';
import 'package:movie_search_app/presentation/bloc/movie_search/movie_search_state.dart';
import 'package:movie_search_app/presentation/pages/movie_details/movie_details_page.dart';
import 'package:movie_search_app/presentation/widgets/error_widget.dart';
import 'package:movie_search_app/presentation/widgets/loading_widget.dart';
import 'package:movie_search_app/presentation/widgets/movie_list_item.dart';
import 'package:provider/provider.dart';


class MovieSearchResults extends StatefulWidget {
  const MovieSearchResults({super.key});

  @override
  State<MovieSearchResults> createState() => _MovieSearchResultsState();
}

class _MovieSearchResultsState extends State<MovieSearchResults> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final currentState = context.read<MovieSearchBloc>().state;
      if (currentState is MovieSearchLoaded && !currentState.hasReachedEnd) {
        context.read<MovieSearchBloc>().add(
              LoadMoreMoviesEvent(
                query: currentState.currentQuery,
                page: currentState.currentPage + 1,
              ),
            );
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return BlocBuilder<MovieSearchBloc, MovieSearchState>(
      builder: (context, state) {
        if (state is MovieSearchInitial) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 80,
                  color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                ),
                SizedBox(height: AppDimensions.kPaddingM),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.kPaddingL),
                  child: Text(
                    AppStrings.searchInitialMessage,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.grey[700],
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        } else if (state is MovieSearchLoading) {
          return const LoadingWidget();
        } else if (state is MovieSearchLoaded || state is MovieSearchLoadingMore) {
          final movies = state is MovieSearchLoaded 
              ? state.movies 
              : (state as MovieSearchLoadingMore).currentMovies;
          
          final isLoadingMore = state is MovieSearchLoadingMore;
          
          return movies.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.movie_filter_rounded,
                        size: 80,
                        color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                      ),
                      SizedBox(height: AppDimensions.kPaddingM),
                      Text(
                        AppStrings.noResultsFound,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.grey[700],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.kPaddingM,
                    vertical: AppDimensions.kPaddingS,
                  ),
                  itemCount: isLoadingMore
                      ? movies.length + 1
                      : movies.length,
                  itemBuilder: (context, index) {
                    if (index >= movies.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: AppDimensions.kPaddingM),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    
                    final movie = movies[index];
                    return MovieListItem(
                      movie: movie,
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
                    );
                  },
                );
        } else if (state is MovieSearchError) {
          return ErrorDisplayWidget(
            message: state.message,
            onRetry: () {
              final searchText = context.read<MovieSearchBloc>().state is MovieSearchLoaded
                  ? (context.read<MovieSearchBloc>().state as MovieSearchLoaded).currentQuery
                  : '';
              
              if (searchText.isNotEmpty) {
                context.read<MovieSearchBloc>().add(
                      SearchMoviesEvent(query: searchText),
                    );
              }
            },
          );
        }
        
        return Container();
      },
    );
  }
}