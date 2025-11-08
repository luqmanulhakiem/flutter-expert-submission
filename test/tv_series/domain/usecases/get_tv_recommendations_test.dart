import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_recommendations_tv_series.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/recommendation_tv/recommendation_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mt;

class MockRecommendationTvBloc
    extends MockBloc<RecommendationTvEvent, RecommendationTvState>
    implements RecommendationTvBloc {}

void main() {
  late MockRecommendationTvBloc bloc;
  setUpAll(() {
    mt.registerFallbackValue(RecommendationTvDataLoaded(id: 1));
    bloc = MockRecommendationTvBloc();
  });

  test("GetRecommendationsTvSeries call RecommendationTvDataLoaded", () async {
    mt.when(() => bloc.state).thenReturn(RecommendationTvInitial());

    final usecase = GetRecommendationsTvSeries(bloc);

    await usecase.execute(1);

    mt
        .verify(() => bloc.add(mt.any<RecommendationTvEvent>(
            that: isA<RecommendationTvDataLoaded>())))
        .called(1);
  });

  test('execute must success', () async {
    whenListen(bloc, const Stream<RecommendationTvState>.empty(),
        initialState: RecommendationTvInitial());
    await expectLater(GetRecommendationsTvSeries(bloc).execute(1), completes);
  });
}
