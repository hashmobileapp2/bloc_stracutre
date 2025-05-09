import 'package:dartz/dartz.dart';

import '../entities/app_error.dart';
import '../entities/movie_detail_entity.dart';
import '../entities/movie_params.dart';
import '../repositories/network_repository.dart';
import 'usecase.dart';

class GetMovieDetail extends UseCase<MovieDetailEntity, MovieParams> {
  final MovieRepository repository;

  GetMovieDetail(this.repository);

  @override
  Future<Either<AppError, MovieDetailEntity>> call(
      MovieParams movieParams) async {
    return await repository.getMovieDetail(movieParams.id);
  }
}
