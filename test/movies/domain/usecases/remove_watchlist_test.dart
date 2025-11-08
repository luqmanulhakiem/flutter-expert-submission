import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/movie/domain/usecases/remove_watchlist.dart';
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
    mt.registerFallbackValue(WatchlistMoviesDataRemoved(data: testMovieDetail));
    bloc = MockWatchlistMoviesBloc();
  });

  test("RemoveWatchlist call WatchlistMoviesDataRemoved", () async {
    mt.when(() => bloc.state).thenReturn(WatchlistMoviesInitial());

    final usecase = RemoveWatchlist(bloc);

    await usecase.execute(testMovieDetail);

    mt
        .verify(() => bloc.add(mt.any<WatchlistMoviesEvent>(
            that: isA<WatchlistMoviesDataRemoved>())))
        .called(1);
  });

  test('execute must success', () async {
    whenListen(bloc, const Stream<WatchlistMoviesState>.empty(),
        initialState: WatchlistMoviesInitial());
    await expectLater(
        RemoveWatchlist(bloc).execute(testMovieDetail), completes);
  });
}
