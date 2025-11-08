import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mt;

class MockWatchlistMoviesBloc
    extends MockBloc<WatchlistMoviesEvent, WatchlistMoviesState>
    implements WatchlistMoviesBloc {}

void main() {
  late MockWatchlistMoviesBloc bloc;
  setUpAll(() {
    mt.registerFallbackValue(WatchlistMoviesDataLoaded());
    bloc = MockWatchlistMoviesBloc();
  });

  test("GetWatchlistMovies call WatchlistMoviesDataLoaded", () async {
    mt.when(() => bloc.state).thenReturn(WatchlistMoviesInitial());

    final usecase = GetWatchlistMovies(bloc);

    await usecase.execute();

    mt
        .verify(() => bloc.add(mt.any<WatchlistMoviesEvent>(
            that: isA<WatchlistMoviesDataLoaded>())))
        .called(1);
  });

  test('execute must success', () async {
    whenListen(bloc, const Stream<WatchlistMoviesState>.empty(),
        initialState: WatchlistMoviesInitial());
    await expectLater(GetWatchlistMovies(bloc).execute(), completes);
  });
}
