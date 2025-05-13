// lib/domain/repositories/movie_repository.dart
import 'package:movie_search_app/data/models/movie_details.dart';

// import '../entities/movie_details.dart';

abstract class MovieRepository {
  Future<MovieDetails> getMovieDetails(String imdbId);
}
