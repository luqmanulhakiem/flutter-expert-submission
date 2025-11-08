import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/movies/movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/recommendation_movies/recommendation_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mc;

import '../../dummy_data/dummy_objects.dart';

class MockMoviesBloc extends MockBloc<MoviesEvent, MoviesState>
    implements MoviesBloc {}

class MockRecommendationMoviesBloc
    extends MockBloc<RecommendationMoviesEvent, RecommendationMoviesState>
    implements RecommendationMoviesBloc {}

class MockWatchlistMoviesBloc
    extends MockBloc<WatchlistMoviesEvent, WatchlistMoviesState>
    implements WatchlistMoviesBloc {}

void main() {
  late MoviesBloc moviesBloc;
  late RecommendationMoviesBloc recommendationMoviesBloc;
  late WatchlistMoviesBloc watchlistMoviesBloc;

  setUp(() {
    moviesBloc = MockMoviesBloc();
    recommendationMoviesBloc = MockRecommendationMoviesBloc();
    watchlistMoviesBloc = MockWatchlistMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MoviesBloc>.value(value: moviesBloc),
        BlocProvider<RecommendationMoviesBloc>.value(
            value: recommendationMoviesBloc),
        BlocProvider<WatchlistMoviesBloc>.value(value: watchlistMoviesBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    mc
        .when(() => moviesBloc.state)
        .thenReturn(MoviesSingleSuccess(data: testMovieDetail));
    whenListen(
      moviesBloc,
      Stream.fromIterable([MoviesSingleSuccess(data: testMovieDetail)]),
      initialState: MoviesSingleSuccess(data: testMovieDetail),
    );

    mc
        .when(() => recommendationMoviesBloc.state)
        .thenReturn(RecommendationMoviesSuccess(data: []));
    whenListen(
      recommendationMoviesBloc,
      Stream.fromIterable([RecommendationMoviesSuccess(data: [])]),
      initialState: RecommendationMoviesSuccess(data: []),
    );

    mc
        .when(() => watchlistMoviesBloc.state)
        .thenReturn(WatchlistMoviesSuccess(isAddedToWatchlist: false));
    whenListen(
      watchlistMoviesBloc,
      Stream.fromIterable([
        WatchlistMoviesSuccess(isAddedToWatchlist: false),
        WatchlistMoviesActionSuccess(message: 'Added to Watchlist'),
      ]),
      initialState: WatchlistMoviesSuccess(isAddedToWatchlist: false),
    );

    // build widget
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.pump(); // let Bloc rebuild

    // assert
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    mc
        .when(() => moviesBloc.state)
        .thenReturn(MoviesSingleSuccess(data: testMovieDetail));
    whenListen(
      moviesBloc,
      Stream.fromIterable([MoviesSingleSuccess(data: testMovieDetail)]),
      initialState: MoviesSingleSuccess(data: testMovieDetail),
    );

    mc
        .when(() => recommendationMoviesBloc.state)
        .thenReturn(RecommendationMoviesSuccess(data: []));
    whenListen(
      recommendationMoviesBloc,
      Stream.fromIterable([RecommendationMoviesSuccess(data: [])]),
      initialState: RecommendationMoviesSuccess(data: []),
    );

    mc
        .when(() => watchlistMoviesBloc.state)
        .thenReturn(WatchlistMoviesSuccess(isAddedToWatchlist: true));
    whenListen(
      watchlistMoviesBloc,
      Stream.fromIterable([
        WatchlistMoviesSuccess(isAddedToWatchlist: true),
        WatchlistMoviesActionSuccess(message: 'Added to Watchlist'),
      ]),
      initialState: WatchlistMoviesSuccess(isAddedToWatchlist: true),
    );

    // build widget
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.pump(); // let Bloc rebuild

    // assert
    expect(find.byIcon(Icons.check), findsOneWidget);

    final watchlistButton = find.byType(ElevatedButton);
    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });
}
