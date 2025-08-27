import 'package:ditonton/src/core/common/constants.dart';
import 'package:ditonton/src/core/common/utils.dart';
import 'package:ditonton/src/core/routes/app_router.dart';
import 'package:ditonton/src/features/movie/presentation/pages/home_movie_page.dart';
import 'package:ditonton/src/features/movie/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/src/features/movie/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/src/features/movie/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/src/features/movie/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/src/features/movie/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/src/features/movie/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/src/features/tv/presentation/provider/popular_tv_notifier.dart';
import 'package:ditonton/src/features/tv/presentation/provider/top_rated_tv_notifier.dart';
import 'package:ditonton/src/features/tv/presentation/provider/tv_search_notifier.dart';
import 'package:ditonton/src/features/tv/presentation/provider/tv_series_detail_notifier.dart';
import 'package:ditonton/src/features/tv/presentation/provider/tv_series_list_notifier.dart';
import 'package:ditonton/src/features/tv/presentation/provider/watch_list_tv_notifer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvSeriesListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvSeriesDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularTvNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedTvNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchListTvNotifer>(),
        ),
      ],
      child: MaterialApp(
        title: 'ElqiFlix',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
