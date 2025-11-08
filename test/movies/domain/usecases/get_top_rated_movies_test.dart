import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mt;

class MockTopRatedMoviesBloc
    extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState>
    implements TopRatedMoviesBloc {}

void main() {
  late MockTopRatedMoviesBloc bloc;
  setUpAll(() {
    mt.registerFallbackValue(TopRatedMoviesDataLoaded());
    bloc = MockTopRatedMoviesBloc();
  });

  test("GetTopRatedMovies call TopRatedMoviesDataLoaded", () async {
    mt.when(() => bloc.state).thenReturn(TopRatedMoviesInitial());

    final usecase = GetTopRatedMovies(bloc);

    await usecase.execute();

    mt
        .verify(() => bloc.add(
            mt.any<TopRatedMoviesEvent>(that: isA<TopRatedMoviesDataLoaded>())))
        .called(1);
  });

  test('execute must success', () async {
    whenListen(bloc, const Stream<TopRatedMoviesState>.empty(),
        initialState: TopRatedMoviesInitial());
    await expectLater(GetTopRatedMovies(bloc).execute(), completes);
  });
}
