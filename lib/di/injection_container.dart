// lib/di/injection_container.dart
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../core/network/dio_client.dart';
import '../core/network/network_info.dart';
import '../data/datasources/movie_remote_data_source.dart';
import '../data/repositories/movie_repository_impl.dart';
import '../domain/repositories/movie_repository.dart';
import '../domain/usecases/search_movies.dart';
import '../domain/usecases/get_movie_details.dart'; // Add this import
import '../presentation/bloc/movie_search/movie_search_bloc.dart';
import '../presentation/bloc/movie_categories/movie_categories_bloc.dart';
import '../presentation/bloc/movie_details/movie_details_bloc.dart'; // Add this import
import '../config/api_config.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(
    () => MovieSearchBloc(searchMovies: sl()),
  );
  
  sl.registerFactory(
    () => MovieCategoriesBloc(searchMovies: sl()),
  );
  
  // Add Movie Details BLoC
  sl.registerFactory(
    () => MovieDetailsBloc(getMovieDetails: sl()),
  );
  
  // Use cases
  sl.registerLazySingleton(() => SearchMovies(sl()));
  sl.registerLazySingleton(() => GetMovieDetails(sl())); // Add GetMovieDetails use case

  // Repository
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(dio: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  // External
  sl.registerLazySingleton(() {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    return DioClient(dio).dio;
  });
  
  sl.registerLazySingleton(() => InternetConnectionChecker());
}