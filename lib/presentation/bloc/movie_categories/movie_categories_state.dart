// lib/presentation/bloc/movie_categories/movie_categories_state.dart
abstract class MovieCategoriesState {}

class MovieCategoriesInitial extends MovieCategoriesState {}

class MovieCategoriesLoading extends MovieCategoriesState {}

class MovieCategoriesLoaded extends MovieCategoriesState {
  final List<dynamic> latestMovies;
  final List<dynamic> actionMovies;
  final List<dynamic> scifiMovies;
  final List<dynamic> blockbusterMovies;
  
  final bool isLatestLoading;
  final bool isActionLoading;
  final bool isScifiLoading;
  final bool isBlockbusterLoading;
  
  final String? latestError;
  final String? actionError;
  final String? scifiError;
  final String? blockbusterError;

  MovieCategoriesLoaded({
    this.latestMovies = const [],
    this.actionMovies = const [],
    this.scifiMovies = const [],
    this.blockbusterMovies = const [],
    this.isLatestLoading = false,
    this.isActionLoading = false,
    this.isScifiLoading = false,
    this.isBlockbusterLoading = false,
    this.latestError,
    this.actionError,
    this.scifiError,
    this.blockbusterError,
  });

  MovieCategoriesLoaded copyWith({
    List<dynamic>? latestMovies,
    List<dynamic>? actionMovies,
    List<dynamic>? scifiMovies,
    List<dynamic>? blockbusterMovies,
    bool? isLatestLoading,
    bool? isActionLoading,
    bool? isScifiLoading,
    bool? isBlockbusterLoading,
    String? latestError,
    String? actionError,
    String? scifiError,
    String? blockbusterError,
    bool clearLatestError = false,
    bool clearActionError = false,
    bool clearScifiError = false,
    bool clearBlockbusterError = false,
  }) {
    return MovieCategoriesLoaded(
      latestMovies: latestMovies ?? this.latestMovies,
      actionMovies: actionMovies ?? this.actionMovies,
      scifiMovies: scifiMovies ?? this.scifiMovies,
      blockbusterMovies: blockbusterMovies ?? this.blockbusterMovies,
      isLatestLoading: isLatestLoading ?? this.isLatestLoading,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      isScifiLoading: isScifiLoading ?? this.isScifiLoading,
      isBlockbusterLoading: isBlockbusterLoading ?? this.isBlockbusterLoading,
      latestError: clearLatestError ? null : (latestError ?? this.latestError),
      actionError: clearActionError ? null : (actionError ?? this.actionError),
      scifiError: clearScifiError ? null : (scifiError ?? this.scifiError),
      blockbusterError: clearBlockbusterError ? null : (blockbusterError ?? this.blockbusterError),
    );
  }
}

class MovieCategoriesError extends MovieCategoriesState {
  final String message;

  MovieCategoriesError({required this.message});
}