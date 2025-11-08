import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/recommendation_movies/recommendation_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mt;

class MockRecommendationMoviesBloc
    extends MockBloc<RecommendationMoviesEvent, RecommendationMoviesState>
    implements RecommendationMoviesBloc {}

void main() {
  late MockRecommendationMoviesBloc bloc;
  setUpAll(() {
    mt.registerFallbackValue(RecommendationMoviesDataLoaded(id: 1));
    bloc = MockRecommendationMoviesBloc();
  });

  test("GetRecommendationMovies call RecommendationMoviesDataLoaded", () async {
    mt.when(() => bloc.state).thenReturn(RecommendationMoviesInitial());

    final usecase = GetMovieRecommendations(bloc);

    await usecase.execute(1);

    mt
        .verify(() => bloc.add(mt.any<RecommendationMoviesEvent>(
            that: isA<RecommendationMoviesDataLoaded>())))
        .called(1);
  });

  test('execute must success', () async {
    whenListen(bloc, const Stream<RecommendationMoviesState>.empty(),
        initialState: RecommendationMoviesInitial());
    await expectLater(GetMovieRecommendations(bloc).execute(1), completes);
  });
}
