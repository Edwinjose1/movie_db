// lib/domain/entities/movie_details.dart
import 'package:json_annotation/json_annotation.dart';

part 'movie_details.g.dart';

@JsonSerializable()
class MovieDetails {
  @JsonKey(name: 'Title')
  final String title;
  
  @JsonKey(name: 'Year')
  final String year;
  
  @JsonKey(name: 'Rated')
  final String rated;
  
  @JsonKey(name: 'Released')
  final String released;
  
  @JsonKey(name: 'Season')
  final String? season;
  
  @JsonKey(name: 'Episode')
  final String? episode;
  
  @JsonKey(name: 'Runtime')
  final String runtime;
  
  @JsonKey(name: 'Genre')
  final String genre;
  
  @JsonKey(name: 'Director')
  final String director;
  
  @JsonKey(name: 'Writer')
  final String writer;
  
  @JsonKey(name: 'Actors')
  final String actors;
  
  @JsonKey(name: 'Plot')
  final String plot;
  
  @JsonKey(name: 'Language')
  final String language;
  
  @JsonKey(name: 'Country')
  final String country;
  
  @JsonKey(name: 'Awards')
  final String awards;
  
  @JsonKey(name: 'Poster')
  final String poster;
  
  @JsonKey(name: 'Ratings')
  final List<Rating> ratings;
  
  @JsonKey(name: 'Metascore')
  final String metascore;
  
  @JsonKey(name: 'imdbRating')
  final String imdbRating;
  
  @JsonKey(name: 'imdbVotes')
  final String imdbVotes;
  
  @JsonKey(name: 'imdbID')
  final String imdbId;
  
  @JsonKey(name: 'seriesID')
  final String? seriesId;
  
  @JsonKey(name: 'Type')
  final String type;
  
  @JsonKey(name: 'BoxOffice')
  final String? boxOffice;
  
  @JsonKey(name: 'Production')
  final String? production;
  
  @JsonKey(name: 'Response')
  final String response;

  MovieDetails({
    required this.title,
    required this.year,
    required this.rated,
    required this.released,
    this.season,
    this.episode,
    required this.runtime,
    required this.genre,
    required this.director,
    required this.writer,
    required this.actors,
    required this.plot,
    required this.language,
    required this.country,
    required this.awards,
    required this.poster,
    required this.ratings,
    required this.metascore,
    required this.imdbRating,
    required this.imdbVotes,
    required this.imdbId,
    this.seriesId,
    required this.type,
    this.boxOffice,
    this.production,
    required this.response,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) => _$MovieDetailsFromJson(json);
  
  Map<String, dynamic> toJson() => _$MovieDetailsToJson(this);
}

@JsonSerializable()
class Rating {
  @JsonKey(name: 'Source')
  final String source;
  
  @JsonKey(name: 'Value')
  final String value;

  Rating({
    required this.source,
    required this.value,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);
  
  Map<String, dynamic> toJson() => _$RatingToJson(this);
}