import 'package:ditonton/src/features/about/presentation/pages/about_page.dart';
import 'package:ditonton/src/features/movie/presentation/pages/home_movie_page.dart';
import 'package:ditonton/src/features/movie/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/src/features/movie/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/src/features/movie/presentation/pages/search_page.dart';
import 'package:ditonton/src/features/movie/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/src/features/movie/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/src/features/tv/presentation/pages/home_tv_page.dart';
import 'package:ditonton/src/features/tv/presentation/pages/popular_tv_page.dart';
import 'package:ditonton/src/features/tv/presentation/pages/search_tv_page.dart';
import 'package:ditonton/src/features/tv/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton/src/features/tv/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/src/features/watchlist/presentation/pages/watchlist_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeMoviePage.ROUTE_NAME:
        return MaterialPageRoute(builder: (_) => HomeMoviePage());
      case HomeTvPage.ROUTE_NAME:
        return MaterialPageRoute(builder: (_) => HomeTvPage());
      case PopularMoviesPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
      case PopularTvPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => PopularTvPage());
      case TopRatedMoviesPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
      case TopRatedTvPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => TopRatedTvPage());
      case TvDetailPage.ROUTE_NAME:
        final id = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => TvDetailPage(id: id),
          settings: settings,
        );
      case MovieDetailPage.ROUTE_NAME:
        final id = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => MovieDetailPage(id: id),
          settings: settings,
        );
      case SearchPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => SearchPage());
      case SearchTvPage.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => SearchTvPage());
      case WatchlistMoviesPage.ROUTE_NAME:
        return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
      case WatchlistPage.ROUTE_NAME:
        return MaterialPageRoute(builder: (_) => WatchlistPage());
      case AboutPage.ROUTE_NAME:
        return MaterialPageRoute(builder: (_) => AboutPage());
      default:
        return MaterialPageRoute(
          builder: (_) {
            return Scaffold(
              body: Center(
                child: Text('Page not found :('),
              ),
            );
          },
        );
    }
  }
}
