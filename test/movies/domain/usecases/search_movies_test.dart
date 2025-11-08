import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/movie/domain/usecases/search_movies.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/movies/movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mt;

class MockMoviesBloc extends MockBloc<MoviesEvent, MoviesState>
    implements MoviesBloc {}

void main() {
  late MockMoviesBloc bloc;
  setUpAll(() {
    mt.registerFallbackValue(MoviesDataSearched(query: "Spiderman"));
    bloc = MockMoviesBloc();
  });

  test("SearchMovies call MoviesDataSearched", () async {
    mt.when(() => bloc.state).thenReturn(MoviesInitial());

    final usecase = SearchMovies(bloc);

    await usecase.execute("Spiderman");

    mt
        .verify(() =>
            bloc.add(mt.any<MoviesEvent>(that: isA<MoviesDataSearched>())))
        .called(1);
  });

  test('execute must success', () async {
    whenListen(bloc, const Stream<MoviesState>.empty(),
        initialState: MoviesInitial());
    await expectLater(SearchMovies(bloc).execute("Spiderman"), completes);
  });
}
