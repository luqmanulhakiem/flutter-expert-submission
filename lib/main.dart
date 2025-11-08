import 'package:ditonton/src/core/common/constants.dart';
import 'package:ditonton/src/core/common/utils.dart';
import 'package:ditonton/src/core/routes/app_router.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/movies/movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/recommendation_movies/recommendation_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/pages/home_movie_page.dart';
import 'package:ditonton/src/features/movie/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/src/features/movie/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/src/features/tv/presentation/provider/popular_tv_notifier.dart';
import 'package:ditonton/src/features/tv/presentation/provider/top_rated_tv_notifier.dart';
import 'package:ditonton/src/features/tv/presentation/provider/tv_search_notifier.dart';
import 'package:ditonton/src/features/tv/presentation/provider/tv_series_detail_notifier.dart';
import 'package:ditonton/src/features/tv/presentation/provider/tv_series_list_notifier.dart';
import 'package:ditonton/src/features/tv/presentation/provider/watch_list_tv_notifer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvSeriesListNotifier>(),
        ),
        BlocProvider(create: (context) => di.locator<NowPlayingMoviesBloc>()),
        BlocProvider(create: (context) => di.locator<PopularMoviesBloc>()),
        BlocProvider(
            create: (context) => di.locator<RecommendationMoviesBloc>()),
        BlocProvider(create: (context) => di.locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (context) => di.locator<MoviesBloc>()),
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
