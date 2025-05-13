// lib/presentation/bloc/movie_details/movie_details_state.dart
import '../../../data/models/movie_details.dart';

abstract class MovieDetailsState {}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final MovieDetails movieDetails;
  
  MovieDetailsLoaded({required this.movieDetails});
}

class MovieDetailsError extends MovieDetailsState {
  final String message;
  
  MovieDetailsError({required this.message});
}