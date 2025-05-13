// lib/data/models/movie_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/movie.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel extends Movie {
   @override
  @JsonKey(name: 'Title')
  
  // ignore: overridden_fields
  final String title;
   @override
  @JsonKey(name: 'Year')
   // ignore: overridden_fields
  final String year;
  
  @override
  @JsonKey(name: 'imdbID')
  // ignore: overridden_fields
  final String imdbId;
  
  @override
  @JsonKey(name: 'Type')
  // ignore: overridden_fields
  final String type;
  
  @override
  @JsonKey(name: 'Poster')
  // ignore: overridden_fields
  final String poster;

  const MovieModel({
    required this.title,
    required this.year,
    required this.imdbId,
    required this.type,
    required this.poster,
  }) : super(
          title: title,
          year: year,
          imdbId: imdbId,
          type: type,
          poster: poster,
        );

  factory MovieModel.fromJson(Map<String, dynamic> json) => 
      _$MovieModelFromJson(json);
      
  Map<String, dynamic> toJson() => _$MovieModelToJson(this);
}