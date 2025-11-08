import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/popular_movies/popular_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mt;

class MockNowPlayingMoviesBloc
    extends MockBloc<PopularMoviesEvent, PopularMoviesState>
    implements PopularMoviesBloc {}

void main() {
  late MockNowPlayingMoviesBloc bloc;
  setUpAll(() {
    mt.registerFallbackValue(PopularMoviesDataLoaded());
    bloc = MockNowPlayingMoviesBloc();
  });

  test("GetPopularMovies call PopularMoviesDataLoaded", () async {
    mt.when(() => bloc.state).thenReturn(PopularMoviesInitial());

    final usecase = GetPopularMovies(bloc);

    await usecase.execute();

    mt
        .verify(() => bloc.add(
            mt.any<PopularMoviesEvent>(that: isA<PopularMoviesDataLoaded>())))
        .called(1);
  });

  test('execute must success', () async {
    whenListen(bloc, const Stream<PopularMoviesState>.empty(),
        initialState: PopularMoviesInitial());
    await expectLater(GetPopularMovies(bloc).execute(), completes);
  });
}
