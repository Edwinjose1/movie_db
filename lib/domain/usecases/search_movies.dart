// lib/domain/usecases/search_movies.dart
import 'package:dartz/dartz.dart';
import 'package:movie_search_app/domain/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';
import '../../core/error/failures.dart';

class SearchMoviesParams {
  final String query;
  final int page;

  SearchMoviesParams({required this.query, required this.page});
}

class SearchMovies implements UseCase<List<Movie>, SearchMoviesParams> {
  final MovieRepository repository;

  SearchMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(SearchMoviesParams params) {
    // Use named parameter for page to match the repository interface
    return repository.searchMovies(params.query, page: params.page);
  }
}