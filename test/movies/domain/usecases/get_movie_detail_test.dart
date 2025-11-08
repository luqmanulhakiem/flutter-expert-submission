import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/movies/movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mt;

class MockMoviesBloc extends MockBloc<MoviesEvent, MoviesState>
    implements MoviesBloc {}

void main() {
  late MockMoviesBloc bloc;
  setUpAll(() {
    mt.registerFallbackValue(MoviesDataSingleLoaded(id: 1));
    bloc = MockMoviesBloc();
  });

  test("GetMovies call MoviesDataLoaded", () async {
    mt.when(() => bloc.state).thenReturn(MoviesInitial());

    final usecase = GetMovieDetail(bloc);

    await usecase.execute(1);

    mt
        .verify(() =>
            bloc.add(mt.any<MoviesEvent>(that: isA<MoviesDataSingleLoaded>())))
        .called(1);
  });

  test('execute must success', () async {
    whenListen(bloc, const Stream<MoviesState>.empty(),
        initialState: MoviesInitial());
    await expectLater(GetMovieDetail(bloc).execute(1), completes);
  });
}
