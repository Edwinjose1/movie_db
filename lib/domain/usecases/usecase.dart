// lib/core/usecases/usecase.dart
import 'package:dartz/dartz.dart';
import 'package:movie_search_app/core/error/failures.dart';
// import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}