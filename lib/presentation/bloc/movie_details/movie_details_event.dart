// lib/presentation/bloc/movie_details/movie_details_event.dart
abstract class MovieDetailsEvent {}

class FetchMovieDetailsEvent extends MovieDetailsEvent {
  final String imdbId;
  
  FetchMovieDetailsEvent({required this.imdbId});
}
