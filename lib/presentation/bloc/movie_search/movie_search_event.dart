// lib/presentation/bloc/movie_search/movie_search_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class MovieSearchState extends Equatable {
  const MovieSearchState();
  
  @override
  List<Object> get props => [];
}

class MovieSearchInitial extends MovieSearchState {}

class MovieSearchLoading extends MovieSearchState {}

class MovieSearchLoadingMore extends MovieSearchState {
  final List<Movie> currentMovies;
  
  const MovieSearchLoadingMore({required this.currentMovies});
  
  @override
  List<Object> get props => [currentMovies];
}

class MovieSearchLoaded extends MovieSearchState {
  final List<Movie> movies;
  final bool hasReachedEnd;
  final int currentPage;
  final String currentQuery;
  
  const MovieSearchLoaded({
    required this.movies,
    required this.hasReachedEnd,
    required this.currentPage,
    required this.currentQuery,
  });
  
  @override
  List<Object> get props => [movies, hasReachedEnd, currentPage, currentQuery];
}
class MovieSearchError extends MovieSearchState {
  final String message;
  final bool isMinLengthError;

  const MovieSearchError({
    required this.message,
    this.isMinLengthError = false,
  });

  @override
  List<Object> get props => [message, isMinLengthError];
}