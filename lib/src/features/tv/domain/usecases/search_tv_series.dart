import 'package:dartz/dartz.dart';
import 'package:ditonton/src/core/common/failure.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/repositories/tv_series_repository.dart';

class SearchTvSeries {
  final TvSeriesRepository repository;

  SearchTvSeries(this.repository);

  Future<Either<Failure, List<Tv>>> execute(String query) {
    return repository.searchTvSeries(query);
  }
}
