import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mt;

class MockNowPlayingMoviesBloc
    extends MockBloc<NowPlayingMoviesEvent, NowPlayingMoviesState>
    implements NowPlayingMoviesBloc {}

void main() {
  late MockNowPlayingMoviesBloc bloc;
  setUpAll(() {
    mt.registerFallbackValue(NowPlayingMoviesDataLoaded());
    bloc = MockNowPlayingMoviesBloc();
  });

  test("GetNowPlayingMovies call nowPlayingMoviesDataLoaded", () async {
    mt.when(() => bloc.state).thenReturn(NowPlayingMoviesInitial());

    final usecase = GetNowPlayingMovies(bloc);

    await usecase.execute();

    mt
        .verify(() => bloc.add(mt.any<NowPlayingMoviesEvent>(
            that: isA<NowPlayingMoviesDataLoaded>())))
        .called(1);
  });

  test('execute must success', () async {
    whenListen(bloc, const Stream<NowPlayingMoviesState>.empty(),
        initialState: NowPlayingMoviesInitial());
    await expectLater(GetNowPlayingMovies(bloc).execute(), completes);
  });
}
