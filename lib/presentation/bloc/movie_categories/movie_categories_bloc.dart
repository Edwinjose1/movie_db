// lib/presentation/bloc/movie_categories/movie_categories_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/search_movies.dart';
import 'movie_categories_event.dart';
import 'movie_categories_state.dart';

class MovieCategoriesBloc extends Bloc<MovieCategoriesEvent, MovieCategoriesState> {
  final SearchMovies searchMovies;
  
  // Keep track of data locally to ensure persistence
  final Map<String, dynamic> _cachedData = {
    'latestMovies': [],
    'actionMovies': [],
    'scifiMovies': [],
    'blockbusterMovies': [],
  };

  MovieCategoriesBloc({required this.searchMovies}) : super(MovieCategoriesInitial()) {
    on<FetchAllCategoriesEvent>(_onFetchAllCategories);
  }

  Future<void> _onFetchAllCategories(
    FetchAllCategoriesEvent event,
    Emitter<MovieCategoriesState> emit,
  ) async {
    // First, emit initial loading state if not already in loaded state
    if (state is! MovieCategoriesLoaded) {
      emit(MovieCategoriesLoading());
      
      // Initialize with empty data and loading indicators
      emit(MovieCategoriesLoaded(
        latestMovies: _cachedData['latestMovies'],
        actionMovies: _cachedData['actionMovies'],
        scifiMovies: _cachedData['scifiMovies'],
        blockbusterMovies: _cachedData['blockbusterMovies'],
        isLatestLoading: true,
        isActionLoading: true,
        isScifiLoading: true,
        isBlockbusterLoading: true,
      ));
    } else {
      // Update loading indicators but keep existing data
      final currentState = state as MovieCategoriesLoaded;
      emit(currentState.copyWith(
        isLatestLoading: true,
        isActionLoading: true,
        isScifiLoading: true,
        isBlockbusterLoading: true,
      ));
    }
    
    // Fetch Latest Movies 2025
    try {
      final latestResult = await searchMovies(
        SearchMoviesParams(query: '2025', page: 1),
      );
      
      latestResult.fold(
        (failure) {
          final currentState = state as MovieCategoriesLoaded;
          emit(currentState.copyWith(
            isLatestLoading: false,
            latestError: failure.message,
          ));
        },
        (movies) {
          _cachedData['latestMovies'] = movies;
          final currentState = state as MovieCategoriesLoaded;
          emit(currentState.copyWith(
            latestMovies: movies,
            isLatestLoading: false,
            clearLatestError: true,
          ));
        },
      );
    } catch (e) {
      final currentState = state as MovieCategoriesLoaded;
      emit(currentState.copyWith(
        isLatestLoading: false,
        latestError: 'Failed to load latest movies',
      ));
    }
    
    // Fetch Action Movies
    try {
      final actionResult = await searchMovies(
        SearchMoviesParams(query: 'action 2024', page: 1),
      );
      
      actionResult.fold(
        (failure) {
          final currentState = state as MovieCategoriesLoaded;
          emit(currentState.copyWith(
            isActionLoading: false,
            actionError: failure.message,
          ));
        },
        (movies) {
          _cachedData['actionMovies'] = movies;
          final currentState = state as MovieCategoriesLoaded;
          emit(currentState.copyWith(
            actionMovies: movies,
            isActionLoading: false,
            clearActionError: true,
          ));
        },
      );
    } catch (e) {
      final currentState = state as MovieCategoriesLoaded;
      emit(currentState.copyWith(
        isActionLoading: false,
        actionError: 'Failed to load action movies',
      ));
    }
    
    // Fetch Sci-Fi Movies
    try {
      final scifiResult = await searchMovies(
        SearchMoviesParams(query: 'sci-fi', page: 1),
      );
      
      scifiResult.fold(
        (failure) {
          final currentState = state as MovieCategoriesLoaded;
          emit(currentState.copyWith(
            isScifiLoading: false,
            scifiError: failure.message,
          ));
        },
        (movies) {
          _cachedData['scifiMovies'] = movies;
          final currentState = state as MovieCategoriesLoaded;
          emit(currentState.copyWith(
            scifiMovies: movies,
            isScifiLoading: false,
            clearScifiError: true,
          ));
        },
      );
    } catch (e) {
      final currentState = state as MovieCategoriesLoaded;
      emit(currentState.copyWith(
        isScifiLoading: false,
        scifiError: 'Failed to load sci-fi movies',
      ));
    }
    
    // Fetch Blockbuster Movies
    try {
      final blockbusterResult = await searchMovies(
        SearchMoviesParams(query: 'marvel', page: 1),
      );
      
      blockbusterResult.fold(
        (failure) {
          final currentState = state as MovieCategoriesLoaded;
          emit(currentState.copyWith(
            isBlockbusterLoading: false,
            blockbusterError: failure.message,
          ));
        },
        (movies) {
          _cachedData['blockbusterMovies'] = movies;
          final currentState = state as MovieCategoriesLoaded;
          emit(currentState.copyWith(
            blockbusterMovies: movies,
            isBlockbusterLoading: false,
            clearBlockbusterError: true,
          ));
        },
      );
    } catch (e) {
      final currentState = state as MovieCategoriesLoaded;
      emit(currentState.copyWith(
        isBlockbusterLoading: false,
        blockbusterError: 'Failed to load blockbuster movies',
      ));
    }
  }
}