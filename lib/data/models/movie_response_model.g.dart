// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieResponseModel _$MovieResponseModelFromJson(Map<String, dynamic> json) =>
    MovieResponseModel(
      search:
          (json['Search'] as List<dynamic>?)
              ?.map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      totalResults: json['totalResults'] as String?,
      response: json['Response'] as String,
    );

Map<String, dynamic> _$MovieResponseModelToJson(MovieResponseModel instance) =>
    <String, dynamic>{
      'Search': instance.search,
      'totalResults': instance.totalResults,
      'Response': instance.response,
    };
