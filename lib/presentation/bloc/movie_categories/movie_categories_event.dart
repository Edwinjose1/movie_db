// lib/presentation/bloc/movie_categories/movie_categories_event.dart
abstract class MovieCategoriesEvent {}

class FetchAllCategoriesEvent extends MovieCategoriesEvent {}

class RetryFetchCategoryEvent extends MovieCategoriesEvent {
  final String category;
  
  RetryFetchCategoryEvent({required this.category});
}