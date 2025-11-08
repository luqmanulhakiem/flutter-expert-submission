import 'package:ditonton/src/core/common/constants.dart';
import 'package:ditonton/src/core/common/utils.dart';
import 'package:ditonton/src/core/routes/app_router.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/movies/movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/recommendation_movies/recommendation_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/pages/home_movie_page.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/now_playing_tv/now_playing_tv_bloc.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/recommendation_tv/recommendation_tv_bloc.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/tv_popular/tv_popular_bloc.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/tv_series/tv_series_bloc.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:async';

void main() async {
  // Capture errors from non-Flutter zones
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase with generated options
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Forward Flutter framework errors to Crashlytics
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      FirebaseCrashlytics.instance.recordFlutterError(details);
    };

    di.init();
    runApp(MyApp());
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (context) => di.locator<NowPlayingMoviesBloc>()),
        BlocProvider(create: (context) => di.locator<PopularMoviesBloc>()),
        BlocProvider(create: (context) => di.locator<WatchlistMoviesBloc>()),
        BlocProvider(
            create: (context) => di.locator<RecommendationMoviesBloc>()),
        BlocProvider(create: (context) => di.locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (context) => di.locator<MoviesBloc>()),
        BlocProvider(create: (context) => di.locator<NowPlayingTvBloc>()),
        BlocProvider(create: (context) => di.locator<TvPopularBloc>()),
        BlocProvider(create: (context) => di.locator<TopRatedTvBloc>()),
        BlocProvider(create: (context) => di.locator<TvSeriesBloc>()),
        BlocProvider(create: (context) => di.locator<RecommendationTvBloc>()),
        BlocProvider(create: (context) => di.locator<WatchlistTvBloc>()),
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
