// lib/presentation/bloc/movie_details/movie_details_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_app/core/error/error_handler.dart';
import '../../../domain/usecases/get_movie_details.dart';
import 'movie_details_event.dart';
import 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final GetMovieDetails getMovieDetails;
  
  MovieDetailsBloc({required this.getMovieDetails}) : super(MovieDetailsInitial()) {
    on<FetchMovieDetailsEvent>(_onFetchMovieDetails);
  }
  
Future<void> _onFetchMovieDetails(
  FetchMovieDetailsEvent event,
  Emitter<MovieDetailsState> emit,
) async {
  emit(MovieDetailsLoading());
  try {
    final result = await getMovieDetails(event.imdbId);
    
    result.fold(
      (failure) => emit(MovieDetailsError(message: ErrorHandler.getErrorMessage(failure))),
      (movieDetails) => emit(MovieDetailsLoaded(movieDetails: movieDetails))
    );
  } catch (e) {
    emit(MovieDetailsError(message: ErrorHandler.handleException(e)));
  }
}

}