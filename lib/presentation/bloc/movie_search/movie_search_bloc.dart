import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_app/core/error/error_handler.dart';
import '../../../domain/usecases/search_movies.dart';
import 'movie_search_event.dart';
import 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;
  
   MovieSearchBloc({required this.searchMovies}) : super(MovieSearchInitial()) {
    on<SearchMoviesEvent>(_onSearchMovies);
    on<LoadMoreMoviesEvent>(_onLoadMoreMovies);
    on<ResetSearchEvent>(_onResetSearch); // Add this line
  }


  void _onResetSearch(
    ResetSearchEvent event,
    Emitter<MovieSearchState> emit,
  ) {
    emit(MovieSearchInitial());
  }
  Future<void> _onSearchMovies(
    SearchMoviesEvent event,
    Emitter<MovieSearchState> emit,
  ) async {
    // Trim the query to remove any extra spaces
    final query = event.query.trim();
    
    // Check if query is empty after trimming
    if (query.isEmpty) {
      emit(MovieSearchInitial());
      return;
    }
    
    // Check if query is too short (less than 3 characters)
    if (query.length < 3) {
      emit(MovieSearchError(
        message: 'Please enter at least 3 characters to search',
        isMinLengthError: true
      ));
      return;
    }
    
    emit(MovieSearchLoading());
    
    try {
      final result = await searchMovies(
        SearchMoviesParams(query: query, page: 1),
      );
      
      result.fold(
        (failure) => emit(MovieSearchError(
          message: ErrorHandler.getErrorMessage(failure),
          isMinLengthError: false
        )),
        (movies) => emit(
          MovieSearchLoaded(
            movies: movies,
            hasReachedEnd: movies.length < 10,
            currentPage: 1,
            currentQuery: query,
          ),
        ),
      );
    } catch (e) {
      emit(MovieSearchError(
        message: ErrorHandler.handleException(e),
        isMinLengthError: false
      ));
    }
  }

  Future<void> _onLoadMoreMovies(
    LoadMoreMoviesEvent event,
    Emitter<MovieSearchState> emit,
  ) async {
    if (state is MovieSearchLoaded) {
      final currentState = state as MovieSearchLoaded;
      
      emit(MovieSearchLoadingMore(currentMovies: currentState.movies));
      
      try {
        final result = await searchMovies(
          SearchMoviesParams(query: event.query, page: event.page),
        );
        
        result.fold(
          (failure) => emit(MovieSearchError(
            message: ErrorHandler.getErrorMessage(failure),
            isMinLengthError: false
          )),
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
      } catch (e) {
        emit(MovieSearchError(
          message: ErrorHandler.handleException(e),
          // isMinLengthError: false
        ));
      }
    }
  }
}