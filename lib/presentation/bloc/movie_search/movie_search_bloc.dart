// lib/presentation/bloc/movie_search/movie_search_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/search_movies.dart';
import 'movie_search_event.dart';
import 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;
  
  MovieSearchBloc({required this.searchMovies}) : super(MovieSearchInitial()) {
    on<SearchMoviesEvent>(_onSearchMovies);
    on<LoadMoreMoviesEvent>(_onLoadMoreMovies);
  }

  Future<void> _onSearchMovies(
    SearchMoviesEvent event,
    Emitter<MovieSearchState> emit,
  ) async {
    emit(MovieSearchLoading());
    
    final result = await searchMovies(
      SearchMoviesParams(query: event.query, page: 1),
    );
    
    result.fold(
      (failure) => emit(MovieSearchError(message: failure.toString())),
      (movies) => emit(
        MovieSearchLoaded(
          movies: movies,
          hasReachedEnd: movies.length < 10, // Assuming OMDB returns 10 results per page
          currentPage: 1,
          currentQuery: event.query,
        ),
      ),
    );
  }

  Future<void> _onLoadMoreMovies(
    LoadMoreMoviesEvent event,
    Emitter<MovieSearchState> emit,
  ) async {
    if (state is MovieSearchLoaded) {
      final currentState = state as MovieSearchLoaded;
      
      emit(MovieSearchLoadingMore(currentMovies: currentState.movies));
      
      final result = await searchMovies(
        SearchMoviesParams(query: event.query, page: event.page),
      );
      
      result.fold(
        (failure) => emit(MovieSearchError(message: failure.toString())),
        (newMovies) {
          final allMovies = List.of(currentState.movies)..addAll(newMovies);
          
          emit(
            MovieSearchLoaded(
              movies: allMovies,
              hasReachedEnd: newMovies.isEmpty || newMovies.length < 10,
              currentPage: event.page,
              currentQuery: event.query,
            ),
          );
        },
      );
    }
  }
}