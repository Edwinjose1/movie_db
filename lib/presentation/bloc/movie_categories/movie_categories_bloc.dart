// lib/presentation/bloc/movie_categories/movie_categories_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/error_handler.dart';
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
    on<RetryFetchCategoryEvent>(_onRetryFetchCategory);
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
    
    // Fetch all categories in parallel for better performance
    await Future.wait([
      _fetchLatestMovies(emit),
      _fetchActionMovies(emit),
      _fetchSciFiMovies(emit),
      _fetchBlockbusterMovies(emit),
    ]);
  }

  Future<void> _onRetryFetchCategory(
    RetryFetchCategoryEvent event,
    Emitter<MovieCategoriesState> emit,
  ) async {
    final currentState = state as MovieCategoriesLoaded;
    
    switch (event.category) {
      case 'latest':
        emit(currentState.copyWith(isLatestLoading: true, clearLatestError: true));
        await _fetchLatestMovies(emit);
        break;
      case 'action':
        emit(currentState.copyWith(isActionLoading: true, clearActionError: true));
        await _fetchActionMovies(emit);
        break;
      case 'scifi':
        emit(currentState.copyWith(isScifiLoading: true, clearScifiError: true));
        await _fetchSciFiMovies(emit);
        break;
      case 'blockbuster':
        emit(currentState.copyWith(isBlockbusterLoading: true, clearBlockbusterError: true));
        await _fetchBlockbusterMovies(emit);
        break;
    }
  }

  Future<void> _fetchLatestMovies(Emitter<MovieCategoriesState> emit) async {
    try {
      final latestResult = await searchMovies(
        SearchMoviesParams(query: '2025', page: 1),
      );
      
      latestResult.fold(
        (failure) {
          final currentState = state as MovieCategoriesLoaded;
          emit(currentState.copyWith(
            isLatestLoading: false,
            latestError: ErrorHandler.getErrorMessage(failure),
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
        latestError: ErrorHandler.handleException(e),
      ));
    }
  }

  Future<void> _fetchActionMovies(Emitter<MovieCategoriesState> emit) async {
    try {
      final actionResult = await searchMovies(
        SearchMoviesParams(query: 'action 2024', page: 1),
      );
      
      actionResult.fold(
        (failure) {
          final currentState = state as MovieCategoriesLoaded;
          emit(currentState.copyWith(
            isActionLoading: false,
            actionError: ErrorHandler.getErrorMessage(failure),
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
        actionError: ErrorHandler.handleException(e),
      ));
    }
  }

  Future<void> _fetchSciFiMovies(Emitter<MovieCategoriesState> emit) async {
    try {
      final scifiResult = await searchMovies(
        SearchMoviesParams(query: 'sci-fi', page: 1),
      );
      
      scifiResult.fold(
        (failure) {
          final currentState = state as MovieCategoriesLoaded;
          emit(currentState.copyWith(
            isScifiLoading: false,
            scifiError: ErrorHandler.getErrorMessage(failure),
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
        scifiError: ErrorHandler.handleException(e),
      ));
    }
  }

  Future<void> _fetchBlockbusterMovies(Emitter<MovieCategoriesState> emit) async {
    try {
      final blockbusterResult = await searchMovies(
        SearchMoviesParams(query: 'marvel', page: 1),
      );
      
      blockbusterResult.fold(
        (failure) {
          final currentState = state as MovieCategoriesLoaded;
          emit(currentState.copyWith(
            isBlockbusterLoading: false,
            blockbusterError: ErrorHandler.getErrorMessage(failure),
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
        blockbusterError: ErrorHandler.handleException(e),
      ));
    }
  }
}