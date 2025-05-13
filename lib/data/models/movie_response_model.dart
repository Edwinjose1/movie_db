// lib/data/models/movie_response_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'movie_model.dart';

part 'movie_response_model.g.dart';

@JsonSerializable()
class MovieResponseModel {
  @JsonKey(name: 'Search')
  final List<MovieModel>? search;
  
  @JsonKey(name: 'totalResults')
  final String? totalResults;
  
  @JsonKey(name: 'Response')
  final String response;

  const MovieResponseModel({
    this.search,
    this.totalResults,
    required this.response,
  });

  factory MovieResponseModel.fromJson(Map<String, dynamic> json) => 
      _$MovieResponseModelFromJson(json);
      
  Map<String, dynamic> toJson() => _$MovieResponseModelToJson(this);
}