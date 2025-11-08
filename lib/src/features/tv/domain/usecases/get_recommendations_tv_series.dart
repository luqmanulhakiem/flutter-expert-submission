import 'package:dartz/dartz.dart';
import 'package:ditonton/src/core/common/failure.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/repositories/tv_series_repository.dart';

class GetRecommendationsTvSeries {
  final TvSeriesRepository repository;

  GetRecommendationsTvSeries(this.repository);

  Future<Either<Failure, List<Tv>>> execute(id) {
    return repository.getTvSeriesRecommendations(id);
  }
}
