// lib/presentation/bloc/movie_search/movie_search_event.dart
import 'package:equatable/equatable.dart';

abstract class MovieSearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}
// Add this to movie_search_event.dart
class ResetSearchEvent extends MovieSearchEvent {}
class SearchMoviesEvent extends MovieSearchEvent {
  final String query;
  final int page;

  SearchMoviesEvent({required this.query, this.page = 1});

  @override
  List<Object> get props => [query, page];
}

class LoadMoreMoviesEvent extends MovieSearchEvent {
  final String query;
  final int page;

  LoadMoreMoviesEvent({required this.query, required this.page});

  @override
  List<Object> get props => [query, page];
}