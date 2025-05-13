// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetails _$MovieDetailsFromJson(Map<String, dynamic> json) => MovieDetails(
  title: json['Title'] as String,
  year: json['Year'] as String,
  rated: json['Rated'] as String,
  released: json['Released'] as String,
  season: json['Season'] as String?,
  episode: json['Episode'] as String?,
  runtime: json['Runtime'] as String,
  genre: json['Genre'] as String,
  director: json['Director'] as String,
  writer: json['Writer'] as String,
  actors: json['Actors'] as String,
  plot: json['Plot'] as String,
  language: json['Language'] as String,
  country: json['Country'] as String,
  awards: json['Awards'] as String,
  poster: json['Poster'] as String,
  ratings:
      (json['Ratings'] as List<dynamic>)
          .map((e) => Rating.fromJson(e as Map<String, dynamic>))
          .toList(),
  metascore: json['Metascore'] as String,
  imdbRating: json['imdbRating'] as String,
  imdbVotes: json['imdbVotes'] as String,
  imdbId: json['imdbID'] as String,
  seriesId: json['seriesID'] as String?,
  type: json['Type'] as String,
  boxOffice: json['BoxOffice'] as String?,
  production: json['Production'] as String?,
  response: json['Response'] as String,
);

Map<String, dynamic> _$MovieDetailsToJson(MovieDetails instance) =>
    <String, dynamic>{
      'Title': instance.title,
      'Year': instance.year,
      'Rated': instance.rated,
      'Released': instance.released,
      'Season': instance.season,
      'Episode': instance.episode,
      'Runtime': instance.runtime,
      'Genre': instance.genre,
      'Director': instance.director,
      'Writer': instance.writer,
      'Actors': instance.actors,
      'Plot': instance.plot,
      'Language': instance.language,
      'Country': instance.country,
      'Awards': instance.awards,
      'Poster': instance.poster,
      'Ratings': instance.ratings,
      'Metascore': instance.metascore,
      'imdbRating': instance.imdbRating,
      'imdbVotes': instance.imdbVotes,
      'imdbID': instance.imdbId,
      'seriesID': instance.seriesId,
      'Type': instance.type,
      'BoxOffice': instance.boxOffice,
      'Production': instance.production,
      'Response': instance.response,
    };

Rating _$RatingFromJson(Map<String, dynamic> json) =>
    Rating(source: json['Source'] as String, value: json['Value'] as String);

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
  'Source': instance.source,
  'Value': instance.value,
};
