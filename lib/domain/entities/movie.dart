// lib/domain/entities/movie.dart
import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String title;
  final String year;
  final String imdbId;
  final String type;
  final String poster;

  const Movie({
    required this.title,
    required this.year,
    required this.imdbId,
    required this.type,
    required this.poster,
  });

  @override
  List<Object> get props => [imdbId];
}