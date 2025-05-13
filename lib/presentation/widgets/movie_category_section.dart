// lib/presentation/widgets/movie_category_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_app/presentation/bloc/movie_search/movie_search_bloc.dart';
// import '../bloc/movie_search/movie_categories_bloc.dart';
import '../bloc/movie_search/movie_search_event.dart';
import '../bloc/movie_search/movie_search_state.dart';
import '../../domain/entities/movie.dart';
import 'loading_widget.dart';
import 'error_widget.dart';

class MovieCategorySection extends StatefulWidget {
  final String title;
  final String query;
  final Function(Movie) onMovieTap;

  const MovieCategorySection({
    super.key,
    required this.title,
    required this.query,
    required this.onMovieTap,
  });

  @override
  State<MovieCategorySection> createState() => _MovieCategorySectionState();
}

class _MovieCategorySectionState extends State<MovieCategorySection> {
  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  void _loadMovies() {
    context.read<MovieSearchBloc>().add(SearchMoviesEvent(query: widget.query));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 240,
          child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
            builder: (context, state) {
              if (state is MovieSearchLoading) {
                return const LoadingWidget();
              } else if (state is MovieSearchLoaded) {
                final movies = state.movies;
                
                if (movies.isEmpty) {
                  return const Center(child: Text('No movies found'));
                }
                
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length > 5 ? 5 : movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return _buildMovieCard(movie);
                  },
                );
              } else if (state is MovieSearchError) {
                return ErrorDisplayWidget(
                  message: state.message,
                  onRetry: _loadMovies,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () => widget.onMovieTap(movie),
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie poster
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: movie.poster != "N/A"
                  ? Image.network(
                      movie.poster,
                      height: 180,
                      width: 140,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 180,
                      width: 140,
                      color: Colors.grey,
                      child: const Icon(Icons.movie, size: 50),
                    ),
            ),
            const SizedBox(height: 8.0),
            // Movie title (truncated if too long)
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            // Movie year
            Text(
              movie.year,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}