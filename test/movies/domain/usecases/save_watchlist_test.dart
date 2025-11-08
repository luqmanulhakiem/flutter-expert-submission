import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/movie/domain/usecases/save_watchlist.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mt;

import '../../dummy_data/dummy_objects.dart';

class MockWatchlistMoviesBloc
    extends MockBloc<WatchlistMoviesEvent, WatchlistMoviesState>
    implements WatchlistMoviesBloc {}

void main() {
  late MockWatchlistMoviesBloc bloc;
  setUpAll(() {
    mt.registerFallbackValue(WatchlistMoviesDataStored(data: testMovieDetail));
    bloc = MockWatchlistMoviesBloc();
  });

  test("SaveWatchlist call WatchlistMoviesDataStored", () async {
    mt.when(() => bloc.state).thenReturn(WatchlistMoviesInitial());

    final usecase = SaveWatchlist(bloc);

    await usecase.execute(testMovieDetail);

    mt
        .verify(() => bloc.add(mt.any<WatchlistMoviesEvent>(
            that: isA<WatchlistMoviesDataStored>())))
        .called(1);
  });

  test('execute must success', () async {
    whenListen(bloc, const Stream<WatchlistMoviesState>.empty(),
        initialState: TopRatedMoviesInitial());
    await expectLater(SaveWatchlist(bloc).execute(testMovieDetail), completes);
  });
}
