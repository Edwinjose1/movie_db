// lib/data/datasources/movie_remote_data_source.dart - Enhanced version
import 'package:dio/dio.dart';
import '../models/movie_response_model.dart';
import '../models/movie_model.dart';
import '../models/movie_details.dart';
import '../../core/error/exceptions.dart';
import '../../config/api_config.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> searchMovies(String query, {int page = 1});
  Future<MovieDetails> getMovieDetails(String imdbId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MovieModel>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await dio.get(
        '/',
        queryParameters: {
          's': query,
          'page': page,
          'apikey': ApiConfig.apiKey,
        },
      );

      // Process successful response
      if (response.statusCode == 200) {
        final movieResponse = MovieResponseModel.fromJson(response.data);
        if (movieResponse.response == 'True') {
          return movieResponse.search ?? [];
        } else {
          // API returned success status but with an error in the response
          throw ServerException(
            message: response.data['Error'] ?? 'No movies found',
            statusCode: 200
          );
        }
      } 
      // Handle other status codes
      else {
        _handleErrorStatusCode(response.statusCode);
        // This line will only execute if _handleErrorStatusCode doesn't throw
        throw ServerException(
          message: 'Failed to load movies',
          statusCode: response.statusCode
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      // Handle any other exceptions
      throw ServerException(
        message: 'Unexpected error occurred: ${e.toString()}',
        statusCode: 0
      );
    }
  }

  @override
  Future<MovieDetails> getMovieDetails(String imdbId) async {
    try {
      final response = await dio.get(
        '/',
        queryParameters: {
          'i': imdbId,
          'apikey': ApiConfig.apiKey,
        },
      );

      if (response.statusCode == 200) {
        if (response.data['Response'] == 'True') {
          return MovieDetails.fromJson(response.data);
        } else {
          throw ServerException(
            message: response.data['Error'] ?? 'Movie details not found',
            statusCode: 200
          );
        }
      } else {
        _handleErrorStatusCode(response.statusCode);
        throw ServerException(
          message: 'Failed to load movie details',
          statusCode: response.statusCode
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error occurred: ${e.toString()}',
        statusCode: 0
      );
    }
  }

  // Helper method to handle different status codes
  void _handleErrorStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        throw ServerException(
          message: 'Bad request. Please check your input.',
          statusCode: statusCode
        );
      case 401:
        throw ServerException(
          message: 'Unauthorized. Please check your API key.',
          statusCode: statusCode
        );
      case 403:
        throw ServerException(
          message: 'Access forbidden. Please check your permissions.',
          statusCode: statusCode
        );
      case 404:
        throw ServerException(
          message: 'Resource not found.',
          statusCode: statusCode
        );
      case 429:
        throw ServerException(
          message: 'Too many requests. Please try again later.',
          statusCode: statusCode
        );
      case 500:
      case 501:
      case 502:
      case 503:
        throw ServerException(
          message: 'Server error. Please try again later.',
          statusCode: statusCode
        );
      default:
        throw ServerException(
          message: 'An error occurred while communicating with the server.',
          statusCode: statusCode
        );
    }
  }

  // Helper method to handle Dio errors
  ServerException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ServerException(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: e.response?.statusCode
        );
      case DioExceptionType.sendTimeout:
        return ServerException(
          message: 'Request timeout. Please try again later.',
          statusCode: e.response?.statusCode
        );
      case DioExceptionType.receiveTimeout:
        return ServerException(
          message: 'Response timeout. Please try again later.',
          statusCode: e.response?.statusCode
        );
      case DioExceptionType.badResponse:
        // If we have a response with status code, use the helper method
        if (e.response?.statusCode != null) {
          try {
            _handleErrorStatusCode(e.response?.statusCode);
          } catch (error) {
            if (error is ServerException) {
              return error;
            }
          }
        }
        return ServerException(
          message: 'Server returned an invalid response.',
          statusCode: e.response?.statusCode
        );
      case DioExceptionType.cancel:
        return ServerException(
          message: 'Request canceled.',
          statusCode: e.response?.statusCode
        );
      case DioExceptionType.unknown:
        if (e.message?.contains('SocketException') == true) {
          return ServerException(
            message: 'No internet connection. Please check your network.',
            statusCode: e.response?.statusCode
          );
        }
        return ServerException(
          message: e.message ?? 'An unexpected error occurred.',
          statusCode: e.response?.statusCode
        );
      default:
        return ServerException(
          message: e.message ?? 'Network error',
          statusCode: e.response?.statusCode
        );
    }
  }
}