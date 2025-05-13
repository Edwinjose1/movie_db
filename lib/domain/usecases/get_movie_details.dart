// lib/domain/usecases/get_movie_details.dart
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../data/models/movie_details.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetails {
  final MovieRepository repository;
  
  GetMovieDetails(this.repository);
  
  Future<Either<Failure, MovieDetails>> call(String imdbId) {
    return repository.getMovieDetails(imdbId);
  }
}