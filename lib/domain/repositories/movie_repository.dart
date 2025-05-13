// lib/domain/repositories/movie_repository.dart
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../data/models/movie_details.dart';
import '../entities/movie.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> searchMovies(String query, {int page = 1});
  Future<Either<Failure, MovieDetails>> getMovieDetails(String imdbId);
}