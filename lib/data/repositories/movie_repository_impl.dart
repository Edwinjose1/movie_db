// lib/data/repositories/movie_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/network_info.dart';
import '../datasources/movie_remote_data_source.dart';
import '../../data/models/movie_details.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

// lib/data/repositories/movie_repository_impl.dart
@override
Future<Either<Failure, List<Movie>>> searchMovies(String query, {int page = 1}) async {
  if (await networkInfo.isConnected) {
    try {
      final remoteMovies = await remoteDataSource.searchMovies(query, page: page);
      return Right(remoteMovies);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  } else {
    return Left(NetworkFailure(message: 'No internet connection'));
  }
}

@override
Future<Either<Failure, MovieDetails>> getMovieDetails(String imdbId) async {
  if (await networkInfo.isConnected) {
    try {
      final movieDetails = await remoteDataSource.getMovieDetails(imdbId);
      return Right(movieDetails);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  } else {
    return Left(NetworkFailure(message: 'No internet connection'));
  }
}
}