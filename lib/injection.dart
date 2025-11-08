import 'package:ditonton/src/core/utils/ssl_pinning.dart';
import 'package:ditonton/src/features/movie/data/datasources/db/database_helper.dart';
import 'package:ditonton/src/features/movie/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/src/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/src/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/src/features/movie/domain/repositories/movie_repository.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/src/features/movie/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/src/features/movie/domain/usecases/save_watchlist.dart';
import 'package:ditonton/src/features/movie/domain/usecases/search_movies.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/movies/movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/recommendation_movies/recommendation_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:ditonton/src/features/tv/data/datasources/tv_series_local_data_source.dart';
import 'package:ditonton/src/features/tv/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/src/features/tv/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/src/features/tv/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_detail_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_recommendations_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/search_tv_series.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/now_playing_tv/now_playing_tv_bloc.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/recommendation_tv/recommendation_tv_bloc.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/tv_popular/tv_popular_bloc.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/tv_series/tv_series_bloc.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetNowPlayingTvSeries(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetDetailTvSeries(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => GetRecommendationsTvSeries(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => GetWatchlistStatusTvSeries(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvSeriesRepository>(
    () => TvSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
      () => TvSeriesRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
      () => TvSeriesLocalDataSourceImpl(databaseHelper: locator()));

  // Blocs
  locator.registerLazySingleton(() => NowPlayingMoviesBloc(locator()));
  locator.registerLazySingleton(() => PopularMoviesBloc(locator()));
  locator.registerLazySingleton(() => TopRatedMoviesBloc(locator()));
  locator.registerLazySingleton(() => MoviesBloc(locator()));
  locator.registerLazySingleton(() => RecommendationMoviesBloc(locator()));
  locator.registerLazySingleton(() => WatchlistMoviesBloc(locator()));

  locator.registerLazySingleton(() => NowPlayingTvBloc(locator()));
  locator.registerLazySingleton(() => TvPopularBloc(locator()));
  locator.registerLazySingleton(() => TopRatedTvBloc(locator()));
  locator.registerLazySingleton(() => TvSeriesBloc(locator()));
  locator.registerLazySingleton(() => RecommendationTvBloc(locator()));
  locator.registerLazySingleton(() => WatchlistTvBloc(locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => HttpSSLPinning.client);
}
