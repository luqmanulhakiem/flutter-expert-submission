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
import 'package:ditonton/src/features/movie/presentation/blocs/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/src/features/movie/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/src/features/movie/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/src/features/movie/presentation/provider/watchlist_movie_notifier.dart';
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
import 'package:ditonton/src/features/tv/presentation/provider/popular_tv_notifier.dart';
import 'package:ditonton/src/features/tv/presentation/provider/top_rated_tv_notifier.dart';
import 'package:ditonton/src/features/tv/presentation/provider/tv_search_notifier.dart';
import 'package:ditonton/src/features/tv/presentation/provider/tv_series_detail_notifier.dart';
import 'package:ditonton/src/features/tv/presentation/provider/tv_series_list_notifier.dart';
import 'package:ditonton/src/features/tv/presentation/provider/watch_list_tv_notifer.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(
    () => TvSeriesListNotifier(
      getNowPlayingTvSeries: locator(),
      getPopularTvSeries: locator(),
      getTopRatedTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesDetailNotifier(
      getDetailTvSeries: locator(),
      getRecommendationsTvSeries: locator(),
      getWatchlistStatusTvSeries: locator(),
      saveWatchlistTvSeries: locator(),
      removeWatchlistTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchNotifier(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSearchNotifier(
      searchTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTvNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTvNotifier(
      getTopRatedTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchListTvNotifer(
      getWatchlistTvSeries: locator(),
    ),
  );

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

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
}
