import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mt;

class MockTopRatedTvBloc extends MockBloc<TopRatedTvEvent, TopRatedTvState>
    implements TopRatedTvBloc {}

void main() {
  late MockTopRatedTvBloc bloc;
  setUpAll(() {
    mt.registerFallbackValue(TopRatedTvDataLoaded());
    bloc = MockTopRatedTvBloc();
  });

  test("GetTopRatedTvSeries call TopRatedTvDataLoaded", () async {
    mt.when(() => bloc.state).thenReturn(TopRatedTvInitial());

    final usecase = GetTopRatedTvSeries(bloc);

    await usecase.execute();

    mt
        .verify(() => bloc
            .add(mt.any<TopRatedTvEvent>(that: isA<TopRatedTvDataLoaded>())))
        .called(1);
  });

  test('execute must success', () async {
    whenListen(bloc, const Stream<TopRatedTvEvent>.empty(),
        initialState: TopRatedTvInitial());
    await expectLater(GetTopRatedTvSeries(bloc).execute(), completes);
  });
}
