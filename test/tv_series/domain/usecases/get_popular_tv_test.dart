import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/tv_popular/tv_popular_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mt;

class MockTvPopularBloc extends MockBloc<TvPopularEvent, TvPopularState>
    implements TvPopularBloc {}

void main() {
  late MockTvPopularBloc bloc;
  setUpAll(() {
    mt.registerFallbackValue(TvPopulaDataLoaded());
    bloc = MockTvPopularBloc();
  });

  test("GetPopularTvSeries call TvPopulaDataLoaded", () async {
    mt.when(() => bloc.state).thenReturn(TvPopularInitial());

    final usecase = GetPopularTvSeries(bloc);

    await usecase.execute();

    mt
        .verify(() =>
            bloc.add(mt.any<TvPopularEvent>(that: isA<TvPopulaDataLoaded>())))
        .called(1);
  });

  test('execute must success', () async {
    whenListen(bloc, const Stream<TvPopularState>.empty(),
        initialState: TvPopularInitial());
    await expectLater(GetPopularTvSeries(bloc).execute(), completes);
  });
}
