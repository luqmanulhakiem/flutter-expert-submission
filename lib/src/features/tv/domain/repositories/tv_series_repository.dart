import 'package:dartz/dartz.dart';
import 'package:ditonton/src/core/common/failure.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv_detail.dart';

abstract class TvSeriesRepository {
  Future<Either<Failure, List<Tv>>> getNowPlayingTvSeries();
  Future<Either<Failure, List<Tv>>> getPopularTvSeries();
  Future<Either<Failure, List<Tv>>> getTopRatedTvSeries();
  Future<Either<Failure, TvDetail>> getTvSeriesDetail(int id);
  Future<Either<Failure, List<Tv>>> getTvSeriesRecommendations(int id);
  Future<Either<Failure, List<Tv>>> searchTvSeries(String query);
  Future<Either<Failure, String>> saveTvSeriesWatchlist(TvDetail tvSeries);
  Future<Either<Failure, String>> removeTvSeriesWatchlist(TvDetail tvSeries);
  Future<bool> isTvSeriesAddedToWatchlist(int id);
  Future<Either<Failure, List<Tv>>> getWatchlistTvSeries();
}
